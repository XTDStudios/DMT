package com.xtdstudios.common.assetsLoader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class DummyAssetsLoader extends EventDispatcher implements IAssetsLoader
	{
		/**
		 * Use this class as a Dummy implementation of IAssetsLoader.
		 * For example: You embed your assets using the Embed tag, so no real loading is needed.
		 * But still you don't want your code to "know" that. So you'll use the DummyAssetsLoader 
		 * to fake loading. 
		 * 
		 */
		public function DummyAssetsLoader()
		{
			super();
		}
		
		public function getAssetClass(symbol:String):Class
		{
			return null;
		}
		
		public function hasAssetClass(symbol:String):Boolean
		{
			return true;
		}
		
		public function getAvailableAssetsNames():Vector.<String>
		{
			return null;
		}
		
		public function initializeAllAssets():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get inProgress():Boolean
		{
			return false;
		}
		
		public function get assetsReady():Boolean
		{
			return true;
		}
		
		public function get loadingProgress():Number
		{
			return 1.0;
		}
		
		public function dispose():void
		{
		}
	}
}