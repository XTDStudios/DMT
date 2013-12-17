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
package com.xtdstudios.dmt.demo
{
	import com.xtdstudios.DMT.AssetGroupConverter;
	import com.xtdstudios.DMT.AssetsGroup;
	import com.xtdstudios.DMT.AssetsGroupBuilder;
	import com.xtdstudios.DMT.AssetsGroupsManager;
	import com.xtdstudios.DMT.events.AssetGroupEvent;
	import com.xtdstudios.DMT.persistency.AssetsGroupPersistencyManager;
	import com.xtdstudios.DMT.persistency.ByteArrayPersistencyManager;
	import com.xtdstudios.DMT.persistency.impl.ByteArrayToFilePersistencyManager;
	import com.xtdstudios.DMT.persistency.impl.ExternalAssetsGroupPersistencyManager;
	import com.xtdstudios.DMT.starlingConverter.StarlingConverter;
	import com.xtdstudios.common.FileUtils;
	import com.xtdstudios.dmt.demo.assets.Square;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.ProgressEvent;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	public class CoreAPI extends starling.display.Sprite
	{
		
		private var flashSquare50: flash.display.Sprite;
		private var flashSquare50_r: flash.display.Sprite;
		private var flashSquare50_2: flash.display.Sprite;
		
		private var starlingSquare: starling.display.DisplayObject;
		private var m_displayObjects	: Vector.<flash.display.DisplayObject>;

		private var m_byteArrayPersistencyManager:ByteArrayPersistencyManager;

		private var m_assetsGroupPersistencyManager:AssetsGroupPersistencyManager;

		private var m_assetsGroupsManager:*;

		private var m_assetsGroup1:AssetsGroup;
		private var m_assetsGroup2:AssetsGroup;
		private var m_assetsGroup3:AssetsGroup;

		private const CACHE_ID: String = "1";
		private const group1Name: String = "g1";
		private const group2Name: String = "g2";
		private const group3Name: String = "g3";
		
		public function CoreAPI()
		{
			super();
			name = "Core API Example";
			
			initDMT();
			initFlash();
			generateAssets();
		}
		
		private function initDMT(): void {
			m_byteArrayPersistencyManager = new ByteArrayToFilePersistencyManager(FileUtils.getCacheDir());
			// Persistency manager
			m_assetsGroupPersistencyManager = new ExternalAssetsGroupPersistencyManager(m_byteArrayPersistencyManager, GlobalConsts.CACHE_VERSION);
			
			// Assts Groups Manager
			m_assetsGroupsManager = new AssetsGroupsManager(m_assetsGroupPersistencyManager, m_byteArrayPersistencyManager);
		}
		
		private function disposeDMT(): void {
			if (m_assetsGroup1)
				m_assetsGroup1.dispose();
			if (m_assetsGroup2)
				m_assetsGroup2.dispose();
			if (m_assetsGroup3)
				m_assetsGroup3.dispose();
			if (m_assetsGroupsManager) 
				m_assetsGroupsManager.dispose();
			if (m_assetsGroupPersistencyManager)	
				m_assetsGroupPersistencyManager.dispose();
			if (m_byteArrayPersistencyManager)
				m_byteArrayPersistencyManager.dispose();
			
		}
		
		private function initFlash(): void {
			flashSquare50 = new Square(50,-25,-25);
			flashSquare50.x=100;
			flashSquare50.y=100;
			flashSquare50.name="Square50";
			Starling.current.nativeStage.addChild(flashSquare50);
			
			flashSquare50_r = new Square(50,-25,-25);
			flashSquare50_r.x=100;
			flashSquare50_r.y=200;
			flashSquare50_r.name="Square50_r";
			Starling.current.nativeStage.addChild(flashSquare50_r);
			
			flashSquare50_2 = new Square(50,-25,-25);
			flashSquare50_2.x=200;
			flashSquare50_2.y=200;
			flashSquare50_2.name="Square50_2";
			Starling.current.nativeStage.addChild(flashSquare50_2);
		}
		
		override public function dispose():void
		{
			if (flashSquare50 && flashSquare50.parent)
				flashSquare50.parent.removeChild(flashSquare50);
			if (flashSquare50_r && flashSquare50_r.parent)
				flashSquare50_r.parent.removeChild(flashSquare50_r);
			if (flashSquare50_2 && flashSquare50_2.parent)
				flashSquare50_2.parent.removeChild(flashSquare50_2);
			
			if (starlingSquare)
				removeChild(starlingSquare);
			
			disposeDMT();
			
			super.dispose();
		}
		
		private function generateAssets(): void {
			if (m_assetsGroupsManager.isCacheExist(group1Name)) {
				trace("Using cached files");
				try {
					m_assetsGroup1 = m_assetsGroupsManager.loadCache(group1Name);
					loadAtlases();
				} catch (e: Error) {
					//If the cache loading failed - recover by delete the cache and rasterize again
					m_assetsGroupsManager.clearCacheByName(group1Name);
					generateAssets();
				}
			} else {
				trace("No cache exist. rasterizing...");
				var builder : AssetsGroupBuilder = m_assetsGroupsManager.build(group1Name, true);
				
				builder.scaleEffects = true;
				builder.rasterize(flashSquare50);
				builder.rasterize(flashSquare50_r);
				builder.rasterize(flashSquare50_2);
				
				builder.addEventListener(ProgressEvent.PROGRESS, onDMTProgress);
				builder.addEventListener(AssetGroupEvent.READY, dmtComplete);
				
				builder.generate();
			}
		}
		
		
		protected function onDMTProgress(event:ProgressEvent):void
		{
			trace("DMT rasterazing progress ", event.bytesLoaded, "/", event.bytesTotal, "(", event.bytesLoaded/event.bytesTotal*100, "%)");
		}
		
		private function dmtComplete(event:AssetGroupEvent): void {
			trace("DMT completed");
			event.target.removeEventListener(ProgressEvent.PROGRESS, onDMTProgress);
			event.target.removeEventListener(AssetGroupEvent.READY, dmtComplete);
			
			m_assetsGroup1 = event.assetGroup;
			m_assetsGroupsManager.saveCache(m_assetsGroup1);
			
			initStarlingObjects();
		}
		
		public function loadAtlases():void
		{
			m_assetsGroup1.addEventListener(AssetGroupEvent.READY, onAtlasesLoadingComplete);
			m_assetsGroup1.addEventListener(ProgressEvent.PROGRESS, onAtlasesLoadingProgress);
			m_assetsGroup1.loadAtlases();
		}
		
		protected function onAtlasesLoadingComplete(event:AssetGroupEvent):void
		{
			m_assetsGroup1.removeEventListener(AssetGroupEvent.READY, onAtlasesLoadingComplete);
			m_assetsGroup1.removeEventListener(ProgressEvent.PROGRESS, onAtlasesLoadingProgress);
			initStarlingObjects();
		}
		
		protected function onAtlasesLoadingProgress(event:ProgressEvent):void
		{
			trace("Loading cache progress ", event.bytesLoaded, "/", event.bytesTotal, "(", event.bytesLoaded/event.bytesTotal*100, "%)");
		}
		
		private function initStarlingObjects(): void {
//			starlingSquare = dmtBasic.getAssetByUniqueAlias("Square");
			var m_converter:AssetGroupConverter = new StarlingConverter(m_assetsGroup1);
			starlingSquare = m_converter.convert("Square50") as starling.display.DisplayObject;
			addChild(starlingSquare);
			addChild(m_converter.convert("Square50_r") as starling.display.DisplayObject);
			addChild(m_converter.convert("Square50_2") as starling.display.DisplayObject);
		}
		
	}
}