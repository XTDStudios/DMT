package com.xtdstudios.common.assetsFactory
{
	import flash.errors.IllegalOperationError;

	public class AssetsFactoryFromEmbed implements IAssetsFactory
	{
		private var m_objectWithEmbeds			: Object;

		public function AssetsFactoryFromEmbed(objectWithEmbeds	: Object)
		{
			m_objectWithEmbeds = objectWithEmbeds;
		}
		
		public function hasAsset(symbol:String):Boolean
		{
			if (m_objectWithEmbeds)
			{
				return m_objectWithEmbeds.hasOwnProperty(symbol);
			}
			else
			{
				new IllegalOperationError("objectWithEmbeds was not set in the AssetsFactoryFromEmbed constructor");
				return null;
			}
		}
		
		public function getAssetClass(className:String):Class
		{
			if (m_objectWithEmbeds)
			{
				var classDef : Class = m_objectWithEmbeds[className];
				return classDef;
			}
			else
			{
				new IllegalOperationError("objectWithEmbeds was not set in the AssetsFactoryFromEmbed constructor");
				return null;
			}
		}
		
		public function createAsset(symbol:String):Object
		{
			if (m_objectWithEmbeds)
			{
				var definition : Object = m_objectWithEmbeds[symbol];
				if (definition is Class)
				{
					var cls : Class = definition as Class;
					return new cls;
				}
				else
				{
					return definition;
				}
			}
			else
			{
				new IllegalOperationError("objectWithEmbeds was not set on AssetsFactoryFromEmbed");
				return null;
			}
		}
		
		public function dispose():void
		{
			m_objectWithEmbeds = null;
		}
	}
}