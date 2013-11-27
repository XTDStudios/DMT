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
	import starling.textures.Texture;

	public class DMTBasic extends DMTAbsAPI
	{
		protected var m_displayObjects	: Vector.<flash.display.DisplayObject>;
		protected var m_converter 		: AssetGroupConverter;
		protected var m_dataName		: String;
		
		
		public function DMTBasic(dataName:String, useCache:Boolean=true, cacheVersion:String="1")
		{
			m_displayObjects = new Vector.<flash.display.DisplayObject>;
			m_dataName = dataName;
			super(useCache, cacheVersion);
		}
		
		public function process(isTransparent:Boolean=true, maxDepth:int=-1, matrixAccuracyPercent:Number=1.0):Boolean {
			return _process(m_dataName, isTransparent, maxDepth, matrixAccuracyPercent);
		}
		
		public function addItemToRaster(displayObject:flash.display.DisplayObject):void
		{
			m_displayObjects.push(displayObject);
		}
		
		public function addItemsToRaster(displayObjects:Vector.<flash.display.DisplayObject>):void
		{
			for (var i:int=0; i<displayObjects.length; i++)
				m_displayObjects.push(displayObjects[i]);
		}
		
		public function removeItemToRaster(displayObject:flash.display.DisplayObject):void
		{
			var idx : int = m_displayObjects.indexOf(displayObject);
			if (idx>-1)
				m_displayObjects.splice(idx, 1);
		}
		
		public function clearItemsToRaster():void
		{
			m_displayObjects = new Vector.<flash.display.DisplayObject>;
		}
		
		public function get textureIDs():Vector.<String>
		{
			if (m_converter)
				return m_converter.textureIDs;
			else
				return null;
		}

		public function getTextureByID(textureID:String):Texture
		{
			if (m_converter)
				return m_converter.getTextureByID(textureID) as Texture;
			else
				return null;
		}

		public function getTexturesByUniqueAlias(uniqueAlias:String):Array
		{
			if (m_converter)
				return m_converter.getTexturesByUniqueAlias(uniqueAlias);
			else
				return null;
		}

		override protected function getItemsToRaster(dn: String):Vector.<ItemToRaster>
		{
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
		
		public function get atlasesList():Array
		{
			return getAssetsGroup(m_dataName).atlasesList;
		}
		
		public function cacheExist():Boolean
		{
			return m_useCache && m_assetsGroupsManager.isCacheExist(m_dataName); 
		}
		
		public function getAssetByUniqueAlias(uniqueAlias:String):starling.display.DisplayObject
		{
			if (m_converter)
				return m_converter.convert(uniqueAlias) as starling.display.DisplayObject;
			else
				return null;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			m_displayObjects = null;
			
			if (m_converter)
			{
				m_converter.dispose();
				m_converter = null;
			}
		}
	}
}