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
package com.xtdstudios.common.assetsLoader
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	public class AssetsLoaderFromFileSystem extends AssetsLoaderFromByteArray
	{
		private var m_filePaths				: Vector.<String>;

		public function AssetsLoaderFromFileSystem(filePaths:Vector.<String>)
		{
			m_filePaths = filePaths;
			super(new Vector.<ByteArray>);
		}
		
		private function loadFromFile(swfPath:String):ByteArray
		{
			var result:ByteArray = new ByteArray();
			var fs:FileStream = new FileStream();
			var fl:File = File.applicationDirectory.resolvePath(swfPath);
			if (fl.exists==false)
				return null;
			
			try
			{
				fs.open(fl, FileMode.READ);
				fs.readBytes(result);
				fs.close();
			}
			catch(e:Error)
			{
				trace(e.message);
			}
			
			return result;
		}
		
		override public function initializeAllAssets():void
		{
			// load the files
			for each(var filePath:String in m_filePaths)
			{
				m_byteArrays.push(loadFromFile(filePath));
			}

			super.initializeAllAssets();
		}
		
	}
}