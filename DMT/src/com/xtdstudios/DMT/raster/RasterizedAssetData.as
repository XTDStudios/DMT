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
	import com.xtdstudios.DMT.serialization.ISerializable;
	import com.xtdstudios.DMT.utils.MatrixUtils;
	import com.xtdstudios.DMT.utils.RectangleUtils;

	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class RasterizedAssetData implements ISerializable
	{
		public var originalInstanceName:String="";
		public var x:Number=0;
		public var y:Number=0;
		public var alpha:Number=1;
		public var pivotX:Number=0;
		public var pivotY:Number=0;
		public var textureScaleX:Number=1;
		public var textureScaleY:Number=1;
		public var isCustomClass:Boolean=false;
		public var originalPosRectangle:Rectangle;
		public var frame:Rectangle;
		public var aggregatedMatrix:Matrix=new Matrix();

		private var m_originalClassName:String;

		public function RasterizedAssetData()
		{
		}

		public function get originalClassName():String
		{
			return m_originalClassName;
		}

		public function set originalClassName(value:String):void
		{
			m_originalClassName=value;
			isCustomClass=m_originalClassName.indexOf("flash.") != 0;
		}

		public function toJson():Object
		{
			var result:Object={
				name: originalInstanceName,
				x: Math.round(x * 1000) / 1000,
				y: Math.round(y * 1000) / 1000,
				alpha: Math.round(alpha * 1000) / 1000,
				pivotX: Math.round(pivotX * 1000) / 1000,
				pivotY: Math.round(pivotY * 1000) / 1000,
				isCustomClass: isCustomClass
			}

			if (originalPosRectangle)
				result.originalPos=RectangleUtils.rectAsObj(originalPosRectangle);

			if (frame)
				result.frame=RectangleUtils.rectAsObj(frame);

			if (aggregatedMatrix)
				result.aggregatedMatrix=MatrixUtils.matrixAsObj(aggregatedMatrix);

			return result;
		}

		public function fromJson(jsonData:Object):void
		{
			originalInstanceName=jsonData.name;
			x=jsonData.x;
			y=jsonData.y;
			alpha=jsonData.alpha;
			pivotX=jsonData.pivotX;
			pivotY=jsonData.pivotY;
			isCustomClass=jsonData.isCustomClass;

			if (jsonData.hasOwnProperty('originalPos'))
				originalPosRectangle=new Rectangle(jsonData.originalPos.x, jsonData.originalPos.y, jsonData.originalPos.w, jsonData.originalPos.h);

			if (jsonData.hasOwnProperty('frame'))
				frame=new Rectangle(jsonData.frame.x, jsonData.frame.y, jsonData.frame.w, jsonData.frame.h);

			if (jsonData.hasOwnProperty('aggregatedMatrix'))
				aggregatedMatrix=new Matrix(jsonData.aggregatedMatrix.a, jsonData.aggregatedMatrix.b, jsonData.aggregatedMatrix.x, jsonData.aggregatedMatrix.d, jsonData.aggregatedMatrix.tx, jsonData.aggregatedMatrix.ty);
		}

	}
}