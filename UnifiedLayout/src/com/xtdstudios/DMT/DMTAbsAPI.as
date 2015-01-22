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
	import com.xtdstudios.DMT.persistency.IAssetsGroupPersistencyManager;
	import com.xtdstudios.DMT.persistency.IByteArrayPersistencyManager;
	import com.xtdstudios.DMT.persistency.impl.AssetGroupToFilePersistencyManagerFactory;
	import com.xtdstudios.DMT.persistency.impl.ByteArrayToFilePersistencyManagerFactory;

	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;

	public class DMTAbsAPI extends EventDispatcher
	{
		private var m_progress						: Number;
		private var m_inProgress					: Boolean;
		private var m_maxDepth						: int;
		private var m_stopRasterNames				: Vector.<String>;

		private var m_assetsGroupBuilder  			: AssetsGroupBuilder;

		protected var m_assetsGroupsManager			: AssetsGroupsManager;
		protected var m_useCache					: Boolean;

		public function DMTAbsAPI(useCache:Boolean=true, cacheVersion:String="1", byteArrayPersistencyManager:IByteArrayPersistencyManager = null, assetsGroupPersistencyManager:IAssetsGroupPersistencyManager = null)
		{
			m_useCache = useCache;
			m_stopRasterNames = new Vector.<String>;
			m_stopRasterNames.push('stop_raster');

			if (useCache)
			{
				// Byte Array Persistency manager
				if (byteArrayPersistencyManager==null)
					byteArrayPersistencyManager = ByteArrayToFilePersistencyManagerFactory.generate(null); // null means cache directory

				// Assets Groups Persistency manager
				if (assetsGroupPersistencyManager==null)
					assetsGroupPersistencyManager = AssetGroupToFilePersistencyManagerFactory.generate(cacheVersion, null);
			}

			// Assets Groups Manager
			m_assetsGroupsManager = new AssetsGroupsManager(assetsGroupPersistencyManager, byteArrayPersistencyManager);
			
			m_progress = 0.0;
			m_inProgress = false;
			super();
		}

		public function set byteArrayPersistencyManager(value:IByteArrayPersistencyManager):void {
			m_assetsGroupsManager.byteArrayPersistencyManager = value;
		}

		public function set assetsGroupPersistencyManager(value:IAssetsGroupPersistencyManager):void {
			m_assetsGroupsManager.assetsGroupPersistencyManager = value;
		}

		public function get inProgress():Boolean
		{
			return m_inProgress;
		}

		public function get stopRasterNames():Vector.<String>
		{
			return m_stopRasterNames;
		}

		protected function getAssetsGroup(assetsGroupName: String): AssetsGroup {
			var assetsGroup:AssetsGroup = m_assetsGroupsManager.get(assetsGroupName);
			if (!assetsGroup)
				throw new IllegalOperationError("Group not exist");
			return assetsGroup;
		}
		
		/* API */
		protected function _process(assetsGroupName: String, isTransparent:Boolean=true, maxDepth:int=-1, allow4096Textures:Boolean=false, matrixAccuracyPercent:Number=1.0):Boolean //Think about feature & prommis instead of boolean
		{
			var assetsGroup:AssetsGroup = m_assetsGroupsManager.get(assetsGroupName);
			
			if (m_inProgress)
				throw new IllegalOperationError("Load already in progress");
			else
				m_inProgress = true;
			
			m_maxDepth = maxDepth;
			m_progress = 0.0;
			
			// if it's not the first time, we have to relase the previous processing elements
			if (assetsGroup)
				disposeGroup(assetsGroupName);
	//			throw new IllegalOperationError("Group already exist");
			
			// do we have cache?
			if (m_useCache && m_assetsGroupsManager.isCacheExist(assetsGroupName)==true)
			{
				trace("=== USING CACHE ===");
				try {
					assetsGroup = m_assetsGroupsManager.loadFromCache(assetsGroupName);
				} catch (e: Error) {
					//If the cache loading failed - recover by rasterizing again
					m_assetsGroupsManager.clearCacheByName(assetsGroupName);
					processVectors(assetsGroupName, isTransparent, allow4096Textures, matrixAccuracyPercent);
					return false;
				}
				loadAtlases(assetsGroupName);
				return true;
			}
			else
			{
				processVectors(assetsGroupName, isTransparent, allow4096Textures, matrixAccuracyPercent);
				return false;
			}
		}

		
		/* API */
		protected function loadAtlases(assetsGroupName: String):void
		{
			var assetsGroup:AssetsGroup = getAssetsGroup(assetsGroupName);
			assetsGroup.addEventListener(AssetGroupEvent.READY, onAtlasesLoadingComplete);
			assetsGroup.addEventListener(ProgressEvent.PROGRESS, onProgress);
			assetsGroup.loadAtlases();
		}
		
		protected function onAtlasesLoadingComplete(event:AssetGroupEvent):void
		{
			var assetsGroup:AssetsGroup = event.assetGroup;
			assetsGroup.removeEventListener(AssetGroupEvent.READY, onAtlasesLoadingComplete);
			assetsGroup.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			processTextures(assetsGroup);
			
			//TODO: use aggrigated process of all assets groups
			m_inProgress = false;
			m_progress = 1.0;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function onProgress(event:ProgressEvent):void
		{
			//TODO: use aggrigated process of all assets groups
			m_progress = event.bytesLoaded/event.bytesTotal;
			dispatchEvent(event);
		}
		
		protected /* abstract */ function getItemsToRaster(assetsGroupName: String):Vector.<ItemToRaster>
		{
			// MUST override
			return null;
		}
		
		protected  /* abstract */ function processTextures(assetsGroup:AssetsGroup):void
		{
			// Override to use the loaded/created textures
		}		
		
		/* API */
		protected function clearCache(assetsGroupName: String): void
		{
			if (!assetsGroupName) {
				if (m_assetsGroupsManager.isCacheExist(assetsGroupName)==true)
				{
					trace("=== Clearing cache ===");
					m_assetsGroupsManager.clearCacheByName(assetsGroupName);
				}
			} else {
				for (var k:String in m_assetsGroupsManager.getAssetGroupsDictionary) {
					clearCache(k);
				}
			}
		}
		
		/* API */
		protected function _cacheExist(assetsGroupName: String):Boolean
		{
			return m_assetsGroupsManager.isCacheExist(assetsGroupName);
		}
		
		private function processVectors(assetsGroupName: String, isTransparent:Boolean, allow4096Textures:Boolean, matrixAccuracyPercent:Number):void
		{
			// Assets Group Builder
			m_assetsGroupBuilder = m_assetsGroupsManager.build(assetsGroupName, isTransparent, allow4096Textures, matrixAccuracyPercent);
			m_assetsGroupBuilder.stopRasterNames = m_stopRasterNames;
			m_assetsGroupBuilder.scaleEffects = true;

			var itemsToRaster : Vector.<ItemToRaster> = getItemsToRaster(assetsGroupName);
			if (itemsToRaster.length == 0) {
				throw new IllegalOperationError("No items to rasterize");
			}
			else
			{
				for each(var itemToRaster:ItemToRaster in itemsToRaster)
				{
					m_assetsGroupBuilder.rasterize(itemToRaster.displayObject, itemToRaster.uniqueID, m_maxDepth);
				}

				m_assetsGroupBuilder.addEventListener(ProgressEvent.PROGRESS, onProgress);
				m_assetsGroupBuilder.addEventListener(AssetGroupEvent.READY, onGenerateComplete);

				var assetsGroup:AssetsGroup = m_assetsGroupBuilder.generate();
			}
		}
		
		protected function onGenerateComplete(event:AssetGroupEvent):void
		{
//			trace("=== Generate Completed ===");
			m_assetsGroupBuilder.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			m_assetsGroupBuilder.removeEventListener(AssetGroupEvent.READY, onGenerateComplete);
			m_assetsGroupBuilder.dispose();
			
			var assetsGroup:AssetsGroup = event.assetGroup;
			if (m_useCache==true)
				m_assetsGroupsManager.saveCache(assetsGroup);
			onTexturesReady(assetsGroup);
		}
		
		private function onTexturesReady(assetsGroup:AssetsGroup):void
		{
			processTextures(assetsGroup);
			
			m_inProgress = false;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get progress():Number
		{
			return m_progress;
		}
		
		/* API */
		protected function disposeGroup(assetsGroupName: String):void
		{
			var assetsGroup:AssetsGroup = getAssetsGroup(assetsGroupName);
			if (assetsGroup)
			{
				assetsGroup.dispose();
				assetsGroup = null;
			}
		}
		
		public function dispose():void
		{
			// TODO: Stop loading if in progress
			
			if (m_assetsGroupsManager)
			{
				m_assetsGroupsManager.dispose();
				m_assetsGroupsManager = null;
			}
			
			if (m_assetsGroupBuilder)
			{
				m_assetsGroupBuilder.dispose();		
				m_assetsGroupBuilder = null;
			}
		}
		
	}
}