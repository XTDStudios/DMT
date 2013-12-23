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
	import flash.display.Sprite;
	import flash.events.Event;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import utils.deg2rad;
	
	public class HierarchyExample extends starling.display.Sprite
	{
		[Embed(source="/assets/HierarchyExampleAssets.swf", symbol="RootObj")]				
		public var RootObj:Class;  

		
		// set useCache to false if you have changed the asset to re-generate the cache
		private var dmtBasic: DMTBasic = new DMTBasic("demo.HierarchyExample", true, "3");
		
		private var m_rootObj			: flash.display.Sprite;
		private var m_starlingrootObj	: starling.display.Sprite;
		
		public function HierarchyExample()
		{
			super();
			
			name = "Hierarchy Example";
			initFlash();
			doRasterize();
		}
		
		private function initFlash(): void {
			m_rootObj = new RootObj();
			m_rootObj.x=200;
			m_rootObj.y=200;
			
			Starling.current.nativeStage.addChild(m_rootObj);
		}
		
		
		private function doRasterize(): void {
			dmtBasic.addItemToRaster(m_rootObj, "RootObj");
			
			dmtBasic.addEventListener(flash.events.Event.COMPLETE,dmtComplete);
			dmtBasic.process();
		}
		
		private function dmtComplete(event:flash.events.Event): void {
			initStarlingObjects();
			addEventListener(starling.events.Event.ENTER_FRAME,onEnterFrame); 
		}
		
		private function initStarlingObjects(): void {
			m_starlingrootObj = dmtBasic.getAssetByUniqueAlias("RootObj") as starling.display.Sprite; 
			addChild(m_starlingrootObj);
		}
		
		
		private function rotateLevel2(container:Object, useRadians:Boolean):void
		{
			container.rotation -= useRadians ? deg2rad(0.4) : 0.4;
			
			var smallPoly1 : Object = container.getChildByName("small_poly1"); 			
			var smallPoly2 : Object = container.getChildByName("small_poly2");			
			var smallPoly3 : Object = container.getChildByName("small_poly3");			
			var smallPoly4 : Object = container.getChildByName("small_poly4");
			
			smallPoly1.rotation -= useRadians ? deg2rad(2) : 2;
			smallPoly2.rotation -= useRadians ? deg2rad(2) : 2;
			smallPoly3.rotation -= useRadians ? deg2rad(2) : 2; 
			smallPoly4.rotation -= useRadians ? deg2rad(2) : 2;
		}
		
		private function onEnterFrame(e: starling.events.Event): void {
			m_rootObj.rotation += 0.2;
			rotateLevel2(m_rootObj.getChildByName("north"), false);
			rotateLevel2(m_rootObj.getChildByName("south"), false);
			rotateLevel2(m_rootObj.getChildByName("east"), false);
			rotateLevel2(m_rootObj.getChildByName("west"), false);
			
			m_starlingrootObj.rotation += deg2rad(0.2);
			rotateLevel2(m_starlingrootObj.getChildByName("north"), true);
			rotateLevel2(m_starlingrootObj.getChildByName("south"), true);
			rotateLevel2(m_starlingrootObj.getChildByName("east"), true);
			rotateLevel2(m_starlingrootObj.getChildByName("west"), true);
			
		}
		
		override public function dispose():void
		{
			if (m_rootObj && m_rootObj.parent)
				m_rootObj.parent.removeChild(m_rootObj);
			
			if (m_starlingrootObj)
				removeChild(m_starlingrootObj);
			
			super.dispose();
		}
		
	}
}