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
	import flash.display.PNGEncoderOptions;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;

	public class FileUtils
	{
		private static var m_cacheDir 	: File;
		private static var m_tempDir 	: File;
		
		public static function getCacheDir():File
		{
			return File.cacheDirectory;

			// As of AIR 3.6, this is not required anymore
//			if (!m_cacheDir)
//			{
//				var os : String = Capabilities.os.toLowerCase();
//
//				if (os.indexOf("windows") >= 0)		// windows
//				{
//					m_cacheDir = File.applicationStorageDirectory;
//				}
//				else if (os.indexOf("mac") >= 0)	// Macintosh
//				{
//					m_cacheDir = File.applicationStorageDirectory;
//				}
//				else if (os.indexOf("linux") >= 0)	// Android
//				{
//					m_cacheDir = File.applicationStorageDirectory;
//				}
//				else if (os.indexOf("iphone") >= 0)	// iPhone/iPad
//				{
//					m_cacheDir = new File(File.applicationDirectory.nativePath +"/\.\./Library/Caches");
//				}
//			}
//
//			return m_cacheDir;
		}
		
		public static function getTempDir():File
		{
			if (!m_tempDir)
			{
				var os : String = Capabilities.os.toLowerCase();
				
				if (os.indexOf("iphone") >= 0)	// iPhone/iPad
				{
					m_tempDir = new File(File.applicationDirectory.nativePath +"/\.\./tmp");
				}
				else
				{
					m_tempDir = File.createTempDirectory();
				}
			}
			
			return m_tempDir;
		}
		
		public static function saveToPNGFile(bitmapData:BitmapData, filePath:String):void
		{
			var imgByteArray	: ByteArray;
			imgByteArray = new ByteArray();
			bitmapData.encode(new Rectangle(0, 0, bitmapData.width, bitmapData.height), new PNGEncoderOptions(true), imgByteArray);
			
			var fs:FileStream = new FileStream();
			var fl:File = new File(filePath);
			try
			{
				//open file in write mode
				fs.open(fl, FileMode.WRITE);
				//write bytes from the byte array
				fs.writeBytes(imgByteArray);
				//close the file
				fs.close();
			}
			catch(e:Error)
			{
				trace(e.message);
			}
		}
	}
}