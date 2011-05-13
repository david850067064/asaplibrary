/*
Copyright 2008-2011 by the authors of asaplibrary, http://asaplibrary.org

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
package org.asaplibrary.ui.animation {
	import org.asaplibrary.util.FrameDelay;
	import org.asaplibrary.util.FramePulse;

	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;

	/**
	 * Wrapper class to control a timeline animation and receive events when animations are done.
	 * The timeline animation can have labels "in" and "out" defined, that will be used as control points for specific animations. See each of the functions ({@link #goIn}, {@link #goOut}, {@link #playOneShotAnimation}) for detailed behaviour description.
	 * 
	 * Example:
	 * Suppose a MovieClip instance with instance name "tIntroAnimation" that is a child of the class in which the following code is defined. This MovieClip has labels "in" and "out" defined on its timeline.
	 * <code>
	 * private var mAnimation : TimelineAnimation;
	 * 
	 * private function createUI() : void {
	 * 		mAnimation = new TimelineAnimator(tIntroAnimation);
	 * 		mAnimation.addEventListener(AnimationEvent._EVENT, handleAnimationEvent);
	 * 		mAnimation.goIn();
	 * }
	 * 
	 * private function handleAnimationEvent (e:AnimationEvent) : void {
	 * 		switch (e.subtype) {
	 * 			case AnimationEvent.IN_ANIMATION_DONE: mAnimation.goOut(); break;
	 * 			case AnimationEvent.OUT_ANIMATION_DONE: mAnimation.goIn(); break;
	 * 		}
	 * 	}
	 * 	</code>
	 * 
	 */
	public class TimelineAnimator extends EventDispatcher {
		private var mTarget : MovieClip;
		private var mEvent : String;
		private var mInFrame : int;
		private var mOutFrame : int;
		private var mInDoneFrame : int;
		private var mEndFrame : int;
		private var mFinalFrame : int;

		/**
		 * Constructor
		 * @param inTarget: MovieClip to be controlled
		 */
		public function TimelineAnimator(inTarget : MovieClip) {
			super();

			mTarget = inTarget;

			mTarget.gotoAndStop(1);

			initUI();
		}

		/**
		 *	@return the target for this animator
		 */
		public function get target() : MovieClip {
			return mTarget;
		}

		/**
		 * Play single shot animation from the first frame, the provided location or the current position, until the last frame; animation stops at the first frame
		 * @param inStart: frame number or label to start animation from; pass null to start from current position
		 */
		public function playOneShotAnimation(inStart : * = 1) : void {
			start(inStart, mTarget.totalFrames, 1, AnimationEvent.ANIMATION_DONE);
		}

		/**
		 *	Start in animation at label "in" if defined, or current frame, until 1 frame before "out" frame if defined, or last frame; animation stops at the last frame
		 */
		public function goIn() : void {
			start(mInFrame, mInDoneFrame, mInDoneFrame, AnimationEvent.IN_ANIMATION_DONE);
		}

		/**
		 *	Start out animation at label "out" if defined, or current frame, until last frame; animation stops at the first frame
		 */
		public function goOut() : void {
			start(mOutFrame, mTarget.totalFrames, 1, AnimationEvent.OUT_ANIMATION_DONE);
		}

		private function start(inStartFrame : *, inEndFrame : int, inFinalFrame : int, inEvent : String) : void {
			mEndFrame = inEndFrame;
			mFinalFrame = inFinalFrame;
			mEvent = inEvent;

			FramePulse.addEnterFrameListener(checkAnimation);

			if (inStartFrame) mTarget.gotoAndPlay(inStartFrame);
			else mTarget.play();
		}

		private function checkAnimation(e : Event) : void {
			if (mTarget.currentFrame == mEndFrame) new FrameDelay(stopAnimation);
		}

		private function stopAnimation() : void {
			mTarget.gotoAndStop(mFinalFrame);

			FramePulse.removeEnterFrameListener(checkAnimation);

			dispatchEvent(new AnimationEvent(mEvent));
		}

		private function initUI() : void {
			var labels : Array = mTarget.currentLabels;
			var leni : uint = labels.length;
			for (var i : uint = 0; i < leni; i++) {
				var label : FrameLabel = labels[i];
				if (label.name == "in") mInFrame = label.frame;
				else if (label.name == "out") mOutFrame = label.frame;
			}

			if (mInFrame) {
				mInDoneFrame = mOutFrame ? mOutFrame - 1 : mTarget.totalFrames;
			}
		}

		override public function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}
