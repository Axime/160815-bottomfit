package view.entry {
	import flash.ui.Keyboard;
	
	import d2.axime.Axime;
	import d2.axime.animate.ATween;
	import d2.axime.animate.TweenMachine;
	import d2.axime.animate.easing.Back;
	import d2.axime.animate.easing.Bounce;
	import d2.axime.animate.easing.Circ;
	import d2.axime.animate.easing.Cubic;
	import d2.axime.animate.easing.Elastic;
	import d2.axime.animate.easing.Linear;
	import d2.axime.animate.easing.Quad;
	import d2.axime.animate.easing.Strong;
	import d2.axime.display.FusionAA;
	import d2.axime.display.ImageAA;
	import d2.axime.display.StateAA;
	import d2.axime.display.StateFusionAA;
	import d2.axime.enum.EDirection;
	import d2.axime.enum.ETouchMode;
	import d2.axime.events.AEvent;
	import d2.axime.events.AKeyboardEvent;
	import d2.axime.gesture.GestureFacade;
	import d2.axime.gesture.SwipeGestureRecognizer;
	import d2.axime.window.Touch;
	
	import view.ViewConfig;
	
	// touch -> value(tween) -> ...
	
public class Entry_StateAA extends StateAA {
	
	public function get value() : Number {
		return _value;
	}
	
	public function set value(v:Number):void{
		_value = v;
		
		if(v <= MAX_MASK_VALUE_LIMIT){
			_mask.alpha = (v / MAX_MASK_VALUE_LIMIT) * MAX_MASK_ALPHA;
		}
		
		if(v > MAX_VIEW_VALUE_LIMIT){
			//trace(v);
			_currStateFN.y = Axime.getWindow().rootHeight * ((1-MAX_VIEW_VALUE_LIMIT) - (v-MAX_VIEW_VALUE_LIMIT)*0.55);
		}
		else {
			_currStateFN.y = Axime.getWindow().rootHeight * (1-v);
		}
		
	}
	
	public function registerTouch(touch:Touch):void{
		_showBottomFixed = false;
		
		_currTouch = touch;
		_currTouch.addEventListener(AEvent.CHANGE, onTouchChanged);
		_currTouch.addEventListener(AEvent.COMPLETE, onTouchComplete);
	}
	
	override public function onEnter() : void {
		Axime.getWindow().getTouch().touchMode = ETouchMode.SINGLE;
		Axime.getWindow().getTouch().velocityEnabled = true;
		
		this.doMakeBg();
		this.doMakeMask();
		this.doMakeHotspot();
		
		Axime.getWindow().getKeyboard().getKey(Keyboard.BACK).addEventListener(AEvent.COMPLETE, ____onKey_Back);
	}
	
	override public function onExit() : void {
		
	}
	
	
	
	private static const MAX_MASK_VALUE_LIMIT:Number = 0.55;
	private static const MAX_MASK_ALPHA:Number = 0.55;
	private static const MAX_VIEW_VALUE_LIMIT:Number = 0.75;
	
	
	private var _bg:ImageAA;
	private var _mask:ImageAA;
	private var _hotspotFN:FusionAA;
	private var _centerFN:StateFusionAA;
	private var _centerState:Center_StateAA;
	private var _splitFN:StateFusionAA;
	private var _splitState:Split_StateAA;
	private var _currStateFN:StateFusionAA;
	private var _value:Number = 0.0; // 0.0 ~ 1.0
	
	private var _currTouch:Touch;
	private var _showBottomFixed:Boolean;
	
	
	private function doMakeBg() : void {
		_bg = new ImageAA;
		_bg.textureId = "common/img/bg.png";
		this.getFusion().addNode(_bg);
	}
	
	private function doMakeMask() : void {
		_mask = new ImageAA;
		_mask.textureId = "common/img/mask.png";
		this.getFusion().addNode(_mask);
		
		_mask.scaleX = Axime.getWindow().rootWidth / _mask.sourceWidth;
		_mask.scaleY = Axime.getWindow().rootHeight / _mask.sourceHeight;
		
		_mask.alpha = 0.0;
	}
	
	private function doMakeHotspot() : void {
		var i:int;
		var l:int;
		var AY:Array;
		var img_A:ImageAA;
		var img_B:ImageAA;
		var img_split:ImageAA;
		var stateFN_A:StateFusionAA;
		var swipeGesture_A:SwipeGestureRecognizer;
		
		_hotspotFN = new FusionAA;
		this.getFusion().addNode(_hotspotFN);
		_hotspotFN.visible = false;
		
		img_A = doCreateHotspot("A");
		img_B = doCreateHotspot("B");
		img_B.x = Axime.getWindow().rootWidth * 2/3;
		
		img_split = doCreateHotspot("split");
		img_split.x = Axime.getWindow().rootWidth /3;
	}
	
	private function doCreateHotspot(tag:String) : ImageAA {
		var img_A:ImageAA;
		var sg_A:SwipeGestureRecognizer;
		
		img_A = new ImageAA
		img_A.textureId = "common/img/frame.png";
		_hotspotFN.addNode(img_A);
		img_A.userData = tag;
		
		img_A.scaleX = (Axime.getWindow().rootWidth / 3) / img_A.sourceWidth;
		img_A.scaleY = ViewConfig.HOTSPOT_H / img_A.sourceHeight;
		
		img_A.y = Axime.getWindow().rootHeight - ViewConfig.HOTSPOT_H;
		
		// 该手势仅负责将界面拖出来
		sg_A = GestureFacade.recognize(img_A, SwipeGestureRecognizer) as SwipeGestureRecognizer;
		sg_A.addEventListener(AEvent.COMPLETE, onSwipe);
		
		
//		img_A.addEventListener(NTouchEvent.CLICK, function(e:NTouchEvent):void{
//			Axime.getLog().simplify("click： {0}", tag);
//		}, 0);
		
		return img_A;
	}
	
	private function onSwipe(e:AEvent):void{
		var sg_A:SwipeGestureRecognizer;
		var tag:String;
		
		sg_A = e.target as SwipeGestureRecognizer;
		tag = sg_A.getNode().userData as String;
		
		if(sg_A.getDirection() == EDirection.UP){
			Axime.getLog().simplify("swipe: {0}", tag);
			
			// 应用中心
			if(tag == "A" || tag == "B") {
				if(!_centerFN){
					_centerFN = new StateFusionAA;
					_centerFN.setState(new Center_StateAA(this));
					_centerState = _centerFN.getState() as Center_StateAA;
					this.getFusion().addNode(_centerFN);
					
					_centerFN.y = Axime.getWindow().rootHeight;
					
				}
				else {
					_centerFN.visible = _centerFN.touchable = true;
				}
				_currStateFN = _centerFN;
			}
				// 分屏
			else if(tag == "split"){
				if(!_splitFN){
					_splitFN = new StateFusionAA;
					_splitFN.setState(new Split_StateAA(this));
					_splitState = _splitFN.getState() as Split_StateAA;
					this.getFusion().addNode(_splitFN);
					
					_splitFN.y = Axime.getWindow().rootHeight;
					
				}
				else {
					_splitFN.visible = _splitFN.touchable = true;
				}
				_currStateFN = _splitFN;
			}
			
			
			this.registerTouch(sg_A.getTouchList()[0]);
		}
		
		
	}
	
	private function onTouchChanged(e:AEvent):void{
//		Axime.getLog().simplify("touch: {0} | {1}", _currTouch.rootX, _currTouch.rootY);
		
		this.doUpdateTouch(_currTouch);
	}
	
	private function onTouchComplete(e:AEvent):void{
		var tween:ATween;
		
//		trace(_currTouch.velocityY);
		
		Axime.getWindow().getTouch().touchEnabled = false;
		
		// 向下
		if(_currTouch.velocityY > 0){
			this.doHideBottom();
		}
		
		else {
			if(_value > MAX_VIEW_VALUE_LIMIT) {
				tween = TweenMachine.to(this, 0.16 + (_value - MAX_VIEW_VALUE_LIMIT) * 0.55, {value:MAX_VIEW_VALUE_LIMIT});
				tween.easing = Bounce.easeOut;
			}
			else{
				tween = TweenMachine.to(this, 0.16 + (MAX_VIEW_VALUE_LIMIT - _value) * 0.48, {value:MAX_VIEW_VALUE_LIMIT});
				tween.easing = Back.easeOut;
			}
			tween.onComplete = function() :void{
				Axime.getWindow().getTouch().touchEnabled = true;
				
				
				_showBottomFixed = true;
			}
		}
		
		_currTouch = null;
		
	}
	
	private function doUpdateTouch(touch:Touch) : void {
		var ratio:Number = (Axime.getWindow().rootHeight - touch.rootY) / Axime.getWindow().rootHeight;
		
		//		Axime.getLog().simplify("ratio: {0}", ratio); 
		
		TweenMachine.to(this, 0.10, {value:ratio});
		
	}
	
	private function doHideBottom() : void{
		var tween:ATween;
		
		tween = TweenMachine.to(this, (_value + 1) * 0.15, {value:0});
		//			tween.easing = Strong.easeOut;
		tween.easing = Linear.easeOut;
		
		tween.onComplete = function() :void{
			Axime.getWindow().getTouch().touchEnabled = true;
			_currStateFN.touchable = _currStateFN.visible = false;
		}

	}
	
	private function ____onKey_Back(e:AEvent):void{
		if(!_showBottomFixed){
			return;
		}
		
		_showBottomFixed = false;
		this.doHideBottom();
	}
}
}