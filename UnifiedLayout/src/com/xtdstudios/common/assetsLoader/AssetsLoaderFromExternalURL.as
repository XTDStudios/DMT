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
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class AssetsLoaderFromExternalURL extends BaseAssetsLoader
	{
		private var m_filesURLs				: Vector.<String>;
		
		public function AssetsLoaderFromExternalURL(filesURLs : Vector.<String>, customApplicationDomain:ApplicationDomain = null)
		{
			m_filesURLs = filesURLs;
			super(customApplicationDomain);
		}		
		
		override public function initializeAllAssets():void
		{
			super.initializeAllAssets();
			
			// the loader
			m_countCompleted = 0;
			m_assetsReady = false;
			m_assetsLoadingProgress = 0.0;
			for each(var fileURL:String in m_filesURLs)
			{
				var urlRequest		: URLRequest = new URLRequest(fileURL);
				var loaderContext	: LoaderContext = new LoaderContext(false, m_applicationDomain);
				var loader			: Loader = addLoader();
				
				loaderContext.allowCodeImport = true;
				loader.load(urlRequest, loaderContext);
			}
		}
		
		override public function dispose():void
		{
			m_filesURLs = null;
			super.dispose();
		}
	}
}