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
	import com.xtdstudios.DMT.persistency.ByteArrayPersistencyManager;
	
	import flash.errors.IllegalOperationError;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class ByteArrayToFilePersistencyManager implements ByteArrayPersistencyManager
	{
		private var m_baseDir	: File;
		
		public function ByteArrayToFilePersistencyManager(baseDir:File)
		{
			m_baseDir = baseDir;
		}
		
		private function getCacheFile(fileName: String): File
		{
			var file : File = m_baseDir.resolvePath(fileName);
			return file;
		}
		
		public function saveData(fileName: String, data: Object):void
		{
			if (data is ByteArray)
				saveByteArray(fileName,data as ByteArray);
			else
				new IllegalOperationError("ByteArrayToFilePersistencyManager:saveData accepts only ByteArray types");
		}
		
		public function loadData(fileName: String): Object
		{
			return loadByteArray(fileName);
		}
		
		public function saveByteArray(fileName: String, data: ByteArray):void
		{
			var fileStream:FileStream = new FileStream(); 
			try 
			{
				var file : File = getCacheFile(fileName);
				fileStream.open(file, FileMode.WRITE); 
				fileStream.writeBytes(data);
			} 
			finally 
			{
				fileStream.close();
			}
		}
		
		public function loadByteArray(fileName: String): ByteArray
		{
			var fileStream:FileStream = new FileStream();
			var br : ByteArray = new ByteArray();
			try {
				
				fileStream.open(getCacheFile(fileName), FileMode.READ);
				fileStream.readBytes(br);
			} finally {
				fileStream.close();
			}
			return br;
		}
		
		
		public function isExist(groupName:String): Boolean
		{
			return getCacheFile(groupName).exists;
		}
		
		public function deleteData(groupName:String): void
		{
			getCacheFile(groupName).deleteFile();
		}
		
		public function list(): Array
		{
			var directoryListing:Array = m_baseDir.getDirectoryListing();
			return directoryListing.map(function(element:File,...ignore:*):String {
				return element.name;
			});
		}
		
		public function dispose():void
		{
			m_baseDir = null;
		}
	}
}