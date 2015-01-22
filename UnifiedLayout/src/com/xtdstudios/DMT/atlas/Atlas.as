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
package com.xtdstudios.DMT.atlas
{
	import com.xtdstudios.DMT.serialization.ISerializable;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.PNGEncoderOptions;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class Atlas extends EventDispatcher implements ISerializable
	{
		private var m_name			: String;
		private var m_bitmapData	: BitmapData;
		private var m_regions		: Dictionary;
		private var m_frames		: Dictionary;
		
		private var m_width         : int;
		private var m_height        : int;
		private var m_transparent   : Boolean;
		
		public function Atlas() {
			init();
		}

		private function init():void {
			m_regions = new Dictionary();
			m_frames = new Dictionary();
		}

		static public function getAtlas(name:String, bitmapData:BitmapData): Atlas
		{
			var atlas: Atlas = new Atlas();
			atlas.m_name = name;
			atlas.m_bitmapData = bitmapData;

			atlas.m_width = bitmapData.width;
			atlas.m_height = bitmapData.height;
			atlas.m_transparent = bitmapData.transparent;
			return atlas;
		}

		public function toJson():Object {
			var regions : Object = {};
			for (var textureId:String in m_regions)
			{
				var regionRect : Rectangle = m_regions[textureId];
				regions[textureId] = { x:regionRect.x, y:regionRect.y, w:regionRect.width, h:regionRect.height };
				if (m_frames[textureId]) {
					var frameRect : Rectangle = m_frames[textureId];
					regions[textureId].frame = {x:frameRect.x, y:frameRect.y, w:frameRect.width, h:frameRect.height};
				}
			}

			return {
				name: m_name,
				width: m_width,
				height: m_height,
				transparent: m_transparent,
				regions: regions
			};
		}

		public function fromJson(jsonData:Object):void {
			dispose();
			init();

			m_name = jsonData.name;
			m_width = jsonData.width;
			m_height = jsonData.height;
			m_transparent = jsonData.transparent;


			var regionRect : Rectangle;
			var frameRect  : Rectangle;
			var regions    : Object = jsonData.regions;
			for (var textureId:String in regions) {
				var regionData : Object = regions[textureId];
				regionRect = new Rectangle(regionData.x, regionData.y, regionData.w, regionData.h);
				if (regionData.hasOwnProperty('frame')) {
					var frameData : Object = regionData.frame;
					frameRect = new Rectangle(frameData.x, frameData.y, frameData.w, frameData.h);
				}
				else {
					frameRect = null;
				}
				addRegion(textureId, regionRect, frameRect);
			}
		}

		public function encodeBitmap(): ByteArray
		{
			var result : ByteArray = bitmapData.encode(new Rectangle(0, 0, bitmapData.width, bitmapData.height), new PNGEncoderOptions(true));
			
			return result;
		} 
		
		public function decodeBitmap(bitmapPixels:ByteArray):void
		{
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoad);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.loadBytes(bitmapPixels,loaderContext);
			
		} 
		
		protected function onProgress(event:ProgressEvent):void
		{
			dispatchEvent(event);
		} 
		
		private function handleLoad(e:Event):void {
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loaderInfo.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleLoad);
			loaderInfo.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
	

			var bitmapData : BitmapData = (loaderInfo.content as Bitmap).bitmapData;
			
			m_bitmapData = new BitmapData(bitmapData.width, bitmapData.height, true, 0);
			m_bitmapData.draw(bitmapData);
			bitmapData.dispose();
			
			loaderInfo.loader.unloadAndStop();
			
			dispatchEvent(new Event(Event.COMPLETE));
		}		
		
		public function get bitmapData():BitmapData
		{
			return m_bitmapData;
		}

		public function get name():String
		{
			return m_name;
		}

		public function get regions():Dictionary
		{
			return m_regions;
		}
		
		public function getFrame(textureID:String):Rectangle
		{
			return m_frames[textureID];
		}

		public function addRegion(textureID:String, rect:Rectangle, frame:Rectangle):void
		{
			m_regions[textureID] = rect;

			if (frame) {
				m_frames[textureID] = frame;
			}
		}
		
		public function disposeBitmapData():void
		{
			if (m_bitmapData!=null)
			{
				m_bitmapData.dispose();
				m_bitmapData = null;
			}
		}
		
		public function dispose():void
		{
			disposeBitmapData();
			
			m_regions = null;
			m_frames = null;
		}
		
	}
}