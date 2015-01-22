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
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.ApplicationDomain;
	
	public class BaseAssetsLoader extends EventDispatcher implements IAssetsLoader
	{
		private var m_loaders					: Vector.<Loader>;
		private var m_inProgress				: Boolean;
		
		protected var m_applicationDomain 		: ApplicationDomain;
		protected var m_assetsReady				: Boolean;
		protected var m_assetsLoadingProgress	: Number;
		protected var m_countCompleted			: int;
		
		public function BaseAssetsLoader(customApplicationDomain:ApplicationDomain = null)
		{
			if (customApplicationDomain)
				m_applicationDomain = customApplicationDomain;
			else
				m_applicationDomain = new ApplicationDomain();
			m_assetsLoadingProgress = 0.0;
			m_inProgress = false;
			m_assetsReady = false;
			m_loaders = new Vector.<Loader>;
			super();
		}		
		
		public function get inProgress():Boolean
		{
			return m_inProgress;
		}

		protected function removeLoader(loader:Loader):void
		{
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.contentLoaderInfo.removeEventListener(Event.OPEN, onOpen);
			loader.contentLoaderInfo.removeEventListener(Event.INIT, onInit);
			
			m_loaders.splice(m_loaders.indexOf(loader), 1);
		}
		
		protected function addLoader():Loader
		{
			var loader : Loader = new Loader();
			
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.contentLoaderInfo.addEventListener(Event.OPEN, onOpen);
			loader.contentLoaderInfo.addEventListener(Event.INIT, onInit);
			
			m_loaders.push(loader);
			
			return loader;
		}
		
		public function initializeAllAssets():void
		{
			// override
			m_inProgress = true;
		}
		
		private function onSecurityError(event:SecurityErrorEvent):void
		{
			dispatchEvent(event);
		}
		
		private function onError(event:IOErrorEvent):void
		{
			dispatchEvent(event);
		}
		
		private function onOpen(event:Event):void
		{
			dispatchEvent(event);
		}
		
		private function onInit(event:Event):void
		{
			dispatchEvent(event);
		}
		
		private function onComplete(event:Event):void
		{
			m_countCompleted++;
			if (m_countCompleted==m_loaders.length)
			{
				// remove all the loaders
				while (m_loaders.length>0)
					removeLoader(m_loaders.pop());

				m_loaders = new Vector.<Loader>;
				
				
				// we aer now ready
				m_assetsReady = true;
				m_inProgress = false;
				m_assetsLoadingProgress = 1.0;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function onProgress(event:ProgressEvent):void
		{
			var allActive 	: Boolean = true;
			var bytesTotal	: uint = 0;
			var bytesLoaded	: uint = 0;
			
			for each(var loader:Loader in m_loaders)
			{
				if (loader.contentLoaderInfo.bytesTotal==0)
				{
					allActive = false;
				}
				else
				{
					bytesTotal = bytesTotal + loader.contentLoaderInfo.bytesTotal;
					bytesLoaded = bytesLoaded + loader.contentLoaderInfo.bytesLoaded;
				}
			}
			
			if (allActive==true)
			{
				m_assetsLoadingProgress = bytesLoaded/bytesTotal;
				dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));
			}
		}
		
		public function get assetsReady():Boolean
		{
			return m_assetsReady;
		}
		
		public function get loadingProgress():Number
		{
			return m_assetsLoadingProgress;
		}
		
		public function getAvailableAssetsNames():Vector.<String>
		{
			return m_applicationDomain.getQualifiedDefinitionNames();
		}

		public function hasAssetClass(symbol:String):Boolean
		{
			return m_applicationDomain.hasDefinition(symbol);	
		}
		
		public function getAssetClass(symbol:String):Class
		{
			return m_applicationDomain.getDefinition(symbol) as Class;
		}
		
		public function dispose():void
		{
			m_applicationDomain = null;
		}
	}
}