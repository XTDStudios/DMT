package com.xtdstudios.network
{
	import flash.events.Event;
	
	public class NetworkStatusChangedEvent extends Event
	{
		public static const STATUS_CHANGED : String = "STATUS_CHANGED";
		
		private var m_networkStatus : int;
		
		public function NetworkStatusChangedEvent(type:String, networkStatus:int)
		{
			super(type);
			m_networkStatus = networkStatus;
		}

		public function get networkStatus():int
		{
			return m_networkStatus;
		}

	}
}