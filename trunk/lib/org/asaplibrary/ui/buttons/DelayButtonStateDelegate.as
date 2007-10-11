/*
Copyright 2007 by the authors of asaplibrary, http://asaplibrary.org
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
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	import org.asaplibrary.ui.buttons.ButtonStateDelegate;
		
	public class DelayButtonStateDelegate extends ButtonStateDelegate {
	
		protected var mRollOverState:Boolean; /**< Indicates if the button has a rollover, defined by the delay variables. */
		
		// Delay variables
		protected var mInDelay:Number = 0;		/**< Delay before rollOver action is performed, in seconds. */
		protected var mOutDelay:Number = 0;		/**< (Hysteresis) delay before rollOut action is performed, in seconds. */
		protected var mAfterDelay:Number = 0; /**< Delay after onRollOut until the button is activated (enabled) again, in seconds. */
	
		protected var mReEnabledTime:Number; /**< Set the time from where the button will be active again (in milliseconds); value is calculated. */
		
		protected var mInDelayTimer:Timer;
		protected var mOutDelayTimer:Timer;
		protected var mAfterDelayTimer:Timer;
		
		/**
		Creates a new DelayButtonStateDelegate.
		*/
		public function DelayButtonStateDelegate (inButton:MovieClip) {

			super(inButton);
			
			mRollOverState = false;
			
			mInDelayTimer = new Timer(0);
			mInDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, processRollOver);
			
			mOutDelayTimer = new Timer(0);
			mOutDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, processRollOut);
			
			mAfterDelayTimer = new Timer(0);
			mAfterDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, processAfterDelay);
	
		}
		
		/**
		
		*/
		override public function toString () : String {
			return ";org.asaplibrary.ui.buttons.DelayButtonStateDelegate";
		}
		
		/**
		
		*/
		public function get indelay () : Number {
			return mInDelay;
		}
		public function set indelay (inValue:Number) : void {
			mInDelay = inValue;
		}
		
		/**
		
		*/
		public function get outdelay () : Number {
			return mOutDelay;
		}
		public function set outdelay (inValue:Number) : void {
			mOutDelay = inValue;
		}
		
		/**
		
		*/
		public function get afterdelay () : Number {
			return mAfterDelay;
		}
		public function set afterdelay (inValue:Number) : void {
			mAfterDelay = inValue;
		}
		
		/**
		Handle rollover event.
		*/
		override protected function mouseOverHandler (e:MouseEvent = null) : void {
			mOutDelayTimer.reset();
			
			if (!mEnabled) return;
			if (getTimer() < mReEnabledTime) return;
			
			mInDelayTimer.reset();
			if (mInDelay == 0) {
				mRollOverState = true;
				update(null, OVER);
			} else {
				mInDelayTimer.delay = mInDelay * 1000;
				mInDelayTimer.repeatCount = 1;
				mInDelayTimer.start();
			}
			
		}
		
		/**
		Handle rollout event
		@param	e
		*/
		override protected function mouseOutHandler (e:MouseEvent = null) : void {	
			resetTimers();
	
			if (mOutDelay == 0) {
				mRollOverState = false;
				doAfterDelay();
				update(null, OUT); //rollOut();
			} else {
				var tempTime:Number = getTimer() + mOutDelay * 1000;
				if (mReEnabledTime < tempTime) {
					mReEnabledTime = tempTime;
				}
				mOutDelayTimer.delay = mOutDelay * 1000;
				mOutDelayTimer.repeatCount = 1;
				mOutDelayTimer.start();
			}
		}

		/**
		
		*/
		protected function processRollOver (e:TimerEvent) : void {
			mRollOverState = true;
			mRollOver = true;
			if (mSelected || !mEnabled) return;
			update(null, OVER);
		}
		
		/**
		
		*/
		protected function processRollOut (e:TimerEvent) : void {
			mRollOverState = false;
			doAfterDelay();
			mPressed = false;
			mRollOver = false;
			if (mSelected || !mEnabled) return;
			update(null, OUT);
		}
		
		/**
		
		*/
		protected function doAfterDelay () : void {
			if (mAfterDelay > 0) {
				mEnabled = false;
				mReEnabledTime = getTimer() + mAfterDelay * 1000;
				
				mAfterDelayTimer.delay = mAfterDelay * 1000;
				mAfterDelayTimer.repeatCount = 1;
				mAfterDelayTimer.start();
			}
		}
		
		/**
		
		*/
		protected function processAfterDelay (e:TimerEvent) : void {
			mAfterDelayTimer.reset();
			mEnabled = true;
		}
		
		/**
		
		*/
		protected function resetTimers () : void {
			mInDelayTimer.reset();
			mOutDelayTimer.reset();
			mAfterDelayTimer.reset();
		}
	
	}
}