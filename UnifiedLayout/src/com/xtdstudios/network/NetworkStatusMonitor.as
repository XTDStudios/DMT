package com.xtdstudios.network
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	
	import air.net.URLMonitor;

	public class NetworkStatusMonitor extends EventDispatcher
	{
		public static const STATUS_UNKNOWN				: int = 0;
		public static const STATUS_NETWORK_AVAILABLE	: int = 1;
		public static const STATUS_NETWORK_UNAVAILABLE	: int = 2;
		
		private var m_monitor	: URLMonitor;
		private var m_status	: int;
		
		public function NetworkStatusMonitor(urlToMonitor:String)
		{
			m_status = STATUS_UNKNOWN;
			m_monitor = new URLMonitor(new URLRequest(urlToMonitor));
			m_monitor.addEventListener(StatusEvent.STATUS, netConnectivity);
			NativeApplication.nativeApplication.addEventListener(Event.NETWORK_CHANGE, onNetworkChange);
			super();
		}
		
		public function get status():int
		{
			return m_status;
		}

		public function set status(value:int):void
		{
			if (value!=m_status) {
				m_status = value;
				dispatchEvent(new NetworkStatusChangedEvent(NetworkStatusChangedEvent.STATUS_CHANGED, m_status));
			}
		}

		protected function onNetworkChange(e:Event):void
		{
			testConnectionNow();
		}
		
		public function testConnectionNow():void {
			m_monitor.stop();
			m_monitor.start();
		}
		
		protected function netConnectivity(e:StatusEvent):void 
		{
			if (m_monitor.available)
				status = STATUS_NETWORK_AVAILABLE;
			else
				status = STATUS_NETWORK_UNAVAILABLE;
			
			m_monitor.stop();
		}
		
		public function dispose():void {
			m_monitor.stop();
			m_monitor.removeEventListener(StatusEvent.STATUS, netConnectivity);
			m_monitor = null;
			NativeApplication.nativeApplication.removeEventListener(Event.NETWORK_CHANGE, onNetworkChange);
		}
	}
}