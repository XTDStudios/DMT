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
	import com.xtdstudios.DMT.raster.RasterizedAssetData;
	import com.xtdstudios.DMT.serialization.ISerializable;

	public class AssetDef implements ISerializable
	{
		private var m_uniqueAlias			: String;
		private var m_textureID				: String;
		private var m_isMovieclip			: Boolean;
		
		private var m_children				: Vector.<AssetDef>;
		private var m_rasterizedAssetData  	: RasterizedAssetData;
		
		public function AssetDef() {
			init();
		}

		private function init():void {
			m_children = new Vector.<AssetDef>;
		}

		public function get isMovieclip():Boolean
		{
			return m_isMovieclip;
		}

		static public function createAssetDef(isMovieClip:Boolean, rasterizedAssetData:RasterizedAssetData=null): AssetDef
		{
			var assetDef: AssetDef = new AssetDef();
			assetDef.m_rasterizedAssetData = rasterizedAssetData;
			assetDef.m_uniqueAlias = assetDef.className;
			assetDef.m_isMovieclip = isMovieClip;
			
			return assetDef;
		}
		
		// ----------------------------- SERIALIZE FUNCTIONS ----------------------------------------------				

		public function toJson():Object {
			var children : Array = [];
			for (var i:int=0; i<m_children.length; i++)
			{
				children.push( m_children[i].toJson() );
			}

			return {
				uniqueAlias: m_uniqueAlias,
				textureID: m_textureID ? m_textureID : "",
				isMovieclip: m_isMovieclip,
				children: children,
				rasterizedAssetData: m_rasterizedAssetData.toJson()
			}
		}

		public function fromJson(jsonData:Object):void {
			dispose();
			init();
			m_uniqueAlias = jsonData.uniqueAlias;
			m_textureID = jsonData.textureID;
			m_isMovieclip = jsonData.isMovieclip;
			m_rasterizedAssetData = new RasterizedAssetData();
			m_rasterizedAssetData.fromJson(jsonData.rasterizedAssetData);

			var children : Array = (jsonData.children as Array);
			for (var i:int=0; i<children.length; i++) {
				var childData : Object = children[i];
				var assetDef : AssetDef = new AssetDef();
				assetDef.fromJson(childData);
				m_children.push(assetDef);
			}
		}

		public function get uniqueAlias():String
		{
			return m_uniqueAlias;
		}

		public function set uniqueAlias(value:String):void
		{
			m_uniqueAlias = value;
		}

		public function get textureID():String
		{
			return m_textureID;
		}

		public function set textureID(value:String):void
		{
			m_textureID = value;
		}

		public function get rasterizedAssetData():RasterizedAssetData
		{
			return m_rasterizedAssetData;
		}

		public function get children():Vector.<AssetDef>
		{
			return m_children;
		}

		public function get className():String
		{
			return  m_rasterizedAssetData.originalClassName;
		}

		public function get instanceName():String
		{
			return  m_rasterizedAssetData.originalInstanceName;
		}

		public function dispose():void
		{
			if (m_children!=null)
			{
				while (m_children.length>0)
					m_children.pop().dispose();
				
				m_children = null;
			}
			
			m_rasterizedAssetData = null;
		}
	}
}