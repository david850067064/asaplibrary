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
package org.asaplibrary.util {
	import flash.events.Event;

	/**
	Delay a function call with one or more frames. Use this when initializing a SWF or a bunch of DisplayObjects, to enable the player to do its thing.	Usually a single frame delay will do the job, since the next enterFrame will come when all other jobs are finished.
	@usage
	To execute function 'init' after 1 frame, use:
	<code>
	new FrameDelay(init);
	</code>
	To execute function 'init' after 10 frames, use:
	<code>
	new FrameDelay(init, 10);
	</code>
	To call function 'setProps' with parameters, executed after 1 frame:
	<code>
	new FrameDelay(setProps, 1, [shape, 'alpha', 0]);
	</code>
	<code>
	private function setProps (inShape:Shape, inProperty:String, inValue:Number) : void {
	inShape[inProperty] == inValue);
	}
	</code>
	 */
	public class FrameDelay {
		private var mIsDone : Boolean = false;
		private var mCurrentFrame : int;
		private var mCallback : Function;
		private var mParams : Array;

		/**
		Creates a new FrameDelay. Starts the delay immediately.
		@param inCallback: the callback function to be called when done waiting
		@param inFrameCount: the number of frames to wait; when left out, or set to 1 or 0, one frame is waited
		@param inParams: list of parameters to pass to the callback function
		 */
		public function FrameDelay(inCallback : Function, inFrameCount : int = 0, inParams : Array = null) {
			mCurrentFrame = inFrameCount;
			mCallback = inCallback;
			mParams = inParams;
			mIsDone = (isNaN(inFrameCount) || (inFrameCount <= 1));
			FramePulse.addEnterFrameListener(handleEnterFrame);
		}

		/**
		Release reference to creating object.
		Use this to remove a FrameDelay object that is still running when the creating object will be removed.
		 */
		public function die() : void {
			if (!mIsDone) {
				FramePulse.removeEnterFrameListener(handleEnterFrame);
			}
		}

		/**
		Handle the onEnterFrame event.
		Checks if still waiting - when true: calls callback function.
		@param e: not used
		 */
		private function handleEnterFrame(e : Event) : void {
			if (mIsDone) {
				FramePulse.removeEnterFrameListener(handleEnterFrame);
				if (mParams == null) {
					mCallback();
				} else {
					mCallback.apply(null, mParams);
				}
			} else {
				mCurrentFrame--;
				mIsDone = (mCurrentFrame <= 1);
			}
		}
	}
}