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
	import com.xtdstudios.DMT.AssetsGroup;
	import com.xtdstudios.DMT.persistency.IAssetsGroupPersistencyManager;

	import flash.errors.IllegalOperationError;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class AssetsGroupToFilePersistencyManager implements IAssetsGroupPersistencyManager
	{
		private var m_version	: String;
		private var m_baseDir	: File;

		public function AssetsGroupToFilePersistencyManager(version:String, baseDir:File)
		{
			m_version = version;
			m_baseDir = baseDir;
		}

		private function getCacheFile(assetsGroupName: String):File
		{
			var fileName : String = assetsGroupName+"_version_"+m_version+".json";
			return m_baseDir.resolvePath(fileName);
		}
		
		public function saveAssetsGroup(assetsGroup: AssetsGroup):void
		{
			var json : Object = {
				version: m_version
			};
			json[assetsGroup.name] = assetsGroup.toJson();

			saveJson(assetsGroup.name, json);
		}

		private function saveJson(fileName:String, json:Object):void {
			var fileStream:FileStream = new FileStream();
			try
			{
				var file : File = getCacheFile(fileName);
				var jsonStr : String = JSON.stringify(json);
				fileStream.open(file, FileMode.WRITE);
				fileStream.writeUTFBytes( jsonStr );
			}
			finally
			{
				fileStream.close();
			}
		}

		public function loadAssetsGroup(groupName: String):AssetsGroup
		{
			var json : Object = loadJson(groupName);
			var cacheVersion : String = json.version;
			if (cacheVersion != m_version)
				throw new IllegalOperationError("Incompatible cache file format");

			var loadedAssetsGroup : AssetsGroup = new AssetsGroup();
			loadedAssetsGroup.fromJson(json[groupName]);
			return loadedAssetsGroup;
		}

		private function loadJson(fileName:String):Object {
			var jsonStr : String;
			var fileStream:FileStream = new FileStream();
			try
			{
				fileStream.open(getCacheFile(fileName), FileMode.READ);
				jsonStr = fileStream.readUTFBytes(fileStream.bytesAvailable);
			}
			finally
			{
				fileStream.close();
			}

			return JSON.parse(jsonStr);
		}

		public function isExist(fileName:String): Boolean
		{
			return getCacheFile(fileName).exists;
		}

		public function deleteAssetsGroup(groupName: String): void
		{
			getCacheFile(groupName).deleteFile();
		}

		public function dispose():void
		{
			m_baseDir = null;
		}
	}
}