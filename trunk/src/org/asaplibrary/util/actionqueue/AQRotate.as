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
	import flash.display.DisplayObject;

	/**
	Action method to control the timed rotation of a DisplayObject.
	 */
	public class AQRotate {
		public static const NONE : uint = 0;
		public static const CW : uint = 1 << 1;
		/**< Clockwise rotation. */
		public static const CCW : uint = 1 << 2;
		/**< Counter-clockwise rotation. */
		public static const NEAR : uint = 1 << 3;
		/**< Clockwise or counter-clockwise rotation to nearest rotation. */
		private var mDO : DisplayObject;
		private var mDuration : Number;
		private var mEffect : Function;
		// parameters related to properties that may have changed at the time the performing function is called
		private var mParamStartRotation : Number;
		private var mParamEndRotation : Number;
		private var mStartRotation : Number;
		private var mEndRotation : Number;
		private var mChangeRotation : Number;
		private var mDirection : Number;

		/**
		@param inDO : DisplayObject to rotate
		@param inDuration : length of rotation in seconds; 0 is used for perpetual animations - use -1 for instant rotation
		@param inStartRotation : the starting rotation in degrees; if NaN the current DisplayObject's rotation will be used
		@param inEndRotation : the end rotation in degrees; if NaN the current DisplayObject's rotation will be used
		@param inDirection : (optional) the rotation direction; either <code>AQRotate.CW</code> (clockwise) or <code>AQRotate.CCW</code> (counter-clockwise) or <code>AQRotate.NEAR</code> (nearest rotation); default <code>CW</code>
		@param inEffect : (optional) an effect function, for instance one of the fl.transitions.easing methods
		@return A reference to {@link #initDoRotate} that in turn returns the performing rotation {@link TimedAction}.
		@example
		This example rotates a needle in a dial to the location that has been clicked, using the direction of the nearest rotation:
		<code>
		var angle:Number = NumberUtils.angle(mouseX - tNeedle.x, mouseY - tNeedle.y);
		queue.addAction( AQRotate.rotate, tNeedle, 1, NaN, angle, AQRotate.NEAR );	
		@usageNote Bug: passing an inDuration of 0 will result in no rotation at all.
		</code>
		 */
		public function rotate(inDO : DisplayObject, inDuration : Number, inStartRotation : Number, inEndRotation : Number, inDirection : uint = AQRotate.NONE, inEffect : Function = null) : Function {
			mDO = inDO;
			mDuration = inDuration;
			mEffect = inEffect;
			mDirection = inDirection;

			mParamStartRotation = inStartRotation;
			mParamEndRotation = inEndRotation;

			return initDoRotate;
		}

		/**
		Initializes the starting values.
		 */
		protected function initDoRotate() : TimedAction {
			mStartRotation = (!isNaN(mParamStartRotation)) ? mParamStartRotation : mDO.rotation;
			mStartRotation %= 360;
			if (mStartRotation < 0) mStartRotation += 360;

			mEndRotation = (!isNaN(mParamEndRotation)) ? mParamEndRotation : mDO.rotation;
			mEndRotation %= 360;
			if (mEndRotation < 0) mEndRotation += 360;

			if (mEndRotation > mStartRotation && mDirection == AQRotate.CCW) {
				mEndRotation -= 360;
			}
			if (mEndRotation < mStartRotation && mDirection == AQRotate.CW) {
				mEndRotation += 360;
			}

			mChangeRotation = mEndRotation - mStartRotation;

			if (mDirection == AQRotate.NEAR) {
				if ((360 - mChangeRotation) < mChangeRotation) {
					mChangeRotation = mChangeRotation - 360;
				}
				if (360 - Math.abs(mChangeRotation) < Math.abs(mChangeRotation)) {
					mChangeRotation = 360 - Math.abs(mChangeRotation);
				}
			}

			return new TimedAction(doRotate, mDuration, mEffect);
		}

		/**
		Calculates and sets the rotation value of the DisplayObject.
		@param inValue: the percentage value ranging from 0 to 1.
		@return True (the animation will not be interrupted).
		 */
		protected function doRotate(inValue : Number) : Boolean {
			mDO.rotation = mEndRotation - (inValue * mChangeRotation);
			return true;
		}
	}
}