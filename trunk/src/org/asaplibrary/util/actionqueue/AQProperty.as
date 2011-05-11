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
	/**
	Action method to control an object's property over time.
	 */
	public class AQProperty {
		private var mObject : Object;
		private var mProperty : String;
		private var mDuration : Number;
		private var mEffect : Function;
		// parameters related to properties that may have changed at the time the performing function is called
		private var mParamStartValue : Number;
		private var mParamEndValue : Number;
		private var mStartValue : Number;
		private var mEndValue : Number;

		/**
		@param inObject : object to change; this may be a DisplayObject or any other object
		@param inProperty : name of property (in inObject) that will be affected; for instance "x" for the x position of a DisplayObject
		@param inDuration : length of change in seconds; 0 is used for perpetual animations - use -1 for instant change
		@param inStartValue : (optional) the starting value of inProperty; if NaN the current object value will be used
		@param inEndValue : (optional) the end value of inProperty; if NaN the current object value will be used
		@param inEffect : (optional) an effect function, for instance one of the fl.motion.easing methods
		@return A reference to {@link #initDoChange} that in turn returns the performing change {@link TimedAction}.
		 */
		public function change(inObject : Object, inProperty : String, inDuration : Number, inStartValue : Number = NaN, inEndValue : Number = NaN, inEffect : Function = null) : Function {
			mObject = inObject;
			mProperty = inProperty;
			mDuration = inDuration;
			mEffect = inEffect;

			mParamStartValue = inStartValue;
			mParamEndValue = inEndValue;

			// return the function that will be called by ActionRunner
			return initDoChange;
		}

		/**
		Initializes the starting values.
		 */
		protected function initDoChange() : TimedAction {
			mStartValue = (!isNaN(mParamStartValue)) ? mParamStartValue : mObject[mProperty];
			mEndValue = (!isNaN(mParamEndValue)) ? mParamEndValue : mObject[mProperty];
			return new TimedAction(doChange, mDuration, mEffect);
		}

		/**
		Calculates and sets the property value of the DisplayObject.
		@param inValue: the percentage value ranging from 0 to 1.
		@return True (the animation will not be interrupted).
		 */
		protected function doChange(inValue : Number) : Boolean {
			mObject[mProperty] = mEndValue - (inValue * (mEndValue - mStartValue));
			return true;
		}
	}
}
