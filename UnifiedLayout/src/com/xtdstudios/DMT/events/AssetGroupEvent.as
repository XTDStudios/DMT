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
package com.xtdstudios.DMT.events
{
	import com.xtdstudios.DMT.AssetsGroup;
	
	import flash.events.Event;

	public class AssetGroupEvent extends DTMEvent
	{
		public static const READY	: String = "DTMAssetGroupReady";
		
		private var m_assetGroup	: AssetsGroup;
		
		public function AssetGroupEvent(type:String, assetGroup:AssetsGroup)
		{
			super(type);
			m_assetGroup = assetGroup;
		}

		public override function clone():Event {
			return new AssetGroupEvent(type, m_assetGroup);
		}
		
		public function get assetGroup():AssetsGroup
		{
			return m_assetGroup;
		}
	}
}