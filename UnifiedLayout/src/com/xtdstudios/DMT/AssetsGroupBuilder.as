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
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;

	public interface AssetsGroupBuilder extends IEventDispatcher
	{
		function get scaleEffects():Boolean;
		function set scaleEffects(value:Boolean):void;
		function get stopRasterNames():Vector.<String>;
		function set stopRasterNames(value:Vector.<String>):void;
		function rasterize(displayObject:DisplayObject, uniqueAlias:String=null, maxDepth:int=-1, fitToRect:Rectangle=null, bestFitWithoutStretching:Boolean=true):void;
		function rasterizeVector(displayObjects:Vector.<DisplayObject>, maxDepth:int=-1, fitToRect:Rectangle=null, bestFitWithoutStretching:Boolean=true):void;
		function generate():AssetsGroup;
		function get assetsGroup():AssetsGroup;
		function dispose():void;
	}
}