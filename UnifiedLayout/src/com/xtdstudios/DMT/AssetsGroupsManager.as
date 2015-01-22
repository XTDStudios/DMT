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
	import com.xtdstudios.DMT.persistency.IAssetsGroupPersistencyManager;
	import com.xtdstudios.DMT.persistency.IByteArrayPersistencyManager;

	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	
	public class AssetsGroupsManager
	{
		private var m_assetGroupsDict 				: Dictionary;
		private var m_assetsGroupPersistencyManager	: IAssetsGroupPersistencyManager;
		private var m_byteArrayPersistencyManager	: IByteArrayPersistencyManager;
		
		public function AssetsGroupsManager(assetGroupPersistencyManager:IAssetsGroupPersistencyManager, byteArrayPersistencyManager:IByteArrayPersistencyManager)
		{
			m_assetsGroupPersistencyManager = assetGroupPersistencyManager;
			m_byteArrayPersistencyManager = byteArrayPersistencyManager;
			m_assetGroupsDict = new Dictionary;
		}
				
		
// ----------------------------- PUBLIC FUNCTIONS ----------------------------------------------

		public function set assetsGroupPersistencyManager(value:IAssetsGroupPersistencyManager):void {
			m_assetsGroupPersistencyManager = value;
		}

		public function set byteArrayPersistencyManager(value:IByteArrayPersistencyManager):void {
			m_byteArrayPersistencyManager = value;
			for (var key:Object in m_assetGroupsDict)
			{
				m_assetGroupsDict[key].byteArrayPersistencyManager = value;
			}
		}

		public function build(groupName:String, isGroupTransparent:Boolean=true, allow4096Textures:Boolean=false, matrixAccuracyPercent:Number=1.0):AssetsGroupBuilder
		{
			if (!groupName)
			{
				throw new IllegalOperationError("The groupName cannot be empty");				
			}
			
			if (m_assetGroupsDict[groupName])
			{
				throw new IllegalOperationError("A group with the same name already exist, " + groupName);
			}
			
			var newGroup	: AssetsGroup;
			newGroup = AssetsGroup.getAssetsGroup(groupName, m_byteArrayPersistencyManager);
			m_assetGroupsDict[groupName]=newGroup;
			
			return new AsyncAssetsGroupBuilderImpl(newGroup, isGroupTransparent, allow4096Textures, matrixAccuracyPercent);
		}

		
		public function get(groupName:String):AssetsGroup
		{
			if (!groupName)
			{
				throw new IllegalOperationError("The groupName cannot be empty");
			}
			
			return m_assetGroupsDict[groupName];
		}
		
		public function get getAssetGroupsDictionary(): Dictionary
		{
			return m_assetGroupsDict;
		}
		
		
		public function loadFromCache(groupName:String): AssetsGroup {
			if (!m_assetsGroupPersistencyManager)
				throw new IllegalOperationError("It is not possible to load cache, because the cache is OFF");

			var assetsGroup:AssetsGroup = m_assetsGroupPersistencyManager.loadAssetsGroup(groupName);
			assetsGroup.byteArrayPersistencyManager = m_byteArrayPersistencyManager;
			m_assetGroupsDict[groupName]=assetsGroup;
			
			return assetsGroup;
		}
		
		public function saveCacheByName(groupName:String): void {
			var ag:AssetsGroup = get(groupName);
			saveCache(ag);
		}
		
		public function saveCache(assetsGroup:AssetsGroup): void {
			assetsGroup.saveAtlases();
			if (m_assetsGroupPersistencyManager)
				m_assetsGroupPersistencyManager.saveAssetsGroup(assetsGroup);
		}
		
		public function isCacheExist(groupName:String): Boolean {
			return (m_assetsGroupPersistencyManager && m_assetsGroupPersistencyManager.isExist(groupName));
		}
		
		public function clearCacheByName(groupName:String): void {
			var assetsGroup:AssetsGroup = get(groupName);
			assetsGroup.deleteAtlases();
			if (m_assetsGroupPersistencyManager)
				m_assetsGroupPersistencyManager.deleteAssetsGroup(groupName);
		}
		
		public function clearCache(assetsGroup:AssetsGroup): void {
			clearCacheByName(assetsGroup.name);
		}
		
		
		public function dispose():void
		{
			if (m_assetGroupsDict)
			{
				for (var key:Object in m_assetGroupsDict)
				{
					m_assetGroupsDict[key].dispose();
				}
				m_assetGroupsDict = null;
			}
			
			m_assetsGroupPersistencyManager = null;
		}
	}
}