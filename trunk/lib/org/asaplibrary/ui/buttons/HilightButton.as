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

	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.asaplibrary.util.FramePulse;
	
	public class HilightButton extends BaseButton {
	
		private static var LABEL_UP : String = "up";
		private static var LABEL_OVER : String = "over";
		private static var LABEL_ON : String = "on";
		private static var LABEL_OUT : String = "out";
		private var mForceHilight : Boolean;
		private var mIsAnimating : Boolean;
		private var mDoOutAnimation : Boolean;
		private var mForceHilightAnimate : Boolean;

		public function HilightButton () {
			super();
			
			addEventListener(Event.ADDED, handleAdded);
			addEventListener(MouseEvent.ROLL_OVER, handleRollOver);
			addEventListener(MouseEvent.ROLL_OUT, handleRollOut);
		}
		
		/**
		 * True if the current frame is the hilight frame
		 */
		public function get isLit () : Boolean {
			return (currentLabel == LABEL_ON);
		}
		
		/**
		 * Go to hilight frame
		 * @param inAnimate: if true, change will be animated, otherwise immediate
		 */
		public function hilight (inAnimate : Boolean = false) : void {
			mForceHilight = true;
			mForceHilightAnimate = inAnimate;
			
			if (!inAnimate) gotoAndStop(LABEL_ON);
			else handleRollOver();
		}
		
		/**
		 * Go directly to the "up" frame
		 * @param inAnimate: if true, change will be animated, otherwise immediate
		 */
		public function unHilight (inAnimate : Boolean = false) : void {
			if (!inAnimate) gotoAndStop(LABEL_UP);
			else handleRollOut();
		}
		
		/**
		 * Handle internal event that instance has been added to the stage
		 * @param	e
		 * @return
		 */
		private function handleAdded (e : Event) : void {
			if (mForceHilight) {
				mForceHilight = false;
				hilight(mForceHilightAnimate);
			}
		}
		
		/**
		 * Handle rollover event.
		 */
		private function handleRollOver (e : MouseEvent = null) : void {
			gotoAndPlay(LABEL_OVER);

			mIsAnimating = true;
			mDoOutAnimation = false;
			FramePulse.addEnterFrameListener(checkAnimation);
		}
		
		/**
		 * Handle rollout event
		 * @param	e
		 * @return
		 */
		private function handleRollOut (e : MouseEvent = null) : void {
			if (mIsAnimating) {
				mDoOutAnimation = true;
			} else {
				gotoAndPlay(LABEL_OUT);
			}
		}
		
		/**
		 * enterFrame handler that checks if animation has to continue
		 */
		private function checkAnimation (e : Event) : void {
			if (currentLabel == LABEL_ON) {
				mIsAnimating = false;
				FramePulse.removeEnterFrameListener(checkAnimation);

				if (mDoOutAnimation) {
					handleRollOut();
				} else {
					stop();
				}
			}
		}
		
		override public function toString () : String {
			return ";org.asaplibrary.ui.buttons.HilightButton";
		}
	}
}
