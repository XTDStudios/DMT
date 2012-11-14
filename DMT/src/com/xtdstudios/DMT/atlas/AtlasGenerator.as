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
	import com.xtdstudios.DMT.CapturedAsset;
	import com.xtdstudios.DMT.CapturedAssetsDictionary;
	import com.xtdstudios.common.threads.IRunnable;
	
	import flash.display.BitmapData;
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.villekoskela.utils.RectanglePacker;

	public class AtlasGenerator implements IRunnable
	{
		private static const TEXTURES_PADDING 	: int = 2;
		private static const ATLAS_MAX_WIDTH	: int = 2048;
		private static const ATLAS_MAX_HEIGHT	: int = 2048;
		
		public var nameExt: String = ".png";
		
		private var m_generatedResult 		: Vector.<Atlas> = new Vector.<Atlas>;
		private var m_atlasName				: String;
		private var m_capturedAssets		: CapturedAssetsDictionary;
		private var m_processedPercent		: Number;
		private var m_processedRectangles	: int;
		private var m_rectanglesToProcess	: int;
		private var m_itemsToProcess		: int;
		private var m_extractedRectangles 	: Vector.<Rectangle>;	
		private var m_sourceTexturesDict 		: Dictionary;
		
		public function AtlasGenerator(atlasName:String, capturedAssets:CapturedAssetsDictionary, itemsToProcess:int)
		{
			m_atlasName = atlasName;
			m_capturedAssets = capturedAssets;
			m_processedPercent = 0;
			m_processedRectangles = 0;
			m_rectanglesToProcess = 0;
			m_itemsToProcess = itemsToProcess;
			m_generatedResult = new Vector.<Atlas>;
		}
		
		public function get generatedResult():Vector.<Atlas>
		{
			return m_generatedResult;
		}

		private function calculateAtlasSize(rectangles:Vector.<Rectangle>): Rectangle {
			var area: int = 0;
			var mostWidth: int = 0;
			var mostHeight: int = 0;
			for each (var r:Rectangle in rectangles) 
			{
				area = area + r.height*r.width;
				mostWidth = Math.max(mostWidth,r.width);
				mostHeight = Math.max(mostHeight,r.height);
			}
			if (mostWidth>2048 || mostHeight>2048)
			{
				var m : int = Math.max(mostWidth,mostHeight);
				throw new IllegalOperationError("Can't use bitmaps larger than 2048 (found size of "+m+")");
			}
			
			var width: int = nextPowerOfTwo(Math.sqrt(area));
			var height: int = nextPowerOfTwo(Math.log(area));
			var sorter: Function = sortOnArea;
			
			if (mostWidth > mostHeight) {
				width=nextPowerOfTwo(mostWidth);
				height=nextPowerOfTwo(Math.max(mostHeight, area / width));
				while (height > 2048) {
					width*=2;
					height=nextPowerOfTwo(area / width);
				}
				width = Math.min(width,2048); 
				sorter=sortOnWidth;
			} else {
				height=nextPowerOfTwo(mostHeight);
				width=nextPowerOfTwo(Math.max(mostWidth, area / height));
				while (width > 2048) {
					height*=2;
					width=nextPowerOfTwo(area / height);
				}
				height = Math.min(height,2048); 
				sorter=sortOnHeight;
			}
			
			rectangles.sort(sorter);
			return new Rectangle(0,0,width,height);
		}
		
		
		private function doBinSolving(atlasSize:Rectangle, rectangles:Vector.<Rectangle>): Dictionary
		{
			var solvedRectangles: Dictionary = new Dictionary;
			
			var start:int = flash.utils.getTimer();
			var mPacker:RectanglePacker = new RectanglePacker(atlasSize.width, atlasSize.height, TEXTURES_PADDING);
			
			var r:Rectangle;
			var unSolvedRectangles :  Vector.<Rectangle> = new Vector.<Rectangle>;
			while (rectangles.length > 0) {
				r = rectangles.pop();
				if (!mPacker.insertRectangle(r)) {
					//rectangles.push(r);
					unSolvedRectangles.push(r);
					trace("Fail to insert Rectangle!");
				} else  {
					solvedRectangles[r] = r;
				}
			}
			for each (r in unSolvedRectangles) 
			{
				rectangles.push(r);
			}
			if (rectangles.length > 0 && (atlasSize.width < 2048 || atlasSize.height < 2048))
			{
				/* If the atlas not in max size, but there is still unsolved rectangles we took wrong sizes guess
				 * so we duplicate the size and retry.
				*/
				trace("Wrong atlas size guest - retry with duplicate size");
				if (atlasSize.width > atlasSize.height)
				{
					atlasSize.height *= 2;
				} 
				else
				{
					atlasSize.width *= 2;
				}
				for each (r in solvedRectangles) 
				{
					rectangles.push(r);
				}
				return doBinSolving(atlasSize, rectangles);
			}
			
			var end:int = flash.utils.getTimer();
			trace("BinSolving total time: " + (end - start).toString());
			
			return solvedRectangles;
		}
		
		private function generateBitmapData(atlasSize:Rectangle): BitmapData {
			var atlasBitmapData : BitmapData = new BitmapData(atlasSize.width, atlasSize.height);
			atlasBitmapData.fillRect(atlasSize, 0x00000000);
			return atlasBitmapData;
		}
		
		private function sortOnArea(a:Rectangle, b:Rectangle):Number
		{
			if (a.width*a.height > b.width*b.height)
			{
				return 1;
			}
			if (a.width*a.height == b.width*b.height) 
			{
				if (a.height > b.height) 
				{
					return 1;
				}
			}
			return -1;
		}
		
		private var c: int = 0;
		private function sortOnWidth(a:Rectangle, b:Rectangle):Number
		{
//			c++;
			if (a.width > b.width)
			{
				return 1;
			}
			return -1;
		}
		private function sortOnHeight(a:Rectangle, b:Rectangle):Number
		{
			c++;
			if (a.height > b.height)
			{
				return 1;
			}
			return -1;
		}
		
//		private function nextPowerOfTwo(number:uint, currentPower:uint=1):uint
//		{
//			if (number<currentPower)
//				return currentPower;
//			else
//				return nextPowerOfTwo(number, currentPower*2);
//		}
		
		private function nextPowerOfTwo(n: uint): uint {
			// Divide by 2^k for consecutive doublings of k up to 32,
			n--;           // 1000 0011 --> 1000 0010
			n |= n >> 1;   // 1000 0010 | 0100 0010 = 1100 0011
			n |= n >> 2;   // 1100 0011 | 0011 0000 = 1111 0011
			n |= n >> 4;   // 1111 0011 | 0000 1111 = 1111 1111
			n |= n >> 8;   // ... (At this point all bits are 1, so further bitwise-or
			n |= n >> 16;  //      operations produce no effect.)
			n++; 
			return n;
		}
		
		private function extractRectangles():void
		{
			var rect 	: Rectangle;

			// we need to know what is the relation between rectange and each bitmapData
			m_sourceTexturesDict = new Dictionary();
			
			// do Bin Solving
			m_extractedRectangles = new Vector.<Rectangle>;
			for each(var capturedAsset:CapturedAsset in m_capturedAssets.dictionary)
			{
				rect = new Rectangle(0, 0, capturedAsset.bitmapData.width, capturedAsset.bitmapData.height);
				m_extractedRectangles.push(rect);
				
				m_sourceTexturesDict[rect] = capturedAsset;
			}
			
			m_rectanglesToProcess = m_extractedRectangles.length;
		}
		
		private function copyBitmaps():void
		{
			var rect 				: Rectangle;
			var atlasBitmapData		: BitmapData
			var resultAtlas			: Atlas;
			
			var atlasSize:Rectangle = calculateAtlasSize(m_extractedRectangles);
			var solvedRectangles:Dictionary = doBinSolving(atlasSize, m_extractedRectangles);
			
			var nameSufix: String = m_generatedResult.length.toString();
			// create the result atlas
			atlasBitmapData = generateBitmapData(atlasSize);
			resultAtlas = Atlas.getAtlas(m_atlasName+nameSufix+nameExt, atlasBitmapData);
			
			// create the atlas bitmap data
			for each (var rectKey:Rectangle in solvedRectangles) 
			{
				rect = rectKey;
				rect.width = rect.width;
				rect.height = rect.height;
				var bitmapData  : BitmapData = m_sourceTexturesDict[rect].bitmapData;
				
				atlasBitmapData.copyPixels(bitmapData, new Rectangle(0, 0, bitmapData.width, bitmapData.height), new Point(rect.x, rect.y));
				
				// we've copied the captured image to the atlast, no need for it anymore. dispose!
				bitmapData.dispose();
				
				resultAtlas.addRegion(m_sourceTexturesDict[rect].id, rect);
				m_processedRectangles++;
			}
			
			m_generatedResult.push(resultAtlas);
			
			m_processedPercent = m_processedRectangles/m_rectanglesToProcess;
		}
		
		public function process():void
		{
			// the first step is to extract the rectangles, and only then copy the bitmaps
			if (m_extractedRectangles==null)
				extractRectangles();
			else
				copyBitmaps();
		}
		
		public function get isComplete():Boolean
		{
			return total==progress;
		}
		
		public function get total():int
		{
			return m_itemsToProcess;
		}
		
		public function get progress():int
		{
			return m_itemsToProcess*m_processedPercent;
		}
		
	}
}