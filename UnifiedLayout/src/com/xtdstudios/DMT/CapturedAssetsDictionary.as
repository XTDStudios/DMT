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
	import flash.display.BitmapData;
	import flash.errors.IllegalOperationError;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class CapturedAssetsDictionary
	{
		private var m_dictionary		: Dictionary;
		private var m_count				: int;
		
		public function CapturedAssetsDictionary()
		{
			m_dictionary = new Dictionary();
			m_count = 0;
		}
		
		public function get dictionary():Dictionary
		{
			return m_dictionary;
		}

		public function get count():int
		{
			return m_count;
		}

		public function getCapturedAsset(textureID:String):CapturedAsset
		{
			return m_dictionary[textureID] as CapturedAsset;
		}
		
		public function registerCapturedAsset(id:String, capturedAssetBitmap:BitmapData, frame:Rectangle = null):void
		{
			if (id==null || id=="")
			{
				throw new IllegalOperationError("id cannot be empty");
			}
			
			if (m_dictionary[id]==null)
			{
				var newCapturedAsset : CapturedAsset = new CapturedAsset(id, capturedAssetBitmap, frame);
				m_dictionary[id] = newCapturedAsset;		
				m_count++;
			}
			else
			{
//				trace("A captured asset with the same id already exist, " + id);
			}
			
		}

		public function toVector():Vector.<CapturedAsset>
		{
			var result : Vector.<CapturedAsset> = new Vector.<CapturedAsset>;
			for each(var capturedAsset:CapturedAsset in m_dictionary)
			{
				result.push(capturedAsset);
			}
			
			return result;
		}
		
		public function dispose():void
		{
			m_dictionary = null;
		}
	}
}