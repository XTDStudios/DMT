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
	import com.xtdstudios.DMT.atlas.Atlas;
	import com.xtdstudios.DMT.atlas.AtlasGenerator;
	import com.xtdstudios.DMT.persistency.PersistencyManager;
	import com.xtdstudios.DMT.raster.RasterizationResultTree;
	import com.xtdstudios.DMT.raster.Rasterizer;
	import com.xtdstudios.common.FileUtils;
	
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class AssetsGroupBuilderImpl extends EventDispatcher implements AssetsGroupBuilder
	{
		private var m_assetsGroup 					: AssetsGroup;
		private var m_isFinishedRasterizing			: Boolean;
		private var m_rasterizer					: Rasterizer;
		private var m_textureIDGenerator			: TextureIDGenerator;
		private var m_capturedAssetsDictionary		: CapturedAssetsDictionary;
		private var m_atlasGenerator 				: AtlasGenerator;
		
		public function AssetsGroupBuilderImpl(assetsGroup:AssetsGroup, isTransparent:Boolean=true, matrixAccuracyPercent:Number=1.0)
		{
			super();
			m_assetsGroup = assetsGroup;
			
			// make sure we have a rasterizer
			m_rasterizer = new Rasterizer();
			var stopNames : Dictionary = new Dictionary();
			stopNames['stop_raster'] = true;
			m_rasterizer.stopRasterNames = stopNames;
			m_rasterizer.transparentBitmaps = isTransparent;
			
			m_textureIDGenerator = new TextureIDGenerator(matrixAccuracyPercent);
			m_capturedAssetsDictionary = new CapturedAssetsDictionary();
			
			m_isFinishedRasterizing = false;
			
		}
		
		public function get scaleEffects():Boolean
		{
			return m_rasterizer.scaleEffects;
		}

		public function set scaleEffects(value:Boolean):void
		{
			m_rasterizer.scaleEffects = value;
		}

		private function extractTexturesAndBuildAssetDef(rasterizationResultTree : RasterizationResultTree):AssetDef
		{
			var resultAssetDef : AssetDef;
			resultAssetDef = AssetDef.createAssetDef(rasterizationResultTree.isMovieClip, rasterizationResultTree.rasterizedAssetData);
			
			// convert it to Captured Asset 
			var textureID : String = m_textureIDGenerator.generateTextureID(rasterizationResultTree);
			if (textureID!=null)
			{
				// the texture will be registered ONLY if it's not in the dictionary
				m_capturedAssetsDictionary.registerCapturedAsset(textureID, rasterizationResultTree.graphicsBitmapData); 
			}
			
			// put this texture ID into the assetDef (It's ok to put null, this way we know there's no texture for this asset)
			resultAssetDef.textureID = textureID;
			
			// extracting all the children's textures too
			for (var i:int=0; i<rasterizationResultTree.numChildren; i++)
			{
				resultAssetDef.children.push(extractTexturesAndBuildAssetDef(rasterizationResultTree.getChildAt(i)));
			}
			
			return resultAssetDef;
		}
		
		public function rasterizeVector(displayObjects:Vector.<DisplayObject>, maxDepth:int=-1, fitToRect:Rectangle=null, bestFitWithoutStretching:Boolean=true):void
		{
			for each(var displayObject:DisplayObject in displayObjects)
			{
				rasterize(displayObject, displayObject.name, maxDepth, fitToRect, bestFitWithoutStretching); 
			}
		}
		
		public function rasterize(displayObject:DisplayObject, uniqueAlias:String=null, maxDepth:int=-1, fitToRect:Rectangle=null, bestFitWithoutStretching:Boolean=true):void
		{ 
			// can't rasterize if we're done.
			if (m_isFinishedRasterizing==true)
			{
				throw new IllegalOperationError("It is impossible to rasterized into a closed AssetsGroup");
			}
			
			// RASTERIZE!
			var rasterizationResultTree : RasterizationResultTree = m_rasterizer.rasterize(displayObject, maxDepth);
			
			// take out the unique textures, and Build assetDef from it
			var assetDef : AssetDef = extractTexturesAndBuildAssetDef(rasterizationResultTree);
			if (assetDef)
			{
				if (uniqueAlias)
					assetDef.uniqueAlias = uniqueAlias;
				else
					assetDef.uniqueAlias = displayObject.name;
			}

			// put the extracted assetDef into the assetGroup
			m_assetsGroup.addAssetDef(assetDef);
		}
		
		public function generate(): AssetsGroup
		{
			// add the new atlas to the group
			for each(var atlas:Atlas in m_atlasGenerator.generatedResult)
			{
				m_assetsGroup.addAtlas(atlas);
			}
				
			
			// we're done, free it all
			m_rasterizer = null;
			m_capturedAssetsDictionary = null;
			m_textureIDGenerator = null;
			m_atlasGenerator = null;
			
			m_isFinishedRasterizing = true;
			m_assetsGroup.markReady();
			
			return m_assetsGroup;
		}
		
		public function get assetsGroup():AssetsGroup
		{
			if (m_assetsGroup.ready)
				return m_assetsGroup
			else
				return null;
		}
		
		public function dispose():void
		{
			m_assetsGroup 				= null;
			m_rasterizer				= null;
			m_textureIDGenerator		= null;
			m_capturedAssetsDictionary	= null;
			m_atlasGenerator 			= null;
		}
	}
}