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

	// Adobe classes
	// ASAP classes
	/**
	Action method to let a DisplayObject follow the mouse pointer.
	 */
	public class AQFollowMouse {
		private var mDO : DisplayObject;
		private var mDuration : Number;
		private var mTimeDiv : Number;
		private var mLocDiv : Number;
		private var mOffsetX : Number;
		private var mOffsetY : Number;
		private var mCallBackFunction : Function;
		private var mX : Number;
		private var mY : Number;

		/**
		Lets a DisplayObject follow mouse movements. Control parameters:
		<ul>
		<li>a time variable for delay effect</li>
		<li>location variable for multiply effect</li>
		<li>offset variable for setting a fixed distance to the mouse</li>
		<li>callback function to get location feedback</li>
		</ul>
		@param inDO: DisplayObject to move
		@param inDuration: (optional) the number of seconds that the DisplayObject should move; default is 0 (infinite); use -1 for instant change
		@param inTimeDiv: (optional) the reaction speed to mouse changes. Use 1.0 to set the inDO at the mouse location without delay. Use anything between 1.0 and 0 for a slowed down effect; default is 1.0.
		@param inLocDiv : (optional) the translation factor of the mouse movements, relative to its parent's center point; an inLocDiv of 2 multiplies all x and y (difference) locations by 2. The visual effect works best if the parent has its (0,0) location at its center. The value should not be smaller than inTimeDiv (and is set automatically to the value of inTimeDiv if it is smaller); default (when nothing is set) is 1.0.
		@param inOffsetX: (optional) the number of pixels to offset the clip horizontally from the mouse
		@param inOffsetY: (optional) the number of pixels to offset the clip vertically from the mouse
		@param inCallBackFunction: (optional) function reference to which the calculated value will be returned; this callback function passes 3 arguments: (DO, x, y )
		@return A reference to {@link #initDoFollowMouse} that in turn returns the performing move {@link TimedAction}.
		 */
		public function followMouse(inDO : DisplayObject, inDuration : Number = Number.NaN, inTimeDiv : Number = Number.NaN, inLocDiv : Number = Number.NaN, inOffsetX : Number = Number.NaN, inOffsetY : Number = Number.NaN, inCallBackFunction : Function = null) : Function {
			mDO = inDO;
			mDuration = inDuration;

			mTimeDiv = !isNaN(inTimeDiv) ? inTimeDiv : 1.0;
			mLocDiv = !isNaN(inLocDiv) ? inLocDiv : 1.0;

			// correction against artifacts (x, y flipflopping to negative values):
			if (mLocDiv < mTimeDiv) mLocDiv = mTimeDiv;

			mOffsetX = !isNaN(inOffsetX) ? inOffsetX : 0;
			mOffsetY = !isNaN(inOffsetY) ? inOffsetY : 0;
			mCallBackFunction = inCallBackFunction;

			return initDoFollowMouse;
		}

		/**
		Initializes the starting values.
		 */
		protected function initDoFollowMouse() : TimedAction {
			mX = mDO.x;
			mY = mDO.y;
			return new TimedAction(doFollowMouse, mDuration, null);
		}

		/**
		Calculates and sets the position of the DisplayObject. If a callback function is set: calls the callback function with parameters (DO, x, y).
		@param inValue: the percentage value, dependent on the duration of the animation
		@return True (the animation will not be interrupted).
		 */
		protected function doFollowMouse(inValue : Number) : Boolean {
			mX -= ( (1 / mLocDiv) * (mX - mOffsetX) - mDO.parent.mouseX) * mTimeDiv;
			mY -= ( (1 / mLocDiv) * (mY - mOffsetY) - mDO.parent.mouseY) * mTimeDiv;
			if (mCallBackFunction != null) {
				mCallBackFunction(mDO, mX, mY);
			} else {
				mDO.x = mX;
				mDO.y = mY;
			}
			return true;
		}
	}
}
