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
	Action method to control the timed movement of a DisplayObject.
	 */
	public class AQMove {
		private var mDO : DisplayObject;
		private var mDuration : Number;
		private var mEffect : Function;
		// parameters related to properties that may have changed at the time the performing function is called
		private var mParamStartX : Number;
		private var mParamStartY : Number;
		private var mParamEndX : Number;
		private var mParamEndY : Number;
		private var mStartX : Number;
		private var mStartY : Number;
		private var mEndX : Number;
		private var mEndY : Number;

		/**
		@param inDO : DisplayObject to move
		@param inDuration : length of change in seconds; 0 is used for perpetual animations - use -1 for instant change
		@param inStartX : x value to start moving from; if NaN then inDO's current x value is used
		@param inStartY : y value to start moving from; if NaN then inDO's current y value is used
		@param inEndX : x value to start moving to; if NaN then inDO's current (dynamic) x value is used
		@param inEndY : y value to start moving to; if NaN then inDO's current (dynamic) y value is used
		@param inEffect : (optional) an effect function, for instance one of the fl.transitions.easing methods
		
		 */
		public function move(inDO : DisplayObject, inDuration : Number, inStartX : Number, inStartY : Number, inEndX : Number, inEndY : Number, inEffect : Function = null) : Function {
			mDO = inDO;
			mDuration = inDuration;
			mEffect = inEffect;

			mParamStartX = inStartX;
			mParamStartY = inStartY;
			mParamEndX = inEndX;
			mParamEndY = inEndY;

			return initDoMove;
		}

		/**
		Initializes the starting values.
		 */
		protected function initDoMove() : TimedAction {
			mStartX = (!isNaN(mParamStartX)) ? mParamStartX : mDO.x;
			mStartY = (!isNaN(mParamStartY)) ? mParamStartY : mDO.y;
			mEndX = (!isNaN(mParamEndX)) ? mParamEndX : mDO.x;
			mEndY = (!isNaN(mParamEndY)) ? mParamEndY : mDO.y;
			return new TimedAction(doMove, mDuration, mEffect);
		}

		/**
		Calculates and sets the x and y values of the DisplayObject.
		@param inValue: the percentage value ranging from 0 to 1.
		@return True (the animation will not be interrupted).
		 */
		protected function doMove(inValue : Number) : Boolean {
			mDO.x = mEndX - (inValue * (mEndX - mStartX));
			mDO.y = mEndY - (inValue * (mEndY - mStartY));
			return true;
		}
	}
}