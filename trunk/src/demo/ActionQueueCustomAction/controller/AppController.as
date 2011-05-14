package demo.ActionQueueCustomAction.controller {
	import fl.motion.easing.Elastic;

	import org.asaplibrary.util.NumberUtils;
	import org.asaplibrary.util.actionqueue.*;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class AppController extends MovieClip {
		public var tClip : MovieClip;
		private var mClipData : ClipData;
		private var mInitX : Number;
		private var mInitY : Number;
		private var mActionQueue : ActionQueue;

		function AppController() {
			super();
			tClip.addEventListener(MouseEvent.MOUSE_DOWN, start);
			mInitX = tClip.x;
			mInitY = tClip.y;
		}

		protected function start(e : MouseEvent) : void {
			// store clip data
			mClipData = new ClipData();
			mClipData.endx = Math.random() * stage.stageWidth * .9;
			mClipData.endy = Math.random() * stage.stageHeight * .9;
			mClipData.endscale = 1.8;

			// animation parameters
			var duration : Number = 2;
			// seconds
			var effect : Function = Elastic.easeOut;

			if (mActionQueue != null && mActionQueue.isRunning()) {
				mActionQueue.quit();
			}
			mActionQueue = new ActionQueue("Move and Scale");
			var action : TimedAction = new TimedAction(doMoveAndScale, duration, effect);
			mActionQueue.addAction(action);
			mActionQueue.addPause(.35);
			// reset position
			mActionQueue.addAction(resetClip);
			mActionQueue.run();
		}

		protected function doMoveAndScale(inValue : Number) : Boolean {
			var percentage : Number = 1 - inValue;
			// end of animation: inValue == 0

			tClip.x = NumberUtils.percentageValue(mInitX, mClipData.endx, percentage);
			tClip.y = NumberUtils.percentageValue(mInitY, mClipData.endy, percentage);
			tClip.scaleX = tClip.scaleY = NumberUtils.percentageValue(1, mClipData.endscale, percentage);

			return true;
			// if false the action will stop
		}

		public function resetClip() : void {
			tClip.scaleX = tClip.scaleY = 1;
			var queue : ActionQueue = new ActionQueue("Move and Scale");
			queue.addAction(new AQMove().move(tClip, .5, NaN, NaN, 215, 200, Elastic.easeOut));
			queue.run();
		}
	}
}
class ClipData {
	public var endx : Number;
	public var endy : Number;
	public var endscale : Number;
}