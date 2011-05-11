/*
Copyright 2007-2011 by the authors of asaplibrary, http://asaplibrary.org
Copyright 2005-2007 by the authors of asapframework, http://asapframework.org

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 */
package org.asaplibrary.ui.buttons {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;

	/**
	Delegate class to manage timing control over mouse over and mouse out events. This is useful for navigation menus where the menu items should "remember" its state for a brief moment even when the mouse has moved out of its click region. In interface design this effect is called hysteresis - see also <a href="http://www.mackido.com/Interface/hysteresis.html">time delay in hierarchical menus</a>.
	
	Another use is to prevent buttons to activate when the mouse moves very quickly over them. A activation delay will cause the button to activate only when the mouse stays for a little bit longer.

	3 timing properties that can be set:
	<ul>
	<li>{@link #indelay} : the number of seconds between the mouse having rolled over and the button activation</li>
	<li>{@link #outdelay} : the number of seconds between the mouse having moved out and the clip performing its mouse out activation</li>
	<li>{@link #afterdelay} : the number of seconds a button is momentarily inactive after mouse out</li>
	</ul>
	@example
	<code>
	import org.asaplibrary.ui.buttons.*;
	
	public class MyButton extends MovieClip {
		
	private var mDelegate:DelayButtonBehavior;
				
	public function MyButton () {		
	mDelegate = new DelayButtonBehavior(this);
	mDelegate.addEventListener(ButtonStateDelegateEvent.UPDATE, update);

	// set the timing:
	indelay = .1;
	outdelay = .5;
	}
		
	private function update (e:ButtonStateDelegateEvent) : void {
	if (e.state == ButtonStates.OVER) grow();
	if (e.state == ButtonStates.OUT) shrink();
	}
	}
	</code>
	 */
	public class DelayButtonBehavior extends ButtonBehavior {
		// Delay variables
		protected var mInDelay : Number = 0;
		/**< Delay before mouse over is performed, in seconds. */
		protected var mOutDelay : Number = 0;
		/**< (Hysteresis) delay before mouse out action is performed, in seconds. */
		protected var mAfterDelay : Number = 0;
		/**< Delay after mouse out until the button is activated (enabled) again, in seconds. */
		protected var mReEnabledTime : uint;
		/**< Set the time from where the button will be active again (in milliseconds); value is calculated. */
		protected var mInDelayTimer : Timer;
		protected var mOutDelayTimer : Timer;
		protected var mAfterDelayTimer : Timer;

		/**
		Creates a new DelayButtonBehavior.
		@param inButton: the owner button
		 */
		public function DelayButtonBehavior(inButton : MovieClip) {
			super(inButton);

			mInDelayTimer = new Timer(0);
			mInDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, processRollOver);

			mOutDelayTimer = new Timer(0);
			mOutDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, processRollOut);

			mAfterDelayTimer = new Timer(0);
			mAfterDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, processAfterDelay);
		}

		/**
		
		 */
		override public function toString() : String {
			return getQualifiedClassName(this);
		}

		/**
		Delay before mouse over is performed, in seconds.
		 */
		public function get indelay() : Number {
			return mInDelay;
		}

		public function set indelay(inValue : Number) : void {
			mInDelay = inValue;
		}

		/**
		(Hysteresis) delay before mouse out action is performed, in seconds.
		 */
		public function get outdelay() : Number {
			return mOutDelay;
		}

		public function set outdelay(inValue : Number) : void {
			mOutDelay = inValue;
		}

		/**
		Delay after mouse out until the button is activated (enabled) again, in seconds.
		 */
		public function get afterdelay() : Number {
			return mAfterDelay;
		}

		public function set afterdelay(inValue : Number) : void {
			mAfterDelay = inValue;
		}

		/**
		Called at MouseEvent.MOUSE_OVER.
		@param e: the mouse event
		 */
		override protected function mouseOverHandler(e : MouseEvent) : void {
			mOutDelayTimer.reset();

			if (!mEnabled) return;
			if (getTimer() < mReEnabledTime) return;

			mInDelayTimer.reset();
			if (mInDelay == 0) {
				mMouseOver = true;
				update(null, ButtonStates.OVER);
			} else {
				mInDelayTimer.delay = mInDelay * 1000;
				mInDelayTimer.repeatCount = 1;
				mInDelayTimer.start();
			}
		}

		/**
		Called at MouseEvent.MOUSE_OUT.
		@param e: the mouse event
		 */
		override protected function mouseOutHandler(e : MouseEvent) : void {
			resetTimers();

			if (!mEnabled) return;

			if (mOutDelay == 0) {
				mMouseOver = false;
				doAfterDelay();
				update(null, ButtonStates.OUT);
			} else {
				var tempTime : uint = getTimer() + mOutDelay * 1000;
				if (mReEnabledTime < tempTime) {
					mReEnabledTime = tempTime;
				}
				mOutDelayTimer.delay = mOutDelay * 1000;
				mOutDelayTimer.repeatCount = 1;
				mOutDelayTimer.start();
			}
		}

		/**
		Called by the roll over timer.
		@param e: the timer event
		 */
		protected function processRollOver(e : TimerEvent) : void {
			mMouseOver = true;
			if (mSelected || !mEnabled) return;
			update(null, ButtonStates.OVER);
		}

		/**
		Called by the roll out timer.
		@param e: the timer event
		 */
		protected function processRollOut(e : TimerEvent) : void {
			mMouseOver = false;
			doAfterDelay();
			sPressed = false;
			mMouseOver = false;
			if (mSelected || !mEnabled) return;
			update(null, ButtonStates.OUT);
		}

		/**
		If {@link #afterdelay} has been set, starts the timer.
		 */
		protected function doAfterDelay() : void {
			if (mAfterDelay > 0) {
				mEnabled = false;
				mReEnabledTime = getTimer() + mAfterDelay * 1000;

				mAfterDelayTimer.delay = mAfterDelay * 1000;
				mAfterDelayTimer.repeatCount = 1;
				mAfterDelayTimer.start();
			}
		}

		/**
		Called by the after delay out timer.
		@param e: the timer event
		 */
		protected function processAfterDelay(e : TimerEvent) : void {
			mAfterDelayTimer.reset();
			mEnabled = true;
		}

		/**
		Resets all timers.
		 */
		protected function resetTimers() : void {
			mInDelayTimer.reset();
			mOutDelayTimer.reset();
			mAfterDelayTimer.reset();
		}
	}
}