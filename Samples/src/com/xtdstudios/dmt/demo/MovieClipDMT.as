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
	import com.xtdstudios.DMT.DMTBasic;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	
	public class MovieClipDMT extends starling.display.Sprite
	{
		[Embed(source="/assets/MovieClipExampleAssets.swf", symbol="MovieClipExample")]				
		public var MovieClipExampleClass:Class; 
		
		// set useCache to false if you have changed the asset to re-generate the cache
		private var dmtBasic: DMTBasic = new DMTBasic("demo.MovieClipDMT", GlobalConsts.USE_CACHE, GlobalConsts.CACHE_VERSION); 
		
		private var m_flashMC				: flash.display.MovieClip;
		private var m_starlingMC			: starling.display.MovieClip;
		private var m_displayObjects		: Vector.<flash.display.DisplayObject>;
		 
		public function MovieClipDMT()
		{
			super();
			
			name = "MovieClip DMT";
			m_displayObjects = new Vector.<flash.display.DisplayObject>();
			initFlash();
			doRasterize();
		}
		
		private function initFlash(): void {
			m_flashMC = new MovieClipExampleClass();
			m_flashMC.x=200;
			m_flashMC.y=200;
			m_flashMC.name="flashMC";
			Starling.current.nativeStage.addChild(m_flashMC);
		}
		
		override public function dispose():void
		{
			if (m_flashMC && m_flashMC.parent)
				m_flashMC.parent.removeChild(m_flashMC);
			
			if (m_starlingMC)
				removeChild(m_starlingMC);
			
			super.dispose();
		}
		
		private function doRasterize(): void {
			m_displayObjects.push(m_flashMC);
			
			dmtBasic.addItemsToRaster(m_displayObjects);
			
			dmtBasic.addEventListener(flash.events.Event.COMPLETE, dmtComplete);
			dmtBasic.process();
		}
		
		private function dmtComplete(event:flash.events.Event): void {
			initStarlingObjects();
		}
		
		private function initStarlingObjects(): void {
			m_flashMC.gotoAndPlay(1);
			
			m_starlingMC = dmtBasic.getAssetByUniqueAlias("flashMC") as starling.display.MovieClip;
			m_starlingMC.fps = Starling.current.nativeStage.frameRate;
			Starling.current.juggler.add(m_starlingMC);
			addChild(m_starlingMC);
		}
	}
}