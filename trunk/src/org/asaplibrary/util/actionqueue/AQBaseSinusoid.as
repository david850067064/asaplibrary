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
	import org.asaplibrary.util.NumberUtils;

	import flash.display.DisplayObject;

	/**
	Base class that calculates the starting values for sinusoid-like movements like blinking and pulsing.
	 */
	public class AQBaseSinusoid {
		protected var mDO : DisplayObject;
		protected var mDuration : Number;
		protected var mEffect : Function;
		// parameters related to properties that may have changed at the time the performing function is called
		protected var mParamMinValue : Number;
		protected var mParamMaxValue : Number;
		protected var mParamStartValue : Number;
		protected var mMinValue : Number;
		protected var mMiddleValue : Number;
		protected var mMaxValue : Number;
		protected var mPIOffset : Number;
		protected var mCount : Number;
		protected var mFrequency : Number;
		protected var mPerformFunction : Function;

		/**
		Initializes the starting values.
		@return A TimedAction created from {@link #mPerformFunction}. 
		 */
		protected function init() : TimedAction {
			mMaxValue = (!isNaN(mParamMaxValue)) ? mParamMaxValue : mDO.alpha;
			mMinValue = (!isNaN(mParamMinValue)) ? mParamMinValue : mDO.alpha;

			mMiddleValue = 0.5 * (mMaxValue - mMinValue);
			var startValue : Number = !isNaN(mParamStartValue) ? mParamStartValue : mMiddleValue;
			if (startValue < mMinValue) startValue = mMinValue;
			if (startValue > mMaxValue) startValue = mMaxValue;

			mPIOffset = NumberUtils.xPosOnSinus(startValue, mMinValue, mMaxValue);

			var cycleDuration : Number = 1.0 / mFrequency;

			var frameAction : TimedAction = new TimedAction(mPerformFunction, cycleDuration, mEffect);
			var loopCount : uint = calculateLoopCount(mCount, mDuration, cycleDuration);
			frameAction.setLoop(true);
			// loops loopCount or infinite if mDuration == 0
			frameAction.setLoopCount(loopCount);

			return frameAction;
		}

		/**
		
		 */
		protected function calculateLoopCount(inCount : int, inDuration : Number, inCycleDuration : Number) : uint {
			if (inDuration == 0) {
				return 0;
			} else if (inDuration > 0) {
				return (inDuration / inCycleDuration);
			} else {
				// NaN
				return inCount;
			}
		}
	}
}