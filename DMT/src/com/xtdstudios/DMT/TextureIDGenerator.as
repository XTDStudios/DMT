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
	import com.xtdstudios.DMT.raster.RasterizationResultTree;
	import com.xtdstudios.DMT.raster.RasterizedAssetData;
	
	import flash.display.BitmapData;
	import flash.errors.IllegalOperationError;
	import flash.geom.Matrix;

	public class TextureIDGenerator
	{
		private static const MATRIX_DIGITS_AFTER_DOT	: int = 3;
		private var m_matrixAccuracyPercent				: Number;
		
		public function TextureIDGenerator(matrixAccuracyPercent:Number=1.0)
		{
			m_matrixAccuracyPercent = matrixAccuracyPercent;
		}
		
		private function calculateMatrixField(n: Number):String
		{
			// use the m_matrixAccuracyPercent to round up the n number
			return n.toFixed(MATRIX_DIGITS_AFTER_DOT);
		}
		
		public function generateTextureID(rasterizationResultTree:RasterizationResultTree):String
		{
			// some items in the tree are just DisplayObjectcontainers without graphics
			// no need for a texture, return null
			if (rasterizationResultTree.graphicsBitmapData==null)
				return null;
			
			var rasterizedAssetData : RasterizedAssetData;
			var bitmapData			: BitmapData;
			var name				: String;
			var bitmapSize			: String;
			
			rasterizedAssetData = rasterizationResultTree.rasterizedAssetData;
			
			// we look at the class name of the captued object, 
			// if it's just a MovieClip or Shape, we can't tell if it's uniqe
			// so we generate a unique ID
			if (rasterizedAssetData.isCustomClass==true)
			{
				name = "c_" + rasterizedAssetData.originalClassName;
				if (rasterizationResultTree.parent && rasterizationResultTree.parent.isMovieClip)
					name = name + "_fr" + rasterizationResultTree.parent.getChildIndex(rasterizationResultTree);
			}
			else
			{
				name = "";
				var tmpItem : RasterizationResultTree = rasterizationResultTree;
				
				while (tmpItem.parent && tmpItem.rasterizedAssetData.isCustomClass==false)
				{
					name = name + "ch" + tmpItem.parent.getChildIndex(tmpItem);
					tmpItem = tmpItem.parent;
				}
				name = "c_" + tmpItem.rasterizedAssetData.originalClassName + "_" + name;
			}
			
			// taking all the parts that makes this asset a unique texture
			bitmapData = rasterizationResultTree.graphicsBitmapData;
			
			var textureID 			: String;
			var aggregatedMatrix 	: Matrix = rasterizedAssetData.aggregatedMatrix;
			textureID = name + "_" + 
						calculateMatrixField(aggregatedMatrix.a) +	"_" + 
						calculateMatrixField(aggregatedMatrix.b) + "_" + 
						calculateMatrixField(aggregatedMatrix.c) + "_" + 
						calculateMatrixField(aggregatedMatrix.d);

			return textureID;
		}
	}
}