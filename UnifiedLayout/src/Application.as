package 
{
	import com.xtdstudios.DMT.DMTBasic;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import starling.core.Starling;
	import starling.display.Sprite;
	import ui.Layout;
	
	/**
	 * ...
	 * @author Vladimir Minkin
	 */
	public final class Application extends Sprite 
	{
		private var _dmtBasic:DMTBasic;
		private var starlingUIContainer : Sprite;
		
		public function Application() 
		{
			super();
			
			_dmtBasic = new DMTBasic("UIContainer", true);
			_dmtBasic.addEventListener(Event.COMPLETE, HandleComplete);
			if (_dmtBasic.cacheExist() == true){
				_dmtBasic.process(); // will use the existing cache
			}
			else doLayoutUI(); // will be done one time per device  
		}
		
		private function doLayoutUI():void {
			var ns:Stage = Starling.current.nativeStage;
			var sw:uint = ns.stageWidth;
			var sh:uint = ns.stageHeight;
			var layout:Layout = new Layout(sw, sh);
			_dmtBasic.addItemToRaster(layout.layoutTypesScreen, Layout.TYPE_SCREEN);
			_dmtBasic.process(); // will rasterize the given assets  
		}
		
		//==================================================================================================
		private function HandleComplete(e:Event):void {
		//==================================================================================================
			_dmtBasic.removeEventListener(Event.COMPLETE, HandleComplete);
			starlingUIContainer = _dmtBasic.getAssetByUniqueAlias(Layout.TYPE_SCREEN) as Sprite;
			
			addChild(starlingUIContainer);
		}
	}
}
