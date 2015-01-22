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
	import flash.display.Loader;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	public class AssetsLoaderFromByteArray extends BaseAssetsLoader
	{
		protected var m_byteArrays		: Vector.<ByteArray>;
		
		public function AssetsLoaderFromByteArray(byteArrays : Vector.<ByteArray>, customApplicationDomain:ApplicationDomain = null)
		{
			m_byteArrays = byteArrays;
			super(customApplicationDomain);
		}		
		
		override public function initializeAllAssets():void
		{
			super.initializeAllAssets();
			
			// the loader
			m_countCompleted = 0;
			m_assetsReady = false;
			m_assetsLoadingProgress = 0.0;
			for each(var byteArray:ByteArray in m_byteArrays)
			{
				var loaderContext	: LoaderContext = new LoaderContext(false, m_applicationDomain);
				var loader			: Loader = addLoader();

				loaderContext.allowCodeImport = true;
				loader.loadBytes(byteArray, loaderContext);
			}
		}
		
		override public function dispose():void
		{
			m_byteArrays = null;
			super.dispose();
		}
	}
}