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
	import flash.geom.Rectangle;

	public class CapturedAsset
	{
		private var m_bitmapData	: BitmapData;
		private var m_id			: String;
		private var m_frame			: Rectangle;
		
		public function CapturedAsset(id:String, bitmapData:BitmapData, frame:Rectangle = null)
		{
			m_bitmapData = bitmapData;
			m_id = id;
			m_frame = frame;
		}

		public function get id():String
		{
			return m_id;
		}

		public function get bitmapData():BitmapData
		{
			return m_bitmapData;
		}

		public function get frame():Rectangle
		{
			return m_frame;
		}
	}
}