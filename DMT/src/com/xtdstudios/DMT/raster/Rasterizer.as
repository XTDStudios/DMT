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
package com.xtdstudios.DMT.raster
{
	import com.xtdstudios.common.DisplayObjectUtils;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	public class Rasterizer
	{
		private static const DEFUALT_BITMAP_BG_COLOR	: int = 0x333333;
		
		private var m_bitmapBgColor				: int = DEFUALT_BITMAP_BG_COLOR;
		private var m_transparentBitmaps		: Boolean;
		private var m_scaleEffects				: Boolean;
		private var m_stopRasterNames			: Dictionary;
		private var m_emptyLastFrameWorkaround	: Boolean;
		
		public function Rasterizer()
		{
			m_emptyLastFrameWorkaround = true;
			m_transparentBitmaps = true;
			m_scaleEffects = true;
			m_stopRasterNames = new Dictionary();
		}
		
		public function set emptyLastFrameWorkaround(value:Boolean):void
		{
			m_emptyLastFrameWorkaround = value;
		}

		public function get scaleEffects():Boolean
		{
			return m_scaleEffects;
		}

		public function set scaleEffects(value:Boolean):void
		{
			m_scaleEffects = value;
		}

		public function set stopRasterNames(value:Dictionary):void
		{
			m_stopRasterNames = value;
		}

		public function get bitmapBgColor():int
		{
			return m_bitmapBgColor;
		}

		public function set bitmapBgColor(value:int):void
		{
			m_bitmapBgColor = value;
		}

		public function get transparentBitmaps():Boolean
		{
			return m_transparentBitmaps;
		}

		public function set transparentBitmaps(value:Boolean):void
		{
			m_transparentBitmaps = value;
		}
		
		private function checkIfShouldStop(instanceName:String):Boolean
		{
			return m_stopRasterNames[instanceName]!=null;
		}

		public function rasterize(dispObj:DisplayObject, maxDepth:int=-1):RasterizationResultTree
		{
			var result : RasterizationResultTree;

			// scaling the effects according to the dispObj's scaling
			if (m_scaleEffects)
				DisplayObjectUtils.scaleEffects(dispObj);
			
			if (dispObj.parent!=null)
			{
				result = rasterizeWithChildren(dispObj, dispObj.parent, maxDepth);
			}
			else
			{
				var fakeParent : Sprite = new Sprite();
				fakeParent.addChild(dispObj);
				result = rasterizeWithChildren(dispObj, fakeParent, maxDepth);
				fakeParent.removeChild(dispObj);
			}

			// scaling BACK the effects according to the dispObj's scaling
			if (m_scaleEffects)
				DisplayObjectUtils.scaleEffects(dispObj, 1/dispObj.scaleX, 1/dispObj.scaleY);
			
			return result;
		}
		
		private function rasterizeWithChildren( currentDispObj:DisplayObject, 
												topDispObj:DisplayObject, 
												maxDepth:int=-1, 
												currentDepth:int=-1, 
												currentMatrix:Matrix = null, 
												currentScaleX:Number=1.0, 
												currentScaleY:Number=1.0,
												isFramesMode:Boolean=false):RasterizationResultTree
		{
			var result			: RasterizationResultTree;
			var resultData		: RasterizedAssetData;
			
			result = new RasterizationResultTree();
			resultData = result.rasterizedAssetData;
			
			currentDepth++;
			
			if (currentMatrix==null)
				currentMatrix = new Matrix();

			if (isFramesMode==false)
			{
				currentScaleX = currentScaleX * currentDispObj.scaleX;
				currentScaleY = currentScaleY * currentDispObj.scaleY;
				
				var tmpMat : Matrix = currentDispObj.transform.matrix.clone();
				tmpMat.concat(currentMatrix);
				currentMatrix = tmpMat;
			}

			resultData.x = currentMatrix.tx;
			resultData.y = currentMatrix.ty;

			// subtract the x and y (they will be calculated using the result's x and y)
			currentMatrix.tx = 0;
			currentMatrix.ty = 0;
			
			// coping some data
			resultData.alpha = currentDispObj.alpha;
			resultData.originalInstanceName = currentDispObj.name;
			resultData.aggregatedMatrix = currentMatrix.clone();
			resultData.originalClassName = getQualifiedClassName(currentDispObj);
			
			// rasterizing all the children first
			var children		: Array = []; 
			var child			: DisplayObject;
			var dispObjCont 	: DisplayObjectContainer = currentDispObj as DisplayObjectContainer;
			var hasFilters		: Boolean = currentDispObj.filters.length>0;
			var inDepthRange	: Boolean = (maxDepth==-1 || currentDepth<maxDepth);
			var asMovieClip		: MovieClip = currentDispObj as MovieClip;
			var totalFrames		: int = asMovieClip ? asMovieClip.totalFrames : 1;
			
			if (isFramesMode==false && totalFrames==1 && dispObjCont!=null && inDepthRange && hasFilters==false && (checkIfShouldStop(dispObjCont.name)==false))
			{
				var numChildren : int = dispObjCont.numChildren;
				if (numChildren>0)
				{
					child = dispObjCont.getChildAt(0);
					
					// if we have only ONE child and it's a shape that was not trasformed
					// we can capture its parent
					if (numChildren!=1 || (child is Shape)==false || (DisplayObjectUtils.isIdentmatrix(child.transform.matrix)==false))
					{
						while (dispObjCont.numChildren>0) 
						{
							child = dispObjCont.getChildAt(0);
							result.addChild(rasterizeWithChildren(child, topDispObj, maxDepth, currentDepth, currentMatrix, currentScaleX, currentScaleY, isFramesMode));
							dispObjCont.removeChildAt(0);
							children.push(child);
						}
					}
				}
			} 
			
			// ********** DRAW ***********
			if (totalFrames>1 && isFramesMode==false)
			{
				result.isMovieClip = true;
				// first part of the AIR bug fix, We must go to the empty frame 
				// at the end to prevent miss drawing the frames
				if (m_emptyLastFrameWorkaround)
					asMovieClip.gotoAndStop(totalFrames);
				
				for (var i:uint=1; i<=totalFrames; i++)
				{
					asMovieClip.gotoAndStop(i);
					// we don't rasterize the last frame (We just gotoAndStop)
					// This is a workaround for AIR bug
					if (m_emptyLastFrameWorkaround==false || i<totalFrames)
						result.addChild(rasterizeWithChildren(asMovieClip, topDispObj, maxDepth, currentDepth, currentMatrix, currentScaleX, currentScaleY, true));
				}
			}
			else
			{
				result.isMovieClip = false;
				result.graphicsBitmapData = draw(currentDispObj, topDispObj, resultData, currentMatrix);
			}
			
			
			// return all the children
			if (dispObjCont)
			{
				while (children.length>0)
				{
					child = children.shift() as DisplayObject;
					dispObjCont.addChild(child);
				}
			}
			
			resultData.originalPosRectangle = currentDispObj.getBounds(topDispObj);
			
			return result;
		}
		
		private function draw(currentDispObj:DisplayObject, topDispObj:DisplayObject, assetData:RasterizedAssetData, matrix:Matrix):BitmapData
		{
			var bounds			: Rectangle; 
			var bitmapData	 	: BitmapData; 

			// get bouds
			bounds = DisplayObjectUtils.getBoundsRect(currentDispObj, topDispObj);
			if (bounds.width>=1 && bounds.height>=1)
			{ 
				var zeroInParentSpace		: Point;
				var posInParentSpace		: Point;
				var parentSpaceMatrix		: Matrix;
				
				bounds.width = bounds.width>=0 ? Math.ceil(bounds.width) : Math.floor(bounds.width);
				bounds.height = bounds.height>=0 ? Math.ceil(bounds.height) : Math.floor(bounds.height);
				
				parentSpaceMatrix = DisplayObjectUtils.transformUpToParent(currentDispObj.parent, topDispObj);
				zeroInParentSpace = parentSpaceMatrix.transformPoint(new Point(0, 0)); 
				posInParentSpace = parentSpaceMatrix.transformPoint(new Point(currentDispObj.x, currentDispObj.y));
				
				// moving the result to how it's visible with the current matrix
				assetData.x = posInParentSpace.x-zeroInParentSpace.x;
				assetData.y = posInParentSpace.y-zeroInParentSpace.y;
				assetData.pivotX = posInParentSpace.x-bounds.x;
				assetData.pivotY = posInParentSpace.y-bounds.y;
				
				// moving the result rectangle of the displayObject to 0,0 (So the capture will capture the rect)
				matrix.translate(posInParentSpace.x-bounds.x, posInParentSpace.y-bounds.y);
				
				// save the alpha
				var savedAlpha : Number = currentDispObj.alpha;
				currentDispObj.alpha = 1.0;
				
				// we know the bitmap size, get some memory for that
				bitmapData = new BitmapData(bounds.width, bounds.height, m_transparentBitmaps, bitmapBgColor);
				
				// in case we have a 9-scale, we MUST use a container to draw the 9-scaled object
				// and draw the container, and not the 9-scaled.
				// Note: This will NOT work is the object has rotation, rotation MUST be 0, to make it work (Adobe BUG)
				if (currentDispObj.scale9Grid!=null)
				{
					var saveParent 		: DisplayObjectContainer = currentDispObj.parent;
					var saveMatrix		: Matrix = currentDispObj.transform.matrix;
					var tmpContainer 	: Sprite = new Sprite();
					
					// making sure that our object is on 0,0
					currentDispObj.transform.matrix = matrix;
					
					// add it to the temp container
					tmpContainer.addChild(currentDispObj);
					
					// and draw the CONTAINER and not the currentDispObj (To see the 9-scale)
					bitmapData.draw(tmpContainer);
					
					// get it back ot its original parent
					if (saveParent!=null)
						saveParent.addChild(currentDispObj);
					else
						tmpContainer.removeChild(currentDispObj);
					
					// get it back to its original matrix
					currentDispObj.transform.matrix = saveMatrix;
				}
				else
				{
					bitmapData.draw(currentDispObj, matrix);
				}
				
				// return the alpha to what it was
				currentDispObj.alpha = savedAlpha; 
				
				//bitmapData.drawWithQuality(currentDispObj, currentMatrix, null, null, null, false, StageQuality.HIGH_16X16);
			}
			else
			{
				assetData.pivotX = 0;
				assetData.pivotY = 0;
			}
			
			return bitmapData;
		}
	}
}