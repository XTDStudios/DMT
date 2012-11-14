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
	
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;

	public class AssetDef implements IExternalizable
	{
		private var m_uniqueAlias			: String;
		private var m_textureID				: String;
		private var m_isMovieclip			: Boolean;
		
		private var m_children				: Vector.<AssetDef>;
		private var m_rasterizedAssetData  	: RasterizedAssetData;
		
		public function AssetDef() {
			m_children = new Vector.<AssetDef>
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
		
		public function writeExternal(output:IDataOutput): void {
			output.writeUTF(m_uniqueAlias);
			output.writeUTF((m_textureID)?m_textureID:"");
			output.writeBoolean(m_isMovieclip);
			output.writeObject(m_children);
			output.writeObject(m_rasterizedAssetData);
		}
		
		public function readExternal(input:IDataInput): void {
			m_uniqueAlias = input.readUTF();
			m_textureID = input.readUTF();
			m_isMovieclip = input.readBoolean();
			m_children = input.readObject();
			m_rasterizedAssetData = input.readObject();
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