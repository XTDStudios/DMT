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
package com.xtdstudios.common
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class BitmapUtils
	{
		public function BitmapUtils()
		{
		}
		
		public static function captureToBitmap(objectToDraw:DisplayObject, w:Number, h:Number, shadowMargins:int=20):Bitmap
		{
			var mat			: Matrix = new Matrix();
			mat.scale(w/objectToDraw.width, h/objectToDraw.height);
			mat.translate(shadowMargins, shadowMargins);
			
			var capturedBitmapData : BitmapData = new BitmapData(w+(shadowMargins*2), h+(shadowMargins*2), true, 0);
			capturedBitmapData.draw(objectToDraw, mat);
			
			var bitmap : Bitmap = new Bitmap(capturedBitmapData, PixelSnapping.ALWAYS, false);
			bitmap.x = -shadowMargins;
			bitmap.y = -shadowMargins;
			
			return bitmap;
		}
		
		public static function freeBitmap(bitmap:Bitmap):void
		{
			if (bitmap!=null)
			{
				if (bitmap.parent!=null)
				{
					bitmap.parent.removeChild(bitmap);
				}
				
				var bitmapData:BitmapData = bitmap.bitmapData;
				if (bitmapData!=null)
				{
					bitmapData.dispose();
					bitmapData = null;
				}
				bitmap = null;
			}
		}
		
	}
}