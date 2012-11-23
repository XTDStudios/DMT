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
	import com.xtdstudios.DMT.starlingConverter.StarlingConverter;
	
	import flash.display.DisplayObject;
	
	import starling.display.DisplayObject;

	public class DMTBasic extends DMTAbsAPI
	{
		private var m_displayObjects	: Vector.<flash.display.DisplayObject>;
		private var m_converter 		: AssetGroupConverter;
		private var m_dataName			: String;
		
		
		public function DMTBasic(dataName:String, useCache:Boolean=true, cacheVersion:String="1")
		{
			m_displayObjects = null;
			m_dataName = dataName;
			super(useCache, cacheVersion);
		}
		
		public function process(isTransparent:Boolean=true, maxDepth:int=-1, matrixAccuracyPercent:Number=1.0):Boolean {
			return _process(m_dataName, isTransparent, maxDepth, matrixAccuracyPercent);
		}
		
		public function set itemsToRaster(displayObjects:Vector.<flash.display.DisplayObject>):void
		{
			m_displayObjects = displayObjects;
		}
		
		public function get itemsToRaster():Vector.<flash.display.DisplayObject>
		{
			return m_displayObjects;
		}
		
		public function get textureIDs():Vector.<String>
		{
			if (m_converter)
				return m_converter.textureIDs;
			else
				return null;
		}

		override protected function getItemsToRaster(dn: String):Vector.<ItemToRaster>
		{
			if (m_displayObjects==null)
				return null;
			
			var result : Vector.<ItemToRaster> = new Vector.<ItemToRaster>;
			for each(var itemToRaster:flash.display.DisplayObject in m_displayObjects)
			{
				result.push(new ItemToRaster(itemToRaster, itemToRaster.name));
			}
			return result;
		}
		
		override protected function processTextures(assetsGroup:AssetsGroup):void
		{
			m_converter = new StarlingConverter(assetsGroup);
		}		
		
		public function getAssetByUniqueAlias(uniqueAlias:String):starling.display.DisplayObject
		{
			if (m_converter)
				return m_converter.convert(uniqueAlias) as starling.display.DisplayObject;
			else
				return null;
		}
	}
}