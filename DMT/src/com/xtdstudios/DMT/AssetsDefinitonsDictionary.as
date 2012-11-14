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
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;

	public class AssetsDefinitonsDictionary implements IExternalizable
	{
		private var m_dict	: Dictionary;

		public function AssetsDefinitonsDictionary()
		{
			m_dict = new Dictionary(false);
		}
		
		// ----------------------------- SERIALIZE FUNCTIONS ----------------------------------------------				
		
		public function writeExternal(output:IDataOutput): void {			
			output.writeObject(m_dict);
		}
		
		public function readExternal(input:IDataInput): void {			
			m_dict = input.readObject();
		}
		
		
		
		public function getAssetDef(uniqueAlias:String):AssetDef
		{
			return m_dict[uniqueAlias] as AssetDef;
		}
		
		public function registerAssetDef(assetDef:AssetDef):void
		{
			if (assetDef.uniqueAlias==null || assetDef.uniqueAlias=="")
			{
				throw new IllegalOperationError("uniqueAlias cannot be empty");
			}
			
			if (m_dict[assetDef.uniqueAlias]!=null)
			{
				throw new IllegalOperationError("An assetDef with the same uniqueAlias already exist, " + assetDef.uniqueAlias);
			}
			
			m_dict[assetDef.uniqueAlias] = assetDef;			
		}
		
		public function toVector():Vector.<AssetDef>
		{
			var result : Vector.<AssetDef> = new Vector.<AssetDef>;
			for each(var assetDef:AssetDef in m_dict)
			{
				result.push(assetDef);
			}
			
			return result;
		}
		
		public function dispose():void
		{
			for (var uniqueAlias:String in this)
			{
				var assetDef : AssetDef = m_dict[uniqueAlias];
				assetDef.dispose();
			}
			
			m_dict = null;
		}
	}
}