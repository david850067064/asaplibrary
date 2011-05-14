package demo.DelayButton.ui {
	import fl.transitions.easing.*;

	import org.asaplibrary.ui.buttons.*;
	import org.asaplibrary.util.actionqueue.*;

	import flash.display.MovieClip;

	public class MyButton extends MovieClip {
		private var mBehavior : DelayButtonBehavior;
		public var tHitarea : MovieClip;
		public var tPulseRing : MovieClip;
		private static const CURRENT : Number = Number.NaN;
		private static const MAX_SCALE : Number = 2;
		private static const IN_ANIMATION_DURATION : Number = 1.1;
		private var mPulseQueue : ActionQueue;
		private var mScaleQueue : ActionQueue;

		public function MyButton() {
			mBehavior = new DelayButtonBehavior(this);
			mBehavior.addEventListener(ButtonBehaviorEvent._EVENT, update);

			// don't handle mouse events on children
			mouseChildren = false;
			// behave as button
			buttonMode = true;
			// set the hitarea and hide it
			hitArea = tHitarea;
			tHitarea.visible = false;

			// let the thick ring pulsates forever
			mPulseQueue = new ActionQueue();
			mPulseQueue.addAction(new AQPulse().scale(tPulseRing, 0, .4, 1.1, .9, 1, 0));
			mPulseQueue.run();
		}

		public function set indelay(inValue : Number) : void {
			mBehavior.indelay = inValue;
		}

		public function set outdelay(inValue : Number) : void {
			mBehavior.outdelay = inValue;
		}

		public function set afterdelay(inValue : Number) : void {
			mBehavior.afterdelay = inValue;
		}

		private function update(e : ButtonBehaviorEvent) : void {
			if (e.state == ButtonStates.ADDED) init();
			if (e.state == ButtonStates.OVER) grow();
			if (e.state == ButtonStates.OUT) shrink();
		}

		private function init() : void {
			// not used
		}

		private function grow() : void {
			mScaleQueue = new ActionQueue();
			mScaleQueue.addAction(new AQScale().scale(this, IN_ANIMATION_DURATION, CURRENT, CURRENT, MAX_SCALE, MAX_SCALE, Strong.easeOut));
			mScaleQueue.run();
		}

		private function shrink() : void {
			mScaleQueue = new ActionQueue();
			mScaleQueue.addAction(new AQScale().scale(this, IN_ANIMATION_DURATION, CURRENT, CURRENT, 1, 1, Strong.easeOut));
			mScaleQueue.run();
		}
	}
}