package
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Vladimir Minkin
	 */
	public class Main extends Sprite 
	{
		public function Main() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// entry point
			SetupStage();
			SetupStarling();
			// new to AIR? please read *carefully* the readme.txt files!
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		
		//==================================================================================================
		private function SetupStage():void {
		//==================================================================================================
			Multitouch.inputMode 	= MultitouchInputMode.TOUCH_POINT;
			stage.align 			= StageAlign.TOP_LEFT;
			stage.scaleMode 		= StageScaleMode.NO_SCALE;
			stage.autoOrients 		= false;
			stage.color				= 0xf5f5f5;
			stage.displayState		= StageDisplayState.FULL_SCREEN;
			stage.setAspectRatio('landscape');
			stage.quality			= StageQuality.BEST;
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
			NativeApplication.nativeApplication.autoExit = true;
		}
		
		//==================================================================================================
		private function SetupStarling():void {
		//==================================================================================================
			Starling.multitouchEnabled = true;
			var viewport:Rectangle = stage.fullScreenSourceRect;
			var starling:Starling = new Starling(Application, stage, viewport);
			starling.start();
		}
		
	}
	
}
