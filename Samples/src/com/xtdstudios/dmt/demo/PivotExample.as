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
	import com.xtdstudios.dmt.demo.assets.Square;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import utils.deg2rad;
	
	public class PivotExample extends starling.display.Sprite
	{
		// set useCache to false if you have changed the asset to re-generate the cache
		private var dmtBasic: DMTBasic = new DMTBasic("demo.PivotExample", true, "1");
		
		private var m_flashSquare1				: flash.display.Sprite;
		private var m_flashSquare2				: flash.display.Sprite;
		private var m_flashSquare3				: flash.display.Sprite;
		private var m_starlingSquare1			: starling.display.DisplayObject;
		private var m_starlingSquare2			: starling.display.DisplayObject;
		private var m_starlingSquare3			: starling.display.DisplayObject;
		private var m_pivotPointscontainer		: flash.display.Sprite;
		private var m_displayObjects			: Vector.<flash.display.DisplayObject>;
		private var m_starlingStartY			: int;
		
		public function PivotExample()
		{
			super();
			
			name = "Pivot (With effects) Example";
			m_starlingStartY = Starling.current.viewPort.y;
			m_displayObjects = new Vector.<flash.display.DisplayObject>();
			initFlash();
			doRasterize();
		}
		
		private function initFlash(): void {
			m_flashSquare1 = new Square(50,0,0);
			m_flashSquare1.x=100;
			m_flashSquare1.y=100;
			m_flashSquare1.filters = [new GlowFilter(0x333333, 1, 14, 14, 0.6)];
			Starling.current.nativeStage.addChild(m_flashSquare1);
			
			m_flashSquare2 = new Square(50,-25,-25);
			m_flashSquare2.x=250;
			m_flashSquare2.y=100;
			m_flashSquare2.filters = [new GlowFilter(0x333333, 1, 14, 14, 0.6)];
			Starling.current.nativeStage.addChild(m_flashSquare2);
			
			m_flashSquare3 = new Square(50,15,15);
			m_flashSquare3.x=400;
			m_flashSquare3.y=100;
			m_flashSquare3.filters = [new GlowFilter(0x333333, 1, 14, 14, 0.6)];
			Starling.current.nativeStage.addChild(m_flashSquare3);
			
			m_pivotPointscontainer = new flash.display.Sprite();
			Starling.current.nativeStage.addChild(m_pivotPointscontainer);
			
			drawPivotPoint(m_flashSquare1.x, m_flashSquare1.y);
			drawPivotPoint(m_flashSquare2.x, m_flashSquare2.y);
			drawPivotPoint(m_flashSquare3.x, m_flashSquare3.y);
		}
		
		
		private function doRasterize(): void {
			m_flashSquare1.name="Square1";
			m_flashSquare2.name="Square2";
			m_flashSquare3.name="Square3";

			m_displayObjects.push(m_flashSquare1);
			m_displayObjects.push(m_flashSquare2);
			m_displayObjects.push(m_flashSquare3);
			
			dmtBasic.addItemsToRaster(m_displayObjects);
			
			dmtBasic.addEventListener(flash.events.Event.COMPLETE,dmtComplete);
			dmtBasic.process();
		}
		
		private function dmtComplete(event:flash.events.Event): void {
			initStarlingObjects();
			addEventListener(starling.events.Event.ENTER_FRAME,onEnterFrame);
		}
		
		private function initStarlingObjects(): void {
			m_starlingSquare1 = dmtBasic.getAssetByUniqueAlias("Square1");
			addChild(m_starlingSquare1);
			m_starlingSquare2 = dmtBasic.getAssetByUniqueAlias("Square2");
			addChild(m_starlingSquare2);
			m_starlingSquare3 = dmtBasic.getAssetByUniqueAlias("Square3");
			addChild(m_starlingSquare3);
			
			drawPivotPoint(m_starlingSquare1.x, m_starlingSquare1.y+m_starlingStartY);
			drawPivotPoint(m_starlingSquare2.x, m_starlingSquare2.y+m_starlingStartY);
			drawPivotPoint(m_starlingSquare3.x, m_starlingSquare3.y+m_starlingStartY);
		}
		
		private function onEnterFrame(e: starling.events.Event): void {
			m_flashSquare1.rotation += 2;
			m_flashSquare2.rotation += 2;
			m_flashSquare3.rotation += 2;
			m_starlingSquare1.rotation += deg2rad(2);
			m_starlingSquare2.rotation += deg2rad(2);
			m_starlingSquare3.rotation += deg2rad(2);
		}
		
		private function drawPivotPoint(x:int, y:int):void
		{
			m_pivotPointscontainer.graphics.lineStyle(1, 0x333333);
			m_pivotPointscontainer.graphics.moveTo(x, y-10);
			m_pivotPointscontainer.graphics.lineTo(x, y+10);
			m_pivotPointscontainer.graphics.moveTo(x-10, y);
			m_pivotPointscontainer.graphics.lineTo(x+10, y);
		}
		
		override public function dispose():void
		{
			m_flashSquare1.parent.removeChild(m_flashSquare1);
			m_flashSquare2.parent.removeChild(m_flashSquare2);
			m_flashSquare3.parent.removeChild(m_flashSquare3);
			m_pivotPointscontainer.parent.removeChild(m_pivotPointscontainer);
			
			removeChild(m_starlingSquare1);
			removeChild(m_starlingSquare2);
			removeChild(m_starlingSquare3);
			
			super.dispose();
		}
		
	}
}