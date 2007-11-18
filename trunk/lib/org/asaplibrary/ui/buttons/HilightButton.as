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
	import org.asaplibrary.ui.buttons.*;

	/**
	Button with highlight behavior.
	The button timeline is expected to have 4 labels: "up", "over", "on" (maintained over state) and "out".
	The first frame (labeled "up") has a <code>stop()</code> command.
	A hitarea clip named "tHitarea" is recommended. Because HilightButton inherits from BaseButton, the hitarea clip is automatically hidden.
	
	Frames scenario:
	1. No interaction: the button has stopped at the first frame
	2. Mouse moves over button: the playhead moves to frame "over", optionally goes through the frames, and ends on frame "on"
	3. Mouse moves away from button: the playhead moves to frame "out", optionally goes through the frames, and wraps to the first frame
	*/
	public class HilightButton extends BaseButton {
	
		private static var LABEL_UP:String = "up";
		private static var LABEL_OVER:String = "over";
		private static var LABEL_ON:String = "on";
		private static var LABEL_OUT:String = "out";
		
		private var mBehavior:DelayButtonBehavior;

		private var mAnimatingOver:Boolean;
		private var mDoOutAnimation:Boolean;
		private var mForceHilightAnimate:Boolean;

		public function HilightButton () {
			super();
			
			mBehavior = new DelayButtonBehavior(this);
			mBehavior.addEventListener(ButtonBehaviorEvent._EVENT, update);
		}
		
		/**
		@return True if the current frame is the hilight frame "on"; otherwise false.
		*/
		public function get isLit () : Boolean {
			return (currentLabel == LABEL_ON);
		}
		
		/**
		@return True if the playhead has moved past the "over" frame but has not ended on the "on" frame.
		*/
		public function get isAnimatingOver () : Boolean {
			return mAnimatingOver;
		}
		
		/**
		Go to hilight frame
		@param inDoAnimate: if true, change will be animated, otherwise immediate
		*/
		public function hilight (inDoAnimate:Boolean = false) : void {

			mForceHilightAnimate = inDoAnimate;			
			if (!inDoAnimate) drawOn();
			if (inDoAnimate) drawOver();
		}
		
		/**
		 * Go directly to the "up" frame
		 * @param inAnimate: if true, change will be animated, otherwise immediate
		 */
		public function unHilight (inAnimate:Boolean = false) : void {
			if (!inAnimate) drawUp();
			if (inAnimate) drawOut();
		}
		
		/**
		Deal with button state events (received from mBehavior).
		@param e: e.state contains the button state information
		*/
		protected function update (e:ButtonBehaviorEvent) : void {
			if (e.state == ButtonStates.ADDED) init();
			if (e.state == ButtonStates.OVER) drawOver();
			if (e.state == ButtonStates.OUT) drawOut();
		}
		
		/**
		Button has just been added to the stage.
		*/
		protected function init () : void {
			drawUp();
		}
		
		/**
		Draw the up state.
		*/
		protected function drawUp () : void {
			gotoAndStop(LABEL_UP);
		}
		
		/**
		Draw the maintained rollover state.
		*/
		protected function drawOn () : void {
			gotoAndStop(LABEL_ON);
		}
		
		/**
		Draw the mouse over state.
		*/
		protected function drawOver () : void {
			gotoAndPlay(LABEL_OVER);

			mAnimatingOver = true;
			mDoOutAnimation = false;
			FramePulse.addEnterFrameListener(checkAnimation);
		}
		
		/**
		Draw the mouse out state.
		*/
		protected function drawOut () : void {
			if (mAnimatingOver) mDoOutAnimation = true;
			if (!mAnimatingOver) gotoAndPlay(LABEL_OUT);
		}
		
		/**
		 * enterFrame handler that checks if animation has to continue
		 */
		protected function checkAnimation (e:Event) : void {
			if (currentLabel == LABEL_ON) {
				mAnimatingOver = false;
				FramePulse.removeEnterFrameListener(checkAnimation);

				if (mDoOutAnimation) drawOut();
				if (!mDoOutAnimation) stop();
			}
		}
		
		override public function toString () : String {
			return ";org.asaplibrary.ui.buttons.HilightButton";
		}
	}
}
