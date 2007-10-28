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

package org.asaplibrary.util.actionqueue {

	import flash.display.DisplayObject;
	
	import org.asaplibrary.util.actionqueue.*;
	import org.asaplibrary.util.NumberUtils;
	
	public class AQBlink extends AQBaseSinoid {
		
		public static var MASK_OFFSCREEN_X:Number = -9999;
		
		// mask blink parameters
		private var mPosX:Number;
		private var mHideAtStart:Boolean;
		
		/**

		*/
		public function blink (inDO:DisplayObject,
							   inCount:int,
							   inFrequency:Number,
							   inMaxAlpha:Number,
							   inMinAlpha:Number,
							   inStartAlpha:Number = Number.NaN,
							   inDuration:Number = Number.NaN,
							   inEffect:Function = null) : Function {

			mDO = inDO;
			mCount = inCount;
			mFrequency = inFrequency;
			mDuration = inDuration;
			mEffect = inEffect;

			mParamMinValue = inMinAlpha;
			mParamMaxValue = inMaxAlpha;
			mParamStartValue = inStartAlpha;
			
			mPerformFunction = doBlink;
			// return the function that will be called by ActionRunner
			return initDoBlink;
		}
		
		/**
		
		*/
		protected function initDoBlink () : TimedAction {
			mMaxValue = (!isNaN(mParamMaxValue)) ? mParamMaxValue : mDO.alpha;
			mMinValue = (!isNaN(mParamMinValue)) ? mParamMinValue : mDO.alpha;
			return super.init();
		}
		
		/**

		*/
		protected function doBlink (inValue:Number) : Boolean {
			var amplitude:Number = Math.sin( inValue * 2 * Math.PI + mPIOffset );
			mDO.alpha = (amplitude > 0) ? mMaxValue : mMinValue;
			return true;
		}
		
		/**
		
		*/
		public function maskBlink (inDO:DisplayObject,
							   	   inCount:int,
							   	   inFrequency:Number,
								   inHideAtStart:Boolean = true,
							   	   inDuration:Number = Number.NaN,
							   	   inEffect:Function = null) : Function {

			mDO = inDO;
			mCount = inCount;
			mFrequency = inFrequency;
			mDuration = inDuration;
			mEffect = inEffect;

			mPosX = inDO.x;
			mHideAtStart = inHideAtStart;
			
			// return the function that will be called by ActionRunner
			return initDoMaskBlink;
		}
		
		/**
		
		*/
		protected function initDoMaskBlink () : TimedAction {
			
			mPIOffset = 0;
			if (mHideAtStart) {
				mPIOffset = -Math.PI;
			}
			
			var cycleDuration:Number = 1.0 / mFrequency; // in seconds
			
			var frameAction:TimedAction = new TimedAction(this, doMaskBlink, cycleDuration, mEffect);
			var loopCount:uint = calculateLoopCount(mCount, mDuration, cycleDuration);
			frameAction.setLoop(true); // loops loopCount or infinite if mDuration == 0
			frameAction.setLoopCount(loopCount);
			
			return frameAction;
		}
		
		/**
		@param inValue counting down from {@link #END_VALUE} to {@link #START_VALUE}
		*/
		protected function doMaskBlink (inValue:Number) : Boolean {
			var amplitude:Number = Math.sin( inValue * 2 * Math.PI + mPIOffset );
			mDO.x = (amplitude > 0) ? MASK_OFFSCREEN_X : mPosX;
			return true;
		}
		
	}	
}