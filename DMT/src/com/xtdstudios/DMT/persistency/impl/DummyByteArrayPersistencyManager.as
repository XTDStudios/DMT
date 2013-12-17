package com.xtdstudios.DMT.persistency.impl
{
	import com.xtdstudios.DMT.persistency.ByteArrayPersistencyManager;
	
	import flash.utils.ByteArray;
	
	public class DummyByteArrayPersistencyManager implements ByteArrayPersistencyManager
	{
		public function DummyByteArrayPersistencyManager()
		{
		}
		
		public function saveByteArray(fileName:String, data:ByteArray):void
		{
		}
		
		public function loadByteArray(fileName:String):ByteArray
		{
			return null;
		}
		
		public function saveData(fileName:String, data:Object):void
		{
		}
		
		public function loadData(fileName:String):Object
		{
			return null;
		}
		
		public function isExist(groupName:String):Boolean
		{
			return false;
		}
		
		public function deleteData(groupName:String):void
		{
		}
		
		public function list():Array
		{
			return null;
		}
		
		public function dispose():void
		{
		}
	}
}