package
{
    import com.xtdstudios.dmt.demo.ExamplesManager;
    
    import flash.desktop.NativeApplication;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    import starling.core.Starling;
    
    [SWF(width="480", height="800", frameRate="60", backgroundColor="#dddddd")]
    public class Startup extends Sprite
    {
        private var m_Starling	: Starling;
		
        public function Startup()
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            
            Starling.multitouchEnabled = true;
            Starling.handleLostContext = false;
            
            // create a suitable viewport for the screen size
            var viewPort:Rectangle = new Rectangle();
            
            viewPort.width = stage.fullScreenWidth; 
            viewPort.height = stage.fullScreenHeight/2;
            viewPort.y = int((stage.fullScreenHeight/2 - viewPort.height) / 2)+(stage.fullScreenHeight/2);
			var starlingTitle : TextField = new TextField();
			starlingTitle.defaultTextFormat = new TextFormat(null, 16, 0x000000, true, null, true);
			starlingTitle.text = "Starling:";
			starlingTitle.y = viewPort.y;
			stage.addChild(starlingTitle);
            
			var flashTitle : TextField = new TextField();
			flashTitle.defaultTextFormat = new TextFormat(null, 16, 0x000000, true, null, true);
			flashTitle.y = 20;
			flashTitle.text = "Flash:";
			stage.addChild(flashTitle);
            
			var exampleTitle : TextField = new TextField();
			exampleTitle.defaultTextFormat = new TextFormat(null, 16, 0x000000, false, null, false, null, null, "center");
			exampleTitle.width = stage.stageWidth;
			exampleTitle.name = "exampleTitle";
			stage.addChild(exampleTitle);
            
            // initialize Starling
            m_Starling = new Starling(ExamplesManager, stage, viewPort);
            m_Starling.simulateMultitouch  = false;
            m_Starling.enableErrorChecking = false;
            m_Starling.start();
            
            // When the game becomes inactive, we pause Starling; otherwise, the enter frame event
            // would report a very long 'passedTime' when the app is reactivated. 
            
            NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, 
                function (e:Event):void { m_Starling.start(); });
            
            NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, 
                function (e:Event):void { m_Starling.stop(); });
        }
	}
}