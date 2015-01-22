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
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class DisplayObjectUtils
	{
		/**
		 * Calculates the given dispObj bounds rect. with all its children (Including effects)
		 * The result rect will reflect how this display object looks like to its parent.
		 * Meaning that it's also taking the object's location, rotation, and scale
		 *  
		 * @param dispObj
		 * @return 
		 * 
		 */
		public static function getBoundsRect(dispObj:DisplayObject, targetCoordinateSpace:DisplayObject = null):Rectangle
		{
			var bounds 			: Rectangle;
			
			if (targetCoordinateSpace==null)
			{
				if (dispObj.parent!=null)
				{
					bounds = doGetBoundsRectWithChildren(dispObj, dispObj.parent);
				}
				else
				{
					var fakeParent : Sprite = new Sprite();
					fakeParent.addChild(dispObj);
					bounds = doGetBoundsRectWithChildren(dispObj, fakeParent);
					fakeParent.removeChild(dispObj);
				}
			}
			else
			{
				bounds = doGetBoundsRectWithChildren(dispObj, targetCoordinateSpace);
			}
			
			return bounds;
		}
		
		private static function doGetBoundsRectWithChildren(dispObj:DisplayObject, targetCoordinateSpace:DisplayObject):Rectangle
		{
			var children			: Array = [];
			var child				: DisplayObject;
			var dispObjCont 		: DisplayObjectContainer = dispObj as DisplayObjectContainer;
			var childrensRect		: Rectangle = new Rectangle();
			var i					: int;
			var asMovieClip 		: MovieClip = dispObj as MovieClip;
			var dontRemoveChildren	: Boolean = (asMovieClip && asMovieClip.totalFrames>=1);
				
			// remove and draw rect for all children
			if (dispObjCont && dispObjCont.filters.length==0)
			{
				if (dontRemoveChildren)
				{
					for (i=0; i<dispObjCont.numChildren; i++)
					{
						child = dispObjCont.getChildAt(i);
						childrensRect = childrensRect.union(doGetBoundsRectWithChildren(child, targetCoordinateSpace));
						childrensRect = childrensRect.union(getBoundsWithEffects(child, targetCoordinateSpace));
					}
				}
				else
				{
					while (dispObjCont.numChildren>0)
					{
						child = dispObjCont.getChildAt(0);
						childrensRect = childrensRect.union(doGetBoundsRectWithChildren(child, targetCoordinateSpace));
						childrensRect = childrensRect.union(getBoundsWithEffects(child, targetCoordinateSpace));

						dispObjCont.removeChildAt(0);
						children.push(child);
					}
				}
			}
			
			// get my bounds
			var bounds : Rectangle = getBoundsWithEffects(dispObj, targetCoordinateSpace);
			
			// return all the children
			if (dispObjCont)
			{
				while (children.length>0)
				{
					child = children.shift() as DisplayObject;
					dispObjCont.addChild(child);
				}
			}
			
			return bounds.union(childrensRect);
		}
		
		
		public static function getBoundsWithEffects(dispObj:DisplayObject, targetCoordinateSpace:DisplayObject):Rectangle 
		{
			var boundsRect	: Rectangle;
			
			// Get bounds of the dispObj
			boundsRect = dispObj.getBounds(targetCoordinateSpace);
			
			// do we have anything to check for filters?
			if (boundsRect.width==0 || boundsRect.height==0)
				return boundsRect;
			
			// Include all filters if requested and they exist
			var filtersLength	: int = dispObj.filters.length;
			if (filtersLength>0) 
			{
				var rectToFilter	: Rectangle = new Rectangle(0, 0, boundsRect.width, boundsRect.height);
				var bmd				: BitmapData = new BitmapData(boundsRect.width, boundsRect.height, false);
				
				for (var filtersIndex:int = 0; filtersIndex<filtersLength; filtersIndex++) 
				{                                          
					var filter		: BitmapFilter;
					var filterRect	: Rectangle;
					
					filter = dispObj.filters[filtersIndex];
					filterRect = bmd.generateFilterRect(rectToFilter, filter);
					
					rectToFilter = rectToFilter.union(filterRect);
				}
				bmd.dispose();
				
				rectToFilter.offset(boundsRect.x, boundsRect.y);
				boundsRect = rectToFilter.clone();
			}                               
			
			return boundsRect;
		}	
		
		public static function transformUpToParent(dispObj:DisplayObject, targetCoordinateSpace:DisplayObject):Matrix
		{
			var matrix : Matrix = new Matrix();
			
			// find out what all the parents did to us.
			var currentObj : DisplayObject = dispObj;
			while (targetCoordinateSpace!=null && currentObj!=targetCoordinateSpace)
			{
				matrix.concat(currentObj.transform.matrix);
				currentObj = currentObj.parent;
			} 
			
			return matrix;
		}
		
		public static function transformToParent(dispObj:DisplayObject, targetCoordinateSpace:DisplayObject):Matrix
		{
			var matrix : Matrix = new Matrix();
			
			// find out what all the parents did to us.
			var currentObj : DisplayObject = dispObj;
			matrix.concat(currentObj.transform.matrix);
			while (targetCoordinateSpace!=null && currentObj!=targetCoordinateSpace)
			{
				currentObj = currentObj.parent;
				matrix.concat(currentObj.transform.matrix);
			} 
			
			return matrix;
		}
		
		public static function isIdentMatrix(mat:Matrix):Boolean
		{
			return (mat.a==1) &&
				   (mat.b==0) &&
				   (mat.c==0) &&
				   (mat.d==1) &&
				   (mat.tx==0) &&
				   (mat.tx==0);
		}
		
		public static function scaleEffects(dispObj:DisplayObject, scaleX:Number=1.0, scaleY:Number=1.0):void
		{
			var dispObjContainer : DisplayObjectContainer;
			dispObjContainer = dispObj as DisplayObjectContainer;

			if  (dispObjContainer!=null)
			{
				var movieClip : MovieClip = dispObj as MovieClip;
				if (movieClip)
					movieClip.gotoAndStop(1);
				
				for (var i:int=0; i<dispObjContainer.numChildren; i++)
				{
					scaleEffects(dispObjContainer.getChildAt(i), scaleX*dispObjContainer.scaleX, scaleY*dispObjContainer.scaleY);
				}
			}
			
			var effects : Array = dispObj.filters;
			if (effects!=null && effects.length>0) 
			{
				var newEffects : Array = [];
				for (var j:int=0; j<effects.length; j++)
				{
					var effect 		: BitmapFilter = effects[j];
					var asShadow	: DropShadowFilter = effect as DropShadowFilter;
					var asGlow		: GlowFilter = effect as GlowFilter;
					
					if (asShadow!=null)
					{
						asShadow.blurX = asShadow.blurX * scaleX;
						asShadow.blurY = asShadow.blurY * scaleY;
						asShadow.distance = asShadow.distance * ((scaleX+scaleY)/2);
					}
					
					if (asGlow!=null)
					{
						asGlow.blurX = asGlow.blurX * scaleX;
						asGlow.blurY = asGlow.blurY * scaleY;
					}
					
					newEffects.push(effect);
				}
				
				dispObj.filters = newEffects;
			}
		}
		
		private static function resizeToRatio(dispObj:DisplayObject, rect:Rectangle):void
		{
			var imageRatio 		: Number = dispObj.width/dispObj.height;
			var containerRatio	: Number = rect.width/rect.height;
			
			if (containerRatio>imageRatio)
			{
				dispObj.height = rect.height;
				dispObj.width = imageRatio*dispObj.height;
			}
			else
			{
				dispObj.width = rect.width;
				dispObj.height = dispObj.width/imageRatio;
			}
		}
		
		public static function fitToRect( dispObj:DisplayObject, 
										  rect:Rectangle, 
										  leftMargins:Number = 0.0, 
										  rightMargins:Number = 0.0, 
										  topMargins:Number = 0.0, 
										  bottomMargins:Number = 0.0):void
		{
			// add the margins
			rect.x = rect.x + rect.width*leftMargins;
			rect.y = rect.y + rect.height*topMargins;
			rect.width = rect.width - (rect.width*rightMargins) - (rect.width*leftMargins);
			rect.height = rect.height - (rect.height*topMargins) - (rect.height*bottomMargins);
			
			// fit to the rect
			resizeToRatio(dispObj, rect);
		}
		
	}
}