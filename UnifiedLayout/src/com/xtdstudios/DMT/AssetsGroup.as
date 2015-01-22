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
	import com.xtdstudios.DMT.atlas.Atlas;
	import com.xtdstudios.DMT.events.AssetGroupEvent;
	import com.xtdstudios.DMT.persistency.IByteArrayPersistencyManager;
	import com.xtdstudios.DMT.serialization.ISerializable;
	import com.xtdstudios.DMT.utils.AtlasesDictionary;

	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;

	public class AssetsGroup extends EventDispatcher implements ISerializable
	{
		private var m_name					        : String;
		private var m_atlases				        : AtlasesDictionary;
		private var m_assetsDefinitions		        : AssetsDefinitionsDictionary;
		private var m_ready					        : Boolean;
		private var m_isLoading				        : Boolean;
		private var m_byteArrayPersistencyManager	: IByteArrayPersistencyManager;
		
		public function AssetsGroup() {
			init();
		}

		private function init():void {
			m_ready = false;
			m_isLoading = false;
			m_atlases = new AtlasesDictionary();
			m_assetsDefinitions = new AssetsDefinitionsDictionary();
		}

		static public function getAssetsGroup(groupName : String, byteArrayPersistencyManager:IByteArrayPersistencyManager): AssetsGroup
		{
			var assetsGroup: AssetsGroup = new AssetsGroup();
			assetsGroup.m_name = groupName;
			assetsGroup.m_byteArrayPersistencyManager = byteArrayPersistencyManager;
			
			return assetsGroup;
		}

// ----------------------------- INTERNAL FUNCTIONS ----------------------------------------------				
		
		
		internal function addAtlas(atlas:Atlas):void
		{
			if (atlas.name==null || atlas.name=="")
			{
				throw new IllegalOperationError("atlas.name cannot be empty");
			}
			
			if (m_atlases.nameExist(atlas.name))
			{
				throw new IllegalOperationError("An atlas with the same name already exist, " + atlas.name);
			}
			
			m_atlases.addAtlas(atlas, atlas.name);
		}
		
		internal function addAssetDef(assetDef:AssetDef):void
		{
			if (m_assetsDefinitions.getAssetDef(assetDef.uniqueAlias)==null)
				m_assetsDefinitions.registerAssetDef(assetDef);
			else
				trace("An assetDef with the same uniqueAlias already exist --> " + assetDef.uniqueAlias);
//				throw new IllegalOperationError("An assetDef with the same uniqueAlias already exist --> " + assetDef.uniqueAlias);
		}
		
		
		internal function get byteArrayPersistencyManager():IByteArrayPersistencyManager
		{
			return m_byteArrayPersistencyManager;
		}
		
		internal function set byteArrayPersistencyManager(value:IByteArrayPersistencyManager):void
		{
			m_byteArrayPersistencyManager = value;
		}
		
// ----------------------------- SERIALIZE FUNCTIONS ----------------------------------------------				

		public function toJson():Object {
			return {
				name: m_name,
				atlases: m_atlases.toJson(),
				assetsDefinitions: m_assetsDefinitions.toJson()
			};
		}

		public function fromJson(jsonData:Object):void {
			dispose();
			init();

			m_name = jsonData.name;
			m_atlases.fromJson(jsonData.atlases);
			m_assetsDefinitions.fromJson(jsonData.assetsDefinitions);
		}

		public function disposeAtlases():void
		{
			if (m_isLoading)
				return;
			m_isLoading = true;
			var atlasesVector : Array = m_atlases.toArray();
			for each (var atlas:Atlas in atlasesVector) {
				atlas.disposeBitmapData();
			}
		}
		
		public function deleteAtlases():void
		{
			if (!m_byteArrayPersistencyManager || m_isLoading)
				return;
			
			m_isLoading = true;
			var atlasesVector : Array = m_atlases.toArray();
			for each (var atlas:Atlas in atlasesVector) {
				m_byteArrayPersistencyManager.deleteByteArray(atlas.name);
			}	
		}
		
		public function saveAtlases():void
		{
			if (!m_byteArrayPersistencyManager || m_isLoading)
				return;

			m_isLoading = true;
			var atlasesVector : Array = m_atlases.toArray();
			for each (var atlas:Atlas in atlasesVector) {
				m_byteArrayPersistencyManager.saveByteArray(atlas.name,atlas.encodeBitmap());
			}			
		}

		private var m_atlasesToLoad : int;
		public function loadAtlases():void
		{
			if (!m_byteArrayPersistencyManager || m_isLoading)
				return;
			
			m_isLoading = true;
			m_atlasesToLoad = m_atlases.length;
			var atlasesVector : Array = m_atlases.toArray();
			for each (var atlas:Atlas in atlasesVector) {
				atlas.addEventListener(Event.COMPLETE, onAtlasReady);
				atlas.decodeBitmap(m_byteArrayPersistencyManager.loadByteArray(atlas.name));
			}			
		}
		
		internal function onAtlasReady(e:Event) : void
		{
			e.target.removeEventListener(Event.COMPLETE, onAtlasReady);
			m_atlasesToLoad--;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, m_atlases.length-m_atlasesToLoad, m_atlases.length));
			if (m_atlasesToLoad == 0)
			{
				markReady();
			}
		}
		
// ----------------------------- PUBLIC FUNCTIONS ----------------------------------------------
		
		
		public function get name():String
		{
			return m_name;
		}
		
		public function getAssetDef(uniqueAlias:String):AssetDef
		{
			return m_assetsDefinitions.getAssetDef(uniqueAlias);
		}
		
		public function get atlasesList():Array
		{
			return  m_atlases.toArray();
		}
		
		public function get AssetDefList():Vector.<AssetDef>
		{
			return m_assetsDefinitions.toVector();
		}

		public function get ready():Boolean
		{
			return m_ready;
		}

		internal function markReady():void
		{
			m_ready = true;
			m_isLoading = false;
			dispatchEvent(new AssetGroupEvent(AssetGroupEvent.READY, this));
		}
		
		public function dispose():void
		{
			if (m_atlases!=null)
			{
				m_atlases.dispose();
				m_atlases = null;
			}
			
			if (m_assetsDefinitions!=null)
			{
				m_assetsDefinitions.dispose();
				m_assetsDefinitions = null;
			}
		}

	}
}