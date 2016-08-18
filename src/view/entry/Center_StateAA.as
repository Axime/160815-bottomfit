package view.entry
{
	import flash.geom.Rectangle;
	
	import d2.axime.Axime;
	import d2.axime.animate.TweenMachine;
	import d2.axime.display.FusionAA;
	import d2.axime.display.ImageAA;
	import d2.axime.display.Scale9ImageAA;
	import d2.axime.display.StateAA;
	import d2.axime.display.StateFusionAA;
	import d2.axime.display.core.NodeAA;
	import d2.axime.display.ui.ProgressBarAA;
	import d2.axime.events.AEvent;
	import d2.axime.events.NTouchEvent;
	import d2.axime.gesture.GestureFacade;
	import d2.axime.gesture.SwipeGestureRecognizer;
	import d2.axime.utils.AMath;
	
	import view.ViewConfig;
	import view.comp.Check_CompAA;
	import view.comp.DragFusion;
	
public class Center_StateAA extends StateAA
{
	
	public function Center_StateAA(entryState:Entry_StateAA){
		_entryState = entryState;
	}
	
	public static const MIDDLE_Y1:int = 346;
	public static const MIDDLE_Y2:int = 451;
	public static const BOTTOM_Y1:int = 742;
	public static const BOTTOM_Y2:int = 963;
	
//	public var max_drag:Number;
//	public var min_drag:Number;
	
	
	
	public function switchStyle() : void {
		
		_isRectIcon = !_isRectIcon;
		
		if(_isRectIcon){
			_topState1.setTex("btn1/r_flashlight.png", "btn1/r_flashlight1.png");
			_topState2.setTex("btn1/r_calc.png", "btn1/r_calc1.png");
			_topState3.setTex("btn1/r_scan.png", "btn1/r_scan1.png");
			_topState4.setTex("btn1/r_screenshot.png", "btn1/r_screenshot1.png");
		}
		else {
			_topState1.setTex("btn1/flashlight.png", "btn1/flashlight1.png");
			_topState2.setTex("btn1/calc.png", "btn1/calc1.png");
			_topState3.setTex("btn1/scan.png", "btn1/scan1.png");
			_topState4.setTex("btn1/screenshot.png", "btn1/screenshot1.png");
		}
		
	}

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
		_topState1 = checkFN.getState() as Check_CompAA;
		
		checkFN = doCreateBtn("btn1/calc.png", "btn1/calc1.png", "text/calc.png");
		checkFN.x = 175 + (Axime.getWindow().rootWidth - 350) / 3;
		checkFN.y = 115;
		_topState2 = checkFN.getState() as Check_CompAA;
		
		checkFN = doCreateBtn("btn1/scan.png", "btn1/scan1.png", "text/scan.png");
		checkFN.x = 175 + (Axime.getWindow().rootWidth - 350) / 3 * 2;
		checkFN.y = 115;
		_topState3 = checkFN.getState() as Check_CompAA;
		
		checkFN = doCreateBtn("btn1/screenshot.png", "btn1/screenshot1.png", "text/screenshot.png");
		checkFN.x = 175 + (Axime.getWindow().rootWidth - 350);
		checkFN.y = 115;
		_topState4 = checkFN.getState() as Check_CompAA;
		
		
		
		// slider
		img = new ImageAA;
		img.textureId = "common/slider/sun.png";
		this.getFusion().addNode(img);
		img.x = 85;
		img.y = MIDDLE_Y1 - img.sourceHeight / 2;
		
		
		// progress bar
		_pb_A = new ProgressBarAA();
		_pb_A.setData(new <String>[
			"common/slider/strip.png",
			"common/slider/strip1.png"],1);
		_pb_A.setBarStartOffset( -704, 0);
//		pb_A.width = 600;
		//		pb_A.height = 300;
		_pb_A.clipRect = new Rectangle(1, 0, 704, 5);
		
		_pb_A.getRange().ratio = 0.6;
		this.getFusion().addNode(_pb_A);
		_pb_A.x = 160;
		_pb_A.y = MIDDLE_Y1 - 1;
		
		
//		TweenMachine.to(pb_A.getRange(), 3, {ratio:1.0});
		
		// slider dragbutton
		_dragFN = new DragFusion;
		this.getFusion().addNode(_dragFN);
		img = new ImageAA;
		img.textureId = "common/slider/bar.png";
		_dragFN.addNode(img);
		img.pivotX = img.sourceWidth/2;
		img.pivotY = img.sourceHeight /2;
		img.setCollisionMethod(function(x:Number,y:Number,node:NodeAA):Boolean{
			
//			trace(x,y);
			
			if(AMath.distance(0,0,x,y) < 95){
				return true;
			}
			return false;
		});
		
		_dragFN.x = 144 + 704 * 0.6;
		_dragFN.y = MIDDLE_Y1 - 1;
		
		_dragFN.addEventListener(NTouchEvent.PRESS, onStartDrag);
		
		
		
		// auto button
		checkFN = doCreateBtn("slider/auto.png", "slider/auto1.png", "slider/text.png", false, true, true);
		checkFN.x = Axime.getWindow().rootWidth - 212;
		checkFN.y = MIDDLE_Y1;
		
		
		
		// middle
		checkFN = doCreateBtn("btn2/projection.png", "btn2/projection1.png", null, false, false);
		checkFN.x = 491/2 + 48;
		checkFN.y = 67 + MIDDLE_Y2;
		
		
		
		
		checkFN = doCreateBtn("btn2/upload.png", "btn2/upload1.png", null, false, false);
		checkFN.x = 491 + 48 + 6 + 491/2;
		checkFN.y = 67 + MIDDLE_Y2;
		
		
		
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
	private var _dragFN:DragFusion;
	private var _pb_A:ProgressBarAA;
	
	private var _isRectIcon:Boolean;
	private var _topState1:Check_CompAA;
	private var _topState2:Check_CompAA;
	private var _topState3:Check_CompAA;
	private var _topState4:Check_CompAA;
	
	
	
	private function doCreateBtn(texA:String, texB:String, texText:String = null, isSelected:Boolean = false, customTouch:Boolean = true, isTextHoriz:Boolean=false):StateFusionAA {
		var stateFN:StateFusionAA;
		
		stateFN = new StateFusionAA;
		this.getFusion().addNode(stateFN);
		stateFN.setState(new Check_CompAA(texA, texB, texText, isSelected, customTouch, isTextHoriz));
		return stateFN;
	}
	
	
	private function doCreateHotspot() : ImageAA {
		var img_A:ImageAA;
		
		img_A = new ImageAA
		img_A.textureId = "common/img/frame.png";
		_hotspotFN.addNode(img_A);
		
		img_A.scaleX = Axime.getWindow().rootWidth / img_A.sourceWidth;
		img_A.scaleY = ViewConfig.HOTSPOT_H2 / img_A.sourceHeight;
		
		img_A.y = -ViewConfig.HOTSPOT_H2 * 0.667;
		
		return img_A;
	}
	
	private function onTouchPress(e:NTouchEvent):void{
		_entryState.registerTouch(e.touch, "A");
	}
	
	private function onStartDrag(e:NTouchEvent):void{
		_dragFN.startDrag(e.touch, new Rectangle(144, MIDDLE_Y1 - 1, 704, 0));
		
		e.touch.addEventListener(AEvent.CHANGE, onDragChange);
		e.touch.addEventListener(AEvent.COMPLETE, onDragComplete);
	}
	
	private function onDragChange(e:AEvent):void{
		_pb_A.getRange().ratio = (_dragFN.x - 144) / 704;
	}
	
	private function onDragComplete(e:AEvent):void{
		_dragFN.stopDrag();
	}
}
}