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
package org.asaplibrary.util.actionqueue {
	import org.asaplibrary.util.FramePulse;

	import flash.events.*;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;

	/**
	A TimedAction is an Action that performs a function during a set time period.
	 */
	public class TimedAction extends Action implements ITimedAction {
		protected var mDuration : Number;
		/**< Duration of the animation in seconds. */
		protected var mEffect : Function;
		/**< An effect function, for instance one of the fl.motion.easing methods. */
		protected var mStart : Number = 1;
		/**< Percentage start value to get returned. */
		protected var mEnd : Number = 0;
		/**< Percentage end value to get returned. */
		protected var mRange : Number;
		protected var mPercentage : Number;
		protected var mValue : Number;
		protected var mLoop : Boolean;
		protected var mLoopCount : int;
		protected var mLoopCounter : int = 0;
		protected var mEndTime : Number;
		protected var mDurationFactor : Number;
		protected var mIsRunning : Boolean;
		protected var mDurationLeft : Number;

		/**
		Creates a new TimedAction.
		@param inMethod: function reference
		@param inDuration: (optional) duration of the time period in seconds;  the duration may be set to 0 - the action will then last indefinite
		@param inUndoMethod: (optional) not implemented yet
		@param inUndoArgs: (optional) not implemented yet
		 */
		public function TimedAction(inMethod : Function, inDuration : Number = Number.NaN, inEffect : Function = null, inUndoMethod : Function = null, inUndoArgs : Array = null) {
			super(inMethod, null, inUndoMethod, inUndoArgs);

			mDuration = inDuration;
			mRange = mEnd - mStart;
			mEffect = inEffect;

			mIsRunning = false;
		}

		/**
		Stops the running action.
		@sends ActionEvent#STOPPED
		 */
		public function stop() : void {
			unRegister();
			mIsRunning = false;
			dispatchEvent(new ActionEvent(ActionEvent.STOPPED, this));
		}

		public function reset() : void {
			stop();
		}

		/**
		Stops the running action and sends out a "finished" message.
		@sends ActionEvent#FINISHED
		 */
		public function finish() : void {
			unRegister();
			mIsRunning = false;
			dispatchEvent(new ActionEvent(ActionEvent.FINISHED, this));
		}

		/**
		Sets the looping state of the action.
		@param inState: true: the action is looping; default false
		 */
		public function setLoop(inState : Boolean) : void {
			mLoop = inState;
		}

		/**
		Sets the number of loops this action will perform.
		@param inLoopCount: the number of loops this action will perform; use 0 to loop indefinitely
		 */
		public function setLoopCount(inLoopCount : uint) : void {
			mLoop = true;
			mLoopCount = inLoopCount;
		}

		/**
		@exclude
		 */
		override public function toString() : String {
			return getQualifiedClassName(this) + "; duration=" + mDuration + "; start=" + mStart + "; end=" + mEnd;
		}

		/**
		@return True if the action loop state is set to true and the action is still running inside a loop; otherwise false
		 */
		public function doesLoop() : Boolean {
			if (mLoop) {
				if (mLoopCount == 0) return true;
				if (mLoopCounter <= mLoopCount) return true;
				return false;
			}
			return false;
		}

		/**
		@return True if the action is still running; otherwise false.
		 */
		override public function isRunning() : Boolean {
			return mIsRunning;
		}

		/**
		Starts invoking the action method.
		@return null.
		 */
		public override function run() : * {
			register();
			var msduration : Number = mDuration * 1000;
			// translate to milliseconds
			mDurationFactor = 1 / msduration;
			mEndTime = getTimer() + msduration;
			mIsRunning = true;
			return null;
		}

		/**
		Pauses the action method.
		@param inContinueWhereLeftOff: (optional) whether the action should continue where it left off when the action is resumed
		 */
		public function pause(inContinueWhereLeftOff : Boolean = true) : void {
			unRegister();
			if (inContinueWhereLeftOff) {
				mDurationLeft = mEndTime - getTimer();
			} else {
				// remove old value
				mDurationLeft = Number.NaN;
			}
		}

		/**
		Resumes a paused action.
		 */
		public function resume() : void {
			if (!isNaN(mDurationLeft)) {
				mEndTime = getTimer() + mDurationLeft;
			}
			mIsRunning = true;
			register();
		}

		/**
		Called each {@link FramePulse} event. Calls {@link #run} on the action method while the end time has not been reached. Calls {@link #finish} as soon as the end time has been reached. Calls {@link #stop} if the invoked method returns false.
		@param e: not used
		 */
		protected function step(e : Event) : void {
			if (!mIsRunning) return;

			var msNow : Number = getTimer();
			if (mDuration != 0) {
				// calculate percentage (1 to 0)

				if (msNow < mEndTime) {
					mPercentage = (mEndTime - msNow) * mDurationFactor;
				} else {
					mPercentage = 0;
				}
				if (mEffect != null) {
					mValue = Number(mEffect(1 - mPercentage, mStart, mRange, 1));
				} else {
					mValue = mEnd - (mPercentage * mRange);
				}
			}

			var result : Boolean = mMethod(mValue);

			if (mDuration != 0) {
				if (msNow >= mEndTime) {
					if (mLoop) {
						mLoopCounter++;
					}
					if (doesLoop()) {
						run();
					} else {
						finish();
					}
				}
			}

			// stop when the action returns false
			if (!result) {
				stop();
			}
		}

		/**
		Registers to listen for {@link FramePulse} events.
		 */
		protected function register() : void {
			FramePulse.addEnterFrameListener(step);
		}

		/**
		Unregisters for {@link FramePulse} events.
		 */
		protected function unRegister() : void {
			FramePulse.removeEnterFrameListener(step);
		}
	}
}