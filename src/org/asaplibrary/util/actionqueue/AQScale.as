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
	Action method to control the timed scaling of a DisplayObject.
	@example:
	<code>
	const CURRENT:Number = Number.NaN;
	queue.addAction(new AQScale().scale(my_mc, 3, CURRENT, CURRENT, 4, 4));
	</code>
	 */
	public class AQScale {
		private var mDO : DisplayObject;
		private var mDuration : Number;
		private var mEffect : Function;
		// parameters related to properties that may have changed at the time the performing function is called
		private var mParamStartScaleX : Number;
		private var mParamStartScaleY : Number;
		private var mParamEndScaleX : Number;
		private var mParamEndScaleY : Number;
		private var mStartScaleX : Number;
		private var mStartScaleY : Number;
		private var mEndScaleX : Number;
		private var mEndScaleY : Number;

		/**
		@param inDO : DisplayObject to scale
		@param inDuration : length of change in seconds; 0 is used for perpetual animations - use -1 for instant change
		@param inStartScaleX : x value to start scaling from; if NaN then inDO's current scaleX value is used
		@param inStartScaleY : y value to start scaling from; if NaN then inDO's current scaleY value is used
		@param inEndScaleX : x value to end scaling to; if NaN then inDO's current (dynamic) scaleX value is used
		@param inEndScaleY : y value to end scaling to; if NaN then inDO's current (dynamic) scaleY value is used
		@param inEffect : (optional) an effect function, for instance one of the fl.transitions.easing methods
		@return A reference to {@link #initDoScale} that in turn returns the performing fade {@link TimedAction}.
		 */
		public function scale(inDO : DisplayObject, inDuration : Number, inStartScaleX : Number, inStartScaleY : Number, inEndScaleX : Number, inEndScaleY : Number, inEffect : Function = null) : Function {
			mDO = inDO;
			mDuration = inDuration;
			mEffect = inEffect;

			mParamStartScaleX = inStartScaleX;
			mParamStartScaleY = inStartScaleY;
			mParamEndScaleX = inEndScaleX;
			mParamEndScaleY = inEndScaleY;

			return initDoScale;
		}

		/**
		Initializes the starting values.
		 */
		protected function initDoScale() : TimedAction {
			mStartScaleX = (!isNaN(mParamStartScaleX)) ? mParamStartScaleX : mDO.scaleX;
			mStartScaleY = (!isNaN(mParamStartScaleY)) ? mParamStartScaleY : mDO.scaleY;
			mEndScaleX = (!isNaN(mParamEndScaleX)) ? mParamEndScaleX : mDO.scaleX;
			mEndScaleY = (!isNaN(mParamEndScaleY)) ? mParamEndScaleY : mDO.scaleY;

			return new TimedAction(doScale, mDuration, mEffect);
		}

		/**
		Calculates and sets the scaleX and scaleY values of the DisplayObject.
		@param inValue: the percentage value ranging from 0 to 1.
		@return True (the animation will not be interrupted).
		 */
		protected function doScale(inValue : Number) : Boolean {
			mDO.scaleX = mEndScaleX - (inValue * (mEndScaleX - mStartScaleX));
			mDO.scaleY = mEndScaleY - (inValue * (mEndScaleY - mStartScaleY));
			return true;
		}
	}
}