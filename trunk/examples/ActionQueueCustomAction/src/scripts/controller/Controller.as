package controller {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.asaplibrary.util.NumberUtils;
	import org.asaplibrary.util.actionqueue.*;
	
	import fl.transitions.easing.*;
	import fl.motion.easing.*;	
	import fl.motion.BezierEase;

	public class Controller extends MovieClip {	
	
		public var tClip:MovieClip;
		private var mClipData:ClipData;
		private var initX:Number;
		private var initY:Number;
		
		function Controller () {
			super();
			tClip.addEventListener(MouseEvent.MOUSE_DOWN, start);
			initX = tClip.x;
			initY = tClip.y;
		}
		
		protected function start (e:MouseEvent) : void {
		
			// store clip data
			mClipData = new ClipData();
			mClipData.endx = Math.random() * stage.stageWidth * .9;
			mClipData.endy = Math.random() * stage.stageHeight * .9;
			mClipData.endscale = 1.8;
			
			// animation parameters
			var duration:Number = 2; // seconds
			var effect:Function = Elastic.easeOut;
			
			var queue:ActionQueue = new ActionQueue("Move and Scale");
			var action:TimedAction = new TimedAction(doMoveAndScale, duration, effect);
			queue.addAction(action);
			queue.addPause(.35);
			// reset position
			queue.addAction(resetClip);
			queue.run();
		}
		
		protected function doMoveAndScale (inValue:Number) : Boolean {
			
			var percentage:Number = 1-inValue; // end of animation: inValue == 0
			
			tClip.x = NumberUtils.percentageValue(initX, mClipData.endx, percentage);
			tClip.y = NumberUtils.percentageValue(initY, mClipData.endy, percentage);
			tClip.scaleX = tClip.scaleY = NumberUtils.percentageValue(1, mClipData.endscale, percentage);
			
			return true; // if false the action will stop
			
		}
		
		public function resetClip () : void {
			tClip.scaleX = tClip.scaleY = 1;
			var queue:ActionQueue = new ActionQueue("Move and Scale");
			queue.addAction(new AQMove().move(tClip, .5, NaN, NaN, 215, 200, Elastic.easeOut));
			queue.run();
		}

	}
}

class ClipData {
	
	public var endx:Number;
	public var endy:Number;
	public var endscale:Number;
	
}