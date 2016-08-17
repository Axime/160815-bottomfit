package view.entry
{
	import d2.axime.Axime;
	import d2.axime.display.FusionAA;
	import d2.axime.display.ImageAA;
	import d2.axime.display.Scale9ImageAA;
	import d2.axime.display.StateAA;
	import d2.axime.display.StateFusionAA;
	import d2.axime.events.AEvent;
	import d2.axime.events.NTouchEvent;
	import d2.axime.gesture.GestureFacade;
	import d2.axime.gesture.SwipeGestureRecognizer;
	
	import view.ViewConfig;
	import view.comp.Check_CompAA;
	
public class Center_StateAA extends StateAA
{
	
	public function Center_StateAA(entryState:Entry_StateAA){
		_entryState = entryState;
	}
	
	public static const MIDDLE_Y1:int = 451;
	public static const BOTTOM_Y1:int = 742;
	public static const BOTTOM_Y2:int = 963;

	override public function onEnter():void {
		var checkFN:StateFusionAA;
		var img:ImageAA;
		
		// bg
		img = new ImageAA;
		img.textureId = "common/img/bgA.png";
		this.getFusion().addNode(img);
		
		img = new ImageAA;
		img.textureId = "common/img/navi.png";
		this.getFusion().addNode(img);
		img.x = (Axime.getWindow().rootWidth - img.sourceWidth)/2;
		img.y = 12;
		
//		_s9img.width = Axime.getWindow().rootWidth;
//		_s9img.height = Axime.getWindow().rootHeight;
		
		
		// hotspot
		_hotspotFN = new FusionAA;
		this.getFusion().addNode(_hotspotFN);
		_hotspotFN.visible = false;
		
		this.doCreateHotspot();
		_hotspotFN.addEventListener(NTouchEvent.PRESS, onTouchPress);
		
		
		
		// top
		checkFN = doCreateBtn("btn1/flashlight.png", "btn1/flashlight1.png", "text/flashlight.png", true);
		checkFN.x = 175;
		checkFN.y = 115;
		
		checkFN = doCreateBtn("btn1/calc.png", "btn1/calc1.png", "text/calc.png");
		checkFN.x = 175 + (Axime.getWindow().rootWidth - 350) / 3;
		checkFN.y = 115;
		
		checkFN = doCreateBtn("btn1/scan.png", "btn1/scan1.png", "text/scan.png");
		checkFN.x = 175 + (Axime.getWindow().rootWidth - 350) / 3 * 2;
		checkFN.y = 115;
		
		checkFN = doCreateBtn("btn1/screenshot.png", "btn1/screenshot1.png", "text/screenshot.png");
		checkFN.x = 175 + (Axime.getWindow().rootWidth - 350);
		checkFN.y = 115;
		
		
		
		// slider
		
		
		
		
		// middle
		checkFN = doCreateBtn("btn2/projection.png", "btn2/projection1.png", null, false, false);
		checkFN.x = 240 + 48;
		checkFN.y = 67 + MIDDLE_Y1;
		
		checkFN = doCreateBtn("btn2/upload.png", "btn2/upload1.png", null, false, false);
		checkFN.x = 240 + 48 + 480 + 24;
		checkFN.y = 67 + MIDDLE_Y1;
		
		
		
		// bottom1
		checkFN = doCreateBtn("btn/WLAN.png", "btn/WLAN1.png", "text/WLAN.png", true);
		checkFN.x = 175;
		checkFN.y = BOTTOM_Y1;
		
		checkFN = doCreateBtn("btn/bluetooth.png", "btn/bluetooth1.png", "text/bluetooth.png");
		checkFN.x = 175 + (Axime.getWindow().rootWidth - 350) / 3;
		checkFN.y = BOTTOM_Y1;
		
		checkFN = doCreateBtn("btn/mobiledata.png", "btn/mobiledata1.png", "text/mobiledata.png", true);
		checkFN.x = 175 + (Axime.getWindow().rootWidth - 350) / 3 * 2;
		checkFN.y = BOTTOM_Y1;
		
		checkFN = doCreateBtn("btn/flymode.png", "btn/flymode1.png", "text/flymode.png");
		checkFN.x = 175 + (Axime.getWindow().rootWidth - 350);
		checkFN.y = BOTTOM_Y1;
		
		// bottom2
		checkFN = doCreateBtn("btn/rotate.png", "btn/rotate1.png", "text/rotate.png", true);
		checkFN.x = 175;
		checkFN.y = BOTTOM_Y2;
		
		checkFN = doCreateBtn("btn/shock.png", "btn/shock1.png", "text/shock.png");
		checkFN.x = 175 + (Axime.getWindow().rootWidth - 350) / 3;
		checkFN.y = BOTTOM_Y2;
		
		checkFN = doCreateBtn("btn/mute.png", "btn/mute1.png", "text/mute.png");
		checkFN.x = 175 + (Axime.getWindow().rootWidth - 350) / 3 * 2;
		checkFN.y = BOTTOM_Y2;
		
		checkFN = doCreateBtn("btn/custom.png", "btn/custom1.png", "text/custom.png");
		checkFN.x = 175 + (Axime.getWindow().rootWidth - 350);
		checkFN.y = BOTTOM_Y2;
		
		
	}
	
	override public function onExit():void {
		
	}
	
	
	
	private var _hotspotFN:FusionAA;
	private var _entryState:Entry_StateAA;
	
	
	
	
	
	private function doCreateBtn(texA:String, texB:String, texText:String = null, isSelected:Boolean = false, customTouch:Boolean = true):StateFusionAA {
		var stateFN:StateFusionAA;
		
		stateFN = new StateFusionAA;
		this.getFusion().addNode(stateFN);
		stateFN.setState(new Check_CompAA(texA, texB, texText, isSelected, customTouch));
		return stateFN;
	}
	
	
	private function doCreateHotspot() : ImageAA {
		var img_A:ImageAA;
		
		img_A = new ImageAA
		img_A.textureId = "common/img/frame.png";
		_hotspotFN.addNode(img_A);
		
		img_A.scaleX = Axime.getWindow().rootWidth / img_A.sourceWidth;
		img_A.scaleY = ViewConfig.HOTSPOT_H2 / img_A.sourceHeight;
		
		img_A.y = -ViewConfig.HOTSPOT_H2 * 0.5;
		
		return img_A;
	}
	
	private function onTouchPress(e:NTouchEvent):void{
		_entryState.registerTouch(e.touch);
	}
	
}
}