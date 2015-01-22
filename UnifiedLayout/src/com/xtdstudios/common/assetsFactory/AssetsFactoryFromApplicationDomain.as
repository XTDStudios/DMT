package com.xtdstudios.common.assetsFactory
{
	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;

	public class AssetsFactoryFromApplicationDomain implements IAssetsFactory
	{
		private var m_applicationDomain			: ApplicationDomain;

		public function AssetsFactoryFromApplicationDomain(applicationDomain:ApplicationDomain)
		{
			m_applicationDomain = applicationDomain;
		}
		
		public function hasAsset(symbol:String):Boolean
		{
			if (m_applicationDomain)
			{
				return m_applicationDomain.hasDefinition(symbol);
			}
			else
			{
				new IllegalOperationError("applicationDomain was not set on AssetsFactoryFromApplicationDomain constructor");
				return null;
			}
		}
		
		public function getAssetClass(className:String):Class
		{
			if (m_applicationDomain)
			{
				var classDef : Class = m_applicationDomain.getDefinition(className) as Class;
				return classDef;
			}
			else
			{
				new IllegalOperationError("applicationDomain was not set on AssetsFactoryFromApplicationDomain constructor");
				return null;
			}
		}
		
		public function createAsset(symbol:String):Object
		{
			if (m_applicationDomain)
			{
				var definition : Object = m_applicationDomain.getDefinition(symbol);
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
				new IllegalOperationError("applicationDomain was not set on AssetsFactoryFromApplicationDomain");
				return null;
			}
		}
		
		public function dispose():void
		{
			m_applicationDomain = null;
		}
	}
}