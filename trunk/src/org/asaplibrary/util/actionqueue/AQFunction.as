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
	Action method to call a function repeatedly over time, with a changing numeric value.
	 */
	public class AQFunction {
		private var mCallFunction : Function;
		private var mDuration : Number;
		private var mStartValue : Number;
		private var mEndValue : Number;
		private var mEffect : Function;

		/**
		Calls function inCallFunction over a period of time, with a start value changing to an end value. The function should accept 1 numeric value. 
		@param inCallFunction: function to call
		@param inDuration : length of change in seconds; 0 is used for perpetual animations - use -1 for instant change
		@param inStartValue : the start value to call inCallFunction with
		@param inEndValue : the end value to call inCallFunction with
		@param inEffect : (optional) an effect function, for instance one of the fl.transitions.easing methods
		@return A reference to {@link #initDoCall} that in turn returns the performing call {@link TimedAction}.
		@example
		This queue calls function <code>setHeight</code> for a duration of 2 seconds with a value between <code>getCurrentHeight()</code> and the projected <code>tContent.height</code>. If no effect is applied, <code>setHeight</code> will be half the projected height at 1 second:
		<code>
		var queue:ActionQueue = new ActionQueue();
		queue.addAction(new AQFunction().call(setHeight, 2.0, getCurrentHeight(), tContent.height));
		queue.run();
		</code>
		 */
		public function call(inCallFunction : Function, inDuration : Number, inStartValue : Number, inEndValue : Number, inEffect : Function = null) : Function {
			mCallFunction = inCallFunction;
			mDuration = inDuration;
			mStartValue = inStartValue;
			mEndValue = inEndValue;
			mEffect = inEffect;
			// return the function that will be called by ActionRunner
			return initDoCall;
		}

		/**
		
		 */
		protected function initDoCall() : TimedAction {
			return new TimedAction(doCall, mDuration, mEffect);
		}

		/**

		 */
		protected function doCall(inValue : Number) : Boolean {
			var value : Number = percentageValue(mStartValue, mEndValue, 1 - inValue);
			mCallFunction(value);
			return true;
		}

		/**
		Internal utility function. Calculates the value of a continuum between start and end given a percentage position.
		 */
		protected function percentageValue(inStart : Number, inEnd : Number, inPercentage : Number) : Number {
			return inStart + (inPercentage * (inEnd - inStart));
		}

		private var mCallStartValueFunction : Function;

		/**
		Like {@link #call}, but the start value is now being looked up just before the action starts (using inCallStartValueFunction).
		@param inCallFunction: function to call
		@param inDuration : length of change in seconds; 0 is used for perpetual animations - use -1 for instant change
		@param inCallStartValueFunction : the function that will return the the start value to call inCallFunction with
		@param inEndValue : the end value to call inCallFunction with
		@param inEffect : (optional) an effect function, for instance one of the fl.motion.easing methods
		 */
		public function callDynamic(inCallFunction : Function, inDuration : Number, inCallStartValueFunction : Function, inEndValue : Number, inEffect : Function = null) : Function {
			mCallFunction = inCallFunction;
			mDuration = inDuration;
			mCallStartValueFunction = inCallStartValueFunction;
			mEndValue = inEndValue;
			mEffect = inEffect;
			// return the function that will be called by ActionRunner
			return initDoCallDynamic;
		}

		/**
		
		 */
		protected function initDoCallDynamic() : TimedAction {
			mStartValue = mCallStartValueFunction();
			return new TimedAction(doCall, mDuration, mEffect);
		}
	}
}
