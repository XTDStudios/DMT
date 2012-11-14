/*
Copyright 2012 XTD Studios Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package com.xtdstudios.DMT
{
	import com.xtdstudios.DMT.events.AssetGroupEvent;
	import com.xtdstudios.DMT.persistency.ByteArrayPersistencyManager;
	import com.xtdstudios.DMT.persistency.impl.ByteArrayToFilePersistencyManager;
	import com.xtdstudios.DMT.persistency.impl.ExternalAssetsGroupPersistencyManager;
	import com.xtdstudios.common.FileUtils;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.getTimer;

	public class DMTAbsAPI extends EventDispatcher
	{
		private var m_progress						: Number;
		private var m_inProgress					: Boolean;
		private var m_useCache						: Boolean;
		private var m_dataID						: String;
		private var m_maxDepth						: int;
		
		private var m_assetsGroup 					: AssetsGroup;
		private var m_assetsGroupBuilder  			: AssetsGroupBuilder;
		
		protected var m_byteArrayPersistencyManager: ByteArrayPersistencyManager;
		protected var m_assetsGroupPersistencyManager: ExternalAssetsGroupPersistencyManager;
		protected var m_assetsGroupsManager			: AssetsGroupsManager;

		public function DMTAbsAPI(dataID:String, useCache:Boolean=true, cacheVersion:String="1")
		{
			m_useCache = useCache;
			m_dataID = dataID;
			
			m_byteArrayPersistencyManager = new ByteArrayToFilePersistencyManager(FileUtils.getCacheDir());
			// Persistency manager
			m_assetsGroupPersistencyManager = new ExternalAssetsGroupPersistencyManager(m_byteArrayPersistencyManager, cacheVersion);
			
			// Assts Groups Manager
			m_assetsGroupsManager = new AssetsGroupsManager(m_assetsGroupPersistencyManager, m_byteArrayPersistencyManager);
			
			m_progress = 0.0;
			m_inProgress = false;
			super();
		}
		
		public function get inProgress():Boolean
		{
			return m_inProgress;
		}

		public function process(isTransparent:Boolean=true, maxDepth:int=-1, matrixAccuracyPercent:Number=1.0):Boolean
		{
			if (m_inProgress)
				throw new IllegalOperationError("Load already in progress");
			else
				m_inProgress = true;
			
			m_maxDepth = maxDepth;
			m_progress = 0.0;
			
			// if it's not the first time, we have to relase the previous processing elements
			disposeProcessingElements();
			
			// do we have cache?
			if (m_useCache && m_assetsGroupsManager.isCacheExist(m_dataID)==true)
			{
				trace("=== USING CACHE ===");
				try {
					m_assetsGroup = m_assetsGroupsManager.loadCache(m_dataID);
				} catch (e: Error) {
					//If the cache loading failed - recover by rasterizing again
					m_assetsGroupsManager.clearCacheByName(m_dataID);
					processVectors(isTransparent, matrixAccuracyPercent);
					return false;
				}
				loadAtlases();
				return true;
			}
			else
			{
				processVectors(isTransparent, matrixAccuracyPercent);
				return false;
			}
		}
		
		public function loadAtlases():void
		{
			m_assetsGroup.addEventListener(AssetGroupEvent.READY, onAtlasesLoadingComplete);
			m_assetsGroup.addEventListener(ProgressEvent.PROGRESS, onProgress);
			m_assetsGroup.loadAtlases();
		}
		
		protected function onAtlasesLoadingComplete(event:AssetGroupEvent):void
		{
			m_assetsGroup.removeEventListener(AssetGroupEvent.READY, onAtlasesLoadingComplete);
			m_assetsGroup.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			processTextures(m_assetsGroup);
			
			m_inProgress = false;
			m_progress = 1.0;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function onProgress(event:ProgressEvent):void
		{
			m_progress = event.bytesLoaded/event.bytesTotal;
			dispatchEvent(event);
		}
		
		protected function getItemsToRaster():Vector.<ItemToRaster>
		{
			// MUST override
			return null;
		}
		
		protected function processTextures(assetsGroup:AssetsGroup):void
		{
			// Override to use the loaded/created textures
		}		
		
		public function clearCache(): void
		{
			if (m_assetsGroupsManager.isCacheExist(m_dataID)==true)
			{
				trace("=== Clearing cache ===");
				m_assetsGroupsManager.clearCacheByName(m_dataID);
			}
		}
		
		public function cacheExist():Boolean
		{
			return m_assetsGroupsManager.isCacheExist(m_dataID);
		}
		
		private function processVectors(isTransparent:Boolean, matrixAccuracyPercent:Number):void
		{
			// Assets Group Builder
			m_assetsGroupBuilder = m_assetsGroupsManager.build(m_dataID, isTransparent, matrixAccuracyPercent);
			m_assetsGroupBuilder.scaleEffects = true;
			
			for each(var itemToRaster:ItemToRaster in getItemsToRaster())
			{
				m_assetsGroupBuilder.rasterize(itemToRaster.displayObject, itemToRaster.uniqueID, m_maxDepth);
			}
			
			m_assetsGroupBuilder.addEventListener(ProgressEvent.PROGRESS, onProgress);
			m_assetsGroupBuilder.addEventListener(AssetGroupEvent.READY, onGenerateComplete);
			
			m_assetsGroup = m_assetsGroupBuilder.generate();
		}
		
		protected function onGenerateComplete(event:AssetGroupEvent):void
		{
//			trace("=== Generate Completed ===");
			m_assetsGroupBuilder.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			m_assetsGroupBuilder.removeEventListener(AssetGroupEvent.READY, onGenerateComplete);
			m_assetsGroupBuilder.dispose();
			
			m_assetsGroup = event.assetGroup;
			if (m_useCache==true)
				m_assetsGroupsManager.saveCache(m_assetsGroup);
			onTexturesReady();
		}
		
		private function onTexturesReady():void
		{
			processTextures(m_assetsGroup);
			
			m_inProgress = false;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get atlasesList():Array
		{
			return m_assetsGroup.atlasesList;
		}
		
		public function get progress():Number
		{
			return m_progress;
		}
		
		protected function disposeProcessingElements():void
		{
			if (m_assetsGroup)
			{
				m_assetsGroup.dispose();
				m_assetsGroup = null;
			}
		}
		
		public function dispose():void
		{
			// TODO: Stop loading is in progress
			
			disposeProcessingElements();
			
			if (m_assetsGroupsManager)
			{
				m_assetsGroupsManager.get(m_dataID).dispose();
				m_assetsGroupsManager = null;
			}
			
			if (m_assetsGroupPersistencyManager)
			{
				m_assetsGroupPersistencyManager.dispose();		
				m_assetsGroupPersistencyManager = null;
			}
			
			if (m_assetsGroupBuilder)
			{
				m_assetsGroupBuilder.dispose();		
				m_assetsGroupBuilder = null;
			}
		}
		
	}
}