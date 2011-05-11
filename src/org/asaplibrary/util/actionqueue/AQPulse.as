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
	Action methods to control pulsing animations (fading, scaling) of a DisplayObject.
	 */
	public class AQPulse extends AQBaseSinusoid {
		/**
		Fades a DisplayObject in and out, in a pulsating manner.
		@param inDO : DisplayObject to pulse
		@param inCount : the number of times the DisplayObject should pulse (the number of cycles, where each cycle is a full sine curve)
		@param inFrequency : number of pulsations per second
		@param inMinAlpha : the lowest alpha when pulsating; when no value is passed the current inDO's alpha is used
		@param inMaxAlpha : the highest alpha when pulsating; when no value is passed the current inDO's alpha is used
		@param inStartAlpha : (optional) the starting alpha; if not given, the average of the max alpha and min alpha is used
		@param inDuration : (optional: pass either inDuration or inCount - if inDuration is given, inCount will be ignored) length of pulsating in seconds; when 0, pulsating is infinite, otherwise the movement will be stopped as soon as the duration has passed; in seconds
		@param inEffect : (optional) an effect function, for instance one of the fl.transitions.easing methods
		@return A reference to {@link #initDoFade} that in turn returns the performing fade {@link TimedAction}.
		 */
		public function fade(inDO : DisplayObject, inCount : int, inFrequency : Number, inMaxAlpha : Number, inMinAlpha : Number, inStartAlpha : Number = Number.NaN, inDuration : Number = Number.NaN, inEffect : Function = null) : Function {
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
		Initializes the starting values.
		 */
		protected function initDoFade() : TimedAction {
			mMaxValue = (!isNaN(mParamMaxValue)) ? mParamMaxValue : mDO.alpha;
			mMinValue = (!isNaN(mParamMinValue)) ? mParamMinValue : mDO.alpha;
			return super.init();
		}

		/**
		Calculates and sets the alpha value of the DisplayObject.
		@param inValue: the percentage value for each sine cycle, ranging from 0 to 1.
		@return True (the animation will not be interrupted).
		 */
		protected function doFade(inValue : Number) : Boolean {
			var amplitude : Number = Math.sin(inValue * 2 * Math.PI + mPIOffset) + 1;
			mDO.alpha = mMinValue + (amplitude * mMiddleValue);
			return true;
		}

		/**
		Scales a DisplayObject larger and smaller in a pulsating manner.
		@param inDO : DisplayObject to pulse
		@param inCount : the number of times the DisplayObject should pulse (the number of cycles, where each cycle is a full sine curve)
		@param inFrequency : number of pulsations per second
		@param inMaxScale : the largest scale (both x and y) when pulsating; when no value is passed the current inDO's scaleX is used
		@param inMinScale : the smallest scale (both x and y) when pulsating; when no value is passed the current inDO's scaleY is used
		@param inStartScale : (optional) the starting scale; if not given, the average of the max scale and min scale is used
		@param inDuration : (optional: pass either inDuration or inCount - if inDuration is given, inCount will be ignored) length of pulsating in seconds; when 0, pulsating is infinite, otherwise the movement will be stopped as soon as the duration has passed; in seconds
		@param inEffect : (optional) an effect function, for instance one of the fl.transitions.easing methods
		@return A reference to {@link #initDoScale} that in turn returns the performing scale {@link TimedAction}.
		 */
		public function scale(inDO : DisplayObject, inCount : int, inFrequency : Number, inMaxScale : Number, inMinScale : Number, inStartScale : Number = Number.NaN, inDuration : Number = Number.NaN, inEffect : Function = null) : Function {
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
		Initializes the starting values.
		 */
		protected function initDoScale() : TimedAction {
			mMaxValue = (!isNaN(mParamMaxValue)) ? mParamMaxValue : mDO.scaleX;
			mMinValue = (!isNaN(mParamMinValue)) ? mParamMinValue : mDO.scaleX;
			return super.init();
		}

		/**
		Calculates and sets the scaleX and scaleY values of the DisplayObject.
		@param inValue: the percentage value for each sine cycle, ranging from 0 to 1.
		@return True (the animation will not be interrupted).
		 */
		protected function doScale(inValue : Number) : Boolean {
			var amplitude : Number = Math.sin(inValue * 2 * Math.PI + mPIOffset) + 1;
			mDO.scaleX = mDO.scaleY = mMinValue + (amplitude * mMiddleValue);
			return true;
		}
	}
}
