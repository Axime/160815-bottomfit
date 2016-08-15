package view.entry {
	import d2.axime.Axime;
	import d2.axime.display.ImageAA;
	import d2.axime.display.StateAA;
	import d2.axime.display.StateFusionAA;
	import d2.axime.display.core.NodeAA;
	import d2.axime.enum.ETouchMode;
	import d2.axime.events.AEvent;
	import d2.axime.events.NTouchEvent;
	import d2.axime.gesture.GestureFacade;
	import d2.axime.gesture.SwipeGestureRecognizer;
	
public class Entry_StateAA extends StateAA {
	
	private var coordY:Number;
	
	override public function onEnter() : void {
		var i:int;
		var l:int;
		var AY:Array;
		var img_A:ImageAA;
		var img_B:ImageAA;
		var img_split:ImageAA;
		var stateFN_A:StateFusionAA;
		var swipeGesture_A:SwipeGestureRecognizer;
		
		img_A = doCreateHotspot("A");
		img_B = doCreateHotspot("B");
		img_B.x = Axime.getWindow().rootWidth * 2/3;
		
		img_split = doCreateHotspot("split");
		img_split.x = Axime.getWindow().rootWidth /3;
	}
	
	override public function onExit() : void {
		
	}
	
	
	private static const HOTSPOT_H:int = 35;
	
	
	
	private function doCreateHotspot(tag:String) : ImageAA {
		var img_A:ImageAA;
		var sg_A:SwipeGestureRecognizer;
		
		img_A = new ImageAA
		img_A.textureId = "common/img/frame.png";
		this.getFusion().addNode(img_A);
		img_A.userData = tag;
		
		img_A.scaleX = (Axime.getWindow().rootWidth / 3) / img_A.sourceWidth;
		img_A.scaleY = HOTSPOT_H / img_A.sourceHeight;
		
		img_A.y = Axime.getWindow().rootHeight - HOTSPOT_H;
		
		sg_A = GestureFacade.recognize(img_A, SwipeGestureRecognizer) as SwipeGestureRecognizer;
		sg_A.addEventListener(AEvent.COMPLETE, onSwipe);
		
		img_A.addEventListener(NTouchEvent.CLICK, function(e:NTouchEvent):void{
			Axime.getLog().simplify("click： {0}", tag);
		}, 0);
		
		return img_A;
	}
	
	private function doAddGesture() : void {
		
	}
	
	private function onSwipe(e:AEvent):void{
		var sg_A:SwipeGestureRecognizer;
		var tag:String;
		
		sg_A = e.target as SwipeGestureRecognizer;
		tag = sg_A.getNode().userData as String;
		
		Axime.getLog().simplify("swipe: {0}", tag);
		
	}
	
}
}