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
package com.xtdstudios.DMT.persistency.impl
{
	import com.xtdstudios.DMT.AssetDef;
	import com.xtdstudios.DMT.AssetsDefinitonsDictionary;
	import com.xtdstudios.DMT.AssetsGroup;
	import com.xtdstudios.DMT.atlas.Atlas;
	import com.xtdstudios.DMT.persistency.AssetsGroupPersistencyManager;
	import com.xtdstudios.DMT.persistency.ByteArrayPersistencyManager;
	import com.xtdstudios.DMT.raster.RasterizedAssetData;
	import com.xtdstudios.DMT.utils.AtlasesDictionary;
	
	import flash.display.PNGEncoderOptions;
	import flash.errors.IllegalOperationError;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;

	public class ExternalAssetsGroupPersistencyManager implements AssetsGroupPersistencyManager
	{
		private var m_persistencyManager :ByteArrayPersistencyManager
		private var m_version		: String;
		
		public function ExternalAssetsGroupPersistencyManager(pm :ByteArrayPersistencyManager, version: String)
		{
			m_persistencyManager = pm;
			m_version = version;
			
			registerClassAlias("AssetsGroup", AssetsGroup);
			registerClassAlias("AtlasesDictionary", AtlasesDictionary);
			registerClassAlias("PNGEncoderOptions", PNGEncoderOptions);
			registerClassAlias("AssetsDefinitonsDictionary", AssetsDefinitonsDictionary);
			registerClassAlias("Atlas", Atlas);
			registerClassAlias("AssetDef", AssetDef);
			registerClassAlias("RasterizedAssetData", RasterizedAssetData);
			registerClassAlias("Point", Point);
			registerClassAlias("Rectangle", Rectangle);
			registerClassAlias("Matrix", Matrix);
		}
		
		private function getCacheFileName(assetsGroupName: String): String
		{
			return assetsGroupName+"_version_"+m_version+".cache";
		}
		
		public function saveData(fileName: String, data: Object):void
		{
			if (data is AssetsGroup)
				saveAssetsGroup(data as AssetsGroup);
			else
				new IllegalOperationError("ExternalAssetsGroupPersistencyManager:saveData accepts only AssetGroup types");
		}
		
		public function loadData(fileName: String): Object
		{
			return loadAssetsGroup(fileName);
		}
		
		public function saveAssetsGroup(assetsGroup: AssetsGroup):void
		{
			var fileStream:FileStream = new FileStream(); 
			try 
			{
				var m_br : ByteArray = new ByteArray();
				m_br.writeUTF(m_version);
				m_br.writeObject(assetsGroup);
				
				m_persistencyManager.saveData(getCacheFileName(assetsGroup.name), m_br);
			} 
			finally 
			{
				fileStream.close();
			}
		}
		
		public function loadAssetsGroup(groupName: String): AssetsGroup
		{
			var m_br : ByteArray = m_persistencyManager.loadByteArray(getCacheFileName(groupName));
			var cacheVersion : String = m_br.readUTF();
			if (cacheVersion != m_version)
				throw new IllegalOperationError("Incompatible cache file format");
			var loadedAssetsGroup : AssetsGroup = m_br.readObject() as AssetsGroup;
			return loadedAssetsGroup;
		}
		
		
		public function isExist(groupName:String): Boolean
		{
			return m_persistencyManager.isExist(getCacheFileName(groupName));
		}
		
		public function deleteData(groupName:String): void
		{
			m_persistencyManager.deleteData(getCacheFileName(groupName));
		}
		
		public function list(): Array
		{
			return m_persistencyManager.list();
		}
		
		public function dispose():void
		{
			m_persistencyManager.dispose();
		}
	}
}