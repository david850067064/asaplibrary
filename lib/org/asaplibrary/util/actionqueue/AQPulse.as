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
	
	/**
	Action methods to control pulsing animations (fading, scaling) of a DisplayObject.
	*/
	public class AQPulse extends AQBaseSinusoid {
		
		public function fade (inDO:DisplayObject, inCount:int, inFrequency:Number, inMaxAlpha:Number, inMinAlpha:Number, inStartAlpha:Number = Number.NaN, inDuration:Number = Number.NaN, inEffect:Function = null) : Function {

			mDO = inDO;
			mCount = inCount;
			mFrequency = inFrequency;
			mDuration = inDuration;
			mEffect = inEffect;

			mParamMinValue = inMinAlpha;
			mParamMaxValue = inMaxAlpha;
			mParamStartValue = inStartAlpha;
			
			mPerformFunction = doFade;
			
			// return the function that will be called by ActionRunner
			return initDoFade;
		}
		
		/**
		
		*/
		protected function initDoFade () : TimedAction {
			mMaxValue = (!isNaN(mParamMaxValue)) ? mParamMaxValue : mDO.alpha;
			mMinValue = (!isNaN(mParamMinValue)) ? mParamMinValue : mDO.alpha;
			return super.init();
		}
		
		/**

		*/
		protected function doFade (inValue:Number) : Boolean {
			var amplitude:Number = Math.sin( inValue * 2 * Math.PI + mPIOffset ) + 1;			
			mDO.alpha = mMinValue + (amplitude * mMiddleValue);
			return true;
		}
		
		/**
		
		*/
		public function scale (inDO:DisplayObject, inCount:int, inFrequency:Number, inMaxScale:Number, inMinScale:Number, inStartScale:Number = Number.NaN, inDuration:Number = Number.NaN, inEffect:Function = null) : Function {

			mDO = inDO;
			mCount = inCount;
			mFrequency = inFrequency;
			mDuration = inDuration;
			mEffect = inEffect;

			mParamMinValue = inMinScale;
			mParamMaxValue = inMaxScale;
			mParamStartValue = inStartScale;
			
			mPerformFunction = doScale;
			
			// return the function that will be called by ActionRunner
			return initDoScale;
		}
		
		/**
		
		*/
		protected function initDoScale () : TimedAction {
			mMaxValue = (!isNaN(mParamMaxValue)) ? mParamMaxValue : mDO.scaleX;
			mMinValue = (!isNaN(mParamMinValue)) ? mParamMinValue : mDO.scaleX;
			return super.init();
		}
		
		/**

		*/
		protected function doScale (inValue:Number) : Boolean {
			var amplitude:Number = Math.sin( inValue * 2 * Math.PI + mPIOffset ) + 1;			
			mDO.scaleX = mDO.scaleY = mMinValue + (amplitude * mMiddleValue);
			return true;
		}
	}	
}
