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
	Action method to control the timed fading of a DisplayObject.
	 */
	public class AQFade {
		private var mDO : DisplayObject;
		private var mDuration : Number;
		private var mEffect : Function;
		// parameters related to properties that may have changed at the time the performing function is called
		private var mParamStartAlpha : Number;
		private var mParamEndAlpha : Number;
		private var mStartAlpha : Number;
		private var mEndAlpha : Number;

		/**
		@param inDO : DisplayObject to fade
		@param inDuration : length of change in seconds; 0 is used for perpetual animations - use -1 for instant change
		@param inStartAlpha : value to start fading from; if NaN then inDO's current alpha value is used
		@param inEndAlpha : value to start fading to; if NaN then inDO's current alpha value is used
		@param inEffect : (optional) an effect function, for instance one of the fl.transitions.easing methods
		@return A reference to {@link #initDoFade} that in turn returns the performing fade {@link TimedAction}.
		 */
		public function fade(inDO : DisplayObject, inDuration : Number, inStartAlpha : Number, inEndAlpha : Number, inEffect : Function = null) : Function {
			mDO = inDO;
			mDuration = inDuration;
			mEffect = inEffect;

			mParamStartAlpha = inStartAlpha;
			mParamEndAlpha = inEndAlpha;

			// return the function that will be called by ActionRunner
			return initDoFade;
		}

		/**
		Initializes the starting values.
		 */
		protected function initDoFade() : TimedAction {
			mStartAlpha = (!isNaN(mParamStartAlpha)) ? mParamStartAlpha : mDO.alpha;
			mEndAlpha = (!isNaN(mParamEndAlpha)) ? mParamEndAlpha : mDO.alpha;
			return new TimedAction(doFade, mDuration, mEffect);
		}

		/**
		Calculates and sets the alpha value of the DisplayObject.
		@param inValue: the percentage value ranging from 0 to 1.
		@return True (the animation will not be interrupted).
		 */
		protected function doFade(inValue : Number) : Boolean {
			mDO.alpha = mEndAlpha - (inValue * (mEndAlpha - mStartAlpha));
			return true;
		}
	}
}
