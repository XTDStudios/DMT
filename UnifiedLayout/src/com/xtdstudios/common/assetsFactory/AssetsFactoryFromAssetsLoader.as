package com.xtdstudios.common.assetsFactory
{
	import com.xtdstudios.common.assetsLoader.IAssetsLoader;
	
	import flash.errors.IllegalOperationError;
	
	public class AssetsFactoryFromAssetsLoader implements IAssetsFactory
	{
		private var m_assetsLoader			: IAssetsLoader;
		
		public function AssetsFactoryFromAssetsLoader(assetsLoader:IAssetsLoader)
		{
			m_assetsLoader = assetsLoader;
		}
		
		public function hasAsset(symbol:String):Boolean
		{
			if (m_assetsLoader)
			{
				return m_assetsLoader.hasAssetClass(symbol);
			}
			else
			{
				new IllegalOperationError("applicationDomain was not set on AssetsFactoryFromAssetsLoader");
				return null;
			}
		}
		
		public function getAssetClass(className:String):Class
		{
			if (m_assetsLoader)
			{
				var classDef : Class = m_assetsLoader.getAssetClass(className);
				return classDef;
			}
			else
			{
				new IllegalOperationError("applicationDomain was not set on AssetsFactoryFromAssetsLoader");
				return null;
			}
		}
		
		public function createAsset(symbol:String):Object
		{
			if (m_assetsLoader)
			{
				var definition : Object = m_assetsLoader.getAssetClass(symbol);
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
				new IllegalOperationError("assetsLoader was not set on AssetsFactoryFromAssetsLoader");
				return null;
			}
		}
		
		public function dispose():void
		{
			m_assetsLoader = null;
		}
	}
}