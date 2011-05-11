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
	Action method that controls the relative position of a DisplayObject.
	Lets a DisplayObject move a specified number of pixels added to its current location, without specifying its end location.
	 */
	public class AQAddMove {
		private var mDO : DisplayObject;
		private var mDuration : Number;
		private var mEffect : Function;
		// parameters related to properties that may have changed at the time the performing function is called
		private var mParamAddX : Number;
		private var mParamAddY : Number;
		private var mTravelledX : Number;
		private var mTravelledY : Number;

		/**
		@param inDO : DisplayObject to move
		@param inDuration : length of change in seconds; 0 is used for perpetual animations - use -1 for instant change
		@param inAddX : the horizontal distance in pixels to move the DisplayObject
		@param inAddX : the vertical distance in pixels to move the DisplayObject
		@param inEffect : (optional) an effect function, for instance one of the fl.transitions.easing methods
		@return A reference to {@link #initAddMove} that in turn returns the performing move {@link TimedAction}.
		 */
		public function addMove(inDO : DisplayObject, inDuration : Number, inAddX : Number, inAddY : Number, inEffect : Function = null) : Function {
			mDO = inDO;
			mDuration = inDuration;
			mEffect = inEffect;

			mParamAddX = inAddX;
			mParamAddY = inAddY;

			return initAddMove;
		}

		/**
		Initializes the starting values.
		 */
		protected function initAddMove() : TimedAction {
			mTravelledX = 0;
			mTravelledY = 0;
			return new TimedAction(doAddMove, mDuration, mEffect);
		}

		/**
		Calculates and sets the x and y values of the DisplayObject.
		@param inValue: the percentage value ranging from 0 to 1.
		@return True (the animation will not be interrupted).
		 */
		protected function doAddMove(inValue : Number) : Boolean {
			var targetX : Number = (1 - inValue) * mParamAddX;
			var targetY : Number = (1 - inValue) * mParamAddY;
			mDO.x += (targetX - mTravelledX);
			mDO.y += (targetY - mTravelledY);
			mTravelledX = targetX;
			mTravelledY = targetY;
			return true;
		}
	}
}
