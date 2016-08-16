package view.entry
{
	import d2.axime.Axime;
	import d2.axime.display.FusionAA;
	import d2.axime.display.ImageAA;
	import d2.axime.display.Scale9ImageAA;
	import d2.axime.display.StateAA;
	import d2.axime.events.AEvent;
	import d2.axime.events.NTouchEvent;
	import d2.axime.gesture.GestureFacade;
	import d2.axime.gesture.SwipeGestureRecognizer;
	
	import view.ViewConfig;
	
public class Center_StateAA extends StateAA
{
	
	public function Center_StateAA(entryState:Entry_StateAA){
		_entryState = entryState;
	}
	
	public function getHeight() : Number {
		return _s9img.height;
	}
	

	override public function onEnter():void {
		
		_s9img = new Scale9ImageAA;
		_s9img.textureId = "common/img/scale9_A.png";
		this.getFusion().addNode(_s9img);
		
		_s9img.width = Axime.getWindow().rootWidth;
		_s9img.height = Axime.getWindow().rootHeight;
		
		_hotspotFN = new FusionAA;
		this.getFusion().addNode(_hotspotFN);
		_hotspotFN.visible = false;
		
		this.doCreateHotspot();
		_hotspotFN.addEventListener(NTouchEvent.PRESS, onTouchPress);
	}
	
	override public function onExit():void {
		
	}
	
	
	private var _s9img:Scale9ImageAA;
	private var _hotspotFN:FusionAA;
	private var _entryState:Entry_StateAA;
	
	
	
	private function doCreateHotspot() : ImageAA {
		var img_A:ImageAA;
		
		img_A = new ImageAA
		img_A.textureId = "common/img/frame.png";
		_hotspotFN.addNode(img_A);
		
		img_A.scaleX = Axime.getWindow().rootWidth / img_A.sourceWidth;
		img_A.scaleY = ViewConfig.HOTSPOT_H2 / img_A.sourceHeight;
		
		img_A.y = -ViewConfig.HOTSPOT_H2 * 0.35;
		
		return img_A;
	}
	
	private function onTouchPress(e:NTouchEvent):void{
		_entryState.registerTouch(e.touch);
	}
	
}
}