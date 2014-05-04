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
	import com.xtdstudios.DMT.persistency.ExRectangle;

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
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;

	public class Atlas extends EventDispatcher implements IExternalizable
	{
		private var m_name			: String;
		private var m_bitmapData	: BitmapData;
		private var m_regions		: Dictionary;
		private var m_frames		: Dictionary;
		
		private var width: int;
		private var height: int;
		private var transparent: Boolean;
		
		public function Atlas() {}
		
		static public function getAtlas(name:String, bitmapData:BitmapData): Atlas
		{
			var atlas: Atlas = new Atlas();
			atlas.m_name = name;
			atlas.m_bitmapData = bitmapData;
			atlas.m_regions = new Dictionary();
			atlas.m_frames = new Dictionary();
			
			atlas.width = bitmapData.width;
			atlas.height = bitmapData.height;
			atlas.transparent = bitmapData.transparent;
			return atlas;
		}
		
		public function writeExternal(output:IDataOutput): void {
			output.writeUTF(m_name);
			output.writeObject(m_regions);
			output.writeObject(m_frames);

			output.writeInt(width);
			output.writeInt(height);
			output.writeBoolean(transparent);
		}
		
		public function readExternal(input:IDataInput): void {
			m_name = input.readUTF();
			m_regions = input.readObject();
			m_frames = input.readObject();
			width = input.readInt();
			height = input.readInt();
			transparent = input.readBoolean();
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
			var result : Dictionary = new Dictionary(true);
			for (var key:String in m_regions)
			{
				result[key] = (m_regions[key] as ExRectangle).rectangle;
			}
			return result;
		}
		
		public function getFrame(textureID:String):Rectangle
		{
			var exRect : ExRectangle = m_frames[textureID];
			if (exRect)
				return exRect.rectangle;
			else
				return null;
		}

		public function addRegion(textureID:String, rect:Rectangle, frame:Rectangle):void
		{
			var exRect : ExRectangle;

			exRect = new ExRectangle();
			exRect.rectangle = rect;
			m_regions[textureID] = exRect;

			if (frame) {
				exRect = new ExRectangle();
				exRect.rectangle = frame;
				m_frames[textureID] = exRect;
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