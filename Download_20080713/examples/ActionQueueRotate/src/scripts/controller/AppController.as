package controller {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.transitions.easing.*;
	import fl.controls.TextInput;
	import fl.controls.RadioButton;
	
	import org.asaplibrary.util.actionqueue.*;
	import org.asaplibrary.util.NumberUtils;
	import org.asaplibrary.ui.buttons.BaseButton;
	
	public class AppController extends MovieClip {
		
		public var tCircle:BaseButton;
		public var tNeedle:MovieClip;
		public var tRotationInput:TextInput;
		public var tRadioCCW:RadioButton;
		public var tRadioCW:RadioButton;
		public var tRadioNEAR:RadioButton;
		
		private var mRotateQueue:ActionQueue;
		
		function AppController () {
			tRotationInput.addEventListener("enter", handleRotationInput);
			tCircle.addEventListener("click", handleDialClick);
			tRadioNEAR.selected = true;
		}
		
		private function handleRotationInput (e:Event) : void {
			var angle:Number = Number(tRotationInput.text);
			rotate(angle);
		}
		
		private function handleDialClick (e:Event) : void {
			var angle:Number = NumberUtils.angle(mouseX - tNeedle.x, mouseY - tNeedle.y);
			rotate(angle);
		}
		
		private function rotate (inAngle:Number) : void {
			if (mRotateQueue) mRotateQueue.quit(); // in case the button is pressed while the old queue is still running
			mRotateQueue = new ActionQueue();
			var duration:Number = 0.5;
			var direction:uint = 0;
			if (tRadioCCW.selected) direction = AQRotate.CCW;
			if (tRadioCW.selected) direction = AQRotate.CW;
			if (tRadioNEAR.selected) direction = AQRotate.NEAR;
			var effect:Function = Regular.easeInOut;
			mRotateQueue.addAction( new AQRotate().rotate(tNeedle, duration, NaN, inAngle, direction, effect));
			mRotateQueue.run();
		}
	}

}
