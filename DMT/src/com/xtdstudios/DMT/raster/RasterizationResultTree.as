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
	import flash.display.BitmapData;

	public class RasterizationResultTree
	{
		private var m_children				: Vector.<RasterizationResultTree>;

		public var graphicsBitmapData 	: BitmapData = null;
		public var rasterizedAssetData	: RasterizedAssetData;
		public var parent				: RasterizationResultTree;
		public var isMovieClip			: Boolean;
		public var isButton				: Boolean;
		
		public function RasterizationResultTree()
		{
			parent = null;
			m_children = new Vector.<RasterizationResultTree>;
			rasterizedAssetData = new RasterizedAssetData();
		}
		

		public function dispose():void
		{
			if (graphicsBitmapData!=null)
			{
				graphicsBitmapData.dispose();
				graphicsBitmapData = null;
			}
			
			if (m_children!=null)
			{
				while (m_children.length>0)
				{
					m_children.pop();
				}
				
				m_children = null;
			}
		}
		
		public function getChildIndex(child:RasterizationResultTree):int
		{
			return m_children.indexOf(child);
		}
		
		public function get numChildren():int
		{
			return m_children.length;
		}
		
		public function getChildAt(idx:int):RasterizationResultTree
		{
			return m_children[idx];
		}
		
		public function addChild(child:RasterizationResultTree):void
		{
			m_children.push(child);
			child.parent = this;
		}
	}
}