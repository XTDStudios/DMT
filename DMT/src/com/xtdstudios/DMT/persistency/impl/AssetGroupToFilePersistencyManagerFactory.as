package com.xtdstudios.DMT.persistency.impl
{
	import com.xtdstudios.DMT.persistency.IAssetsGroupPersistencyManager;
	import com.xtdstudios.common.FileUtils;

	import flash.filesystem.File;

	public class AssetGroupToFilePersistencyManagerFactory
	{
		public static function generate(version:String, filePath:String=null):IAssetsGroupPersistencyManager
		{
			var baseDir:File;

			if (filePath)
				baseDir=new File(filePath);
			else
				baseDir=FileUtils.getCacheDir();

			return new AssetsGroupToFilePersistencyManager(version, baseDir);
		}
	}
}