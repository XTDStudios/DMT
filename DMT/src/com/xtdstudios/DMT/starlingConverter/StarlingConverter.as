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
package com.xtdstudios.DMT.starlingConverter
{
	import com.xtdstudios.DMT.AssetDef;
	import com.xtdstudios.DMT.AssetGroupConverter;
	import com.xtdstudios.DMT.AssetsGroup;
	import com.xtdstudios.DMT.atlas.Atlas;
	import com.xtdstudios.DMT.raster.RasterizedAssetData;
	
	import flash.errors.IllegalOperationError;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class StarlingConverter implements AssetGroupConverter
	{
		private var m_assetGroup 				: AssetsGroup;
		private var m_starlingTextureAtlases 	: Vector.<TextureAtlas>;
		private var m_textureIDs				: Vector.<String>;
		
		public function StarlingConverter(assetGroup:AssetsGroup)
		{
			m_assetGroup = assetGroup;
			prepare();
		}
		
		private function prepare(): void
		{
			try
			{
				m_textureIDs = new Vector.<String>;
	
				m_starlingTextureAtlases = new Vector.<TextureAtlas>;
				var atlases : Array = m_assetGroup.atlasesList;
				var atlasMem	: Number = 0;
				for (var i:int=0; i<atlases.length; i++)
				{
					var texture 				: Texture;
					var atlas 					: Atlas;
					
					atlas = atlases[i];
					atlasMem = atlasMem + atlas.bitmapData.width*atlas.bitmapData.height*4;
					
					texture = Texture.fromBitmapData(atlas.bitmapData, false, false); 
					atlas.disposeBitmapData();
					
					// now that the atlas bitmap is on the GPU/Starling we can dispose it from 
					// the asset group atlas.
					
					var regions:Dictionary = atlas.regions;
					var textureAtlas:TextureAtlas = new TextureAtlas(texture);
					for (var textureID:String in regions)
					{
						m_textureIDs.push(textureID);
						var region : Rectangle = regions[textureID];
						textureAtlas.addRegion(textureID,region);
					}
					m_starlingTextureAtlases.push(textureAtlas);
				}
//				trace("'" + m_assetGroup.name + "' Atlases memory (" + atlases.length.toString() + " bitmaps):", Memory.toString(atlasMem), "and", Memory.toString(atlasMem*1.333), "on the GPU");
//				trace("Overall memory usage: " + Memory.getUsedMemeoryStr());
				
			}
			catch (e:Error)
			{
				// we will ignore any error in case the context was diposed when creating the textures
				// the context should be re-created anyways.
				if (Starling.context && Starling.context.driverInfo != "Disposed")
					throw e; 
			}
		}
		
		public function get textureIDs():Vector.<String>
		{
			return m_textureIDs;
		}

		public function getTextureByID(textureID:String):Object
		{
			for each(var atlas:TextureAtlas in m_starlingTextureAtlases)
			{
				var texture : Texture = atlas.getTexture(textureID);
				if (texture)
					return texture;
			}
			
			return null;
		}
		
		private function convertWithChildren(assetDef:AssetDef):DisplayObject
		{
			var result 	: DisplayObject;
			var i		: int;
			if (assetDef.children.length>0) 
			{
				if (assetDef.isMovieclip)
				{
					var textures : Vector.<Texture> = new Vector.<Texture>;
					for (i=0; i<assetDef.children.length; i++)
					{
						textures.push(getTextureByID(assetDef.children[i].textureID));
					}
					result = new StarlingMovieClipProxy(textures);
				}
				else
				{
					result = new StarlingSpriteProxy();
					for (i=0; i<assetDef.children.length; i++)
					{
						(result as Sprite).addChild(convertWithChildren(assetDef.children[i]));
					}
				}
				
			} 
			else  
			{
				if (assetDef.textureID!=null && assetDef.textureID!="")
					result = new StarlingImageProxy(getTextureByID(assetDef.textureID) as Texture);
				else
					result = new StarlingSpriteProxy();
			}
			
			if (result)
			{ 
				var rasterizedAssetData : RasterizedAssetData = assetDef.rasterizedAssetData;
				result.x = Math.round(rasterizedAssetData.x);
				result.y = Math.round(rasterizedAssetData.y);
				result.alpha = rasterizedAssetData.alpha;
				result.pivotX = Math.round(rasterizedAssetData.pivotX);
				result.pivotY = Math.round(rasterizedAssetData.pivotY);
				result["originalPosRectangle"] = rasterizedAssetData.originalPosRectangle;
				
				// is the user didn't name it we'll use the class name
				if (rasterizedAssetData.originalInstanceName.indexOf("instance")==0)
					result.name = rasterizedAssetData.originalClassName;
				else
					result.name = rasterizedAssetData.originalInstanceName;
			}
			
			return result;
		}
		
		public function convert(uniqueAlias:String):Object
		{
			if (! uniqueAlias)
				throw new IllegalOperationError("unable to convert, invalid uniqueAlias");
			
			var assetDef 	: AssetDef;
			assetDef = m_assetGroup.getAssetDef(uniqueAlias);
				
			if (assetDef)
				return convertWithChildren(assetDef);
			else
				throw new IllegalOperationError("assetDef was not found, " + uniqueAlias);
		}
		
		public function dispose():void
		{
			if (m_starlingTextureAtlases)
			{
				while (m_starlingTextureAtlases.length>0)
				{
					m_starlingTextureAtlases.pop().dispose();
				}
				m_starlingTextureAtlases = null;
			}

			m_textureIDs = null;
			m_assetGroup = null;
		}
	}
}