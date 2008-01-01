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
	
	public class AQAddMove {
	
		private var mDO:DisplayObject;
		private var mDuration:Number;
		private var mEffect:Function;
		
		// parameters related to properties that may have changed at the time the performing function is called
		private var mParamAddX:Number;
		private var mParamAddY:Number;
		
		private var mTravelledX:Number;
		private var mTravelledY:Number;
		
		public function addMove (inDO:DisplayObject, inDuration:Number, inAddX:Number, inAddY:Number, inEffect:Function = null) : Function {
			
			mDO = inDO;
			mDuration = inDuration;
			mEffect = inEffect;
			
			mParamAddX = inAddX;
			mParamAddY = inAddY;
			
			return initAddMove;
		}
		
		protected function initAddMove() : TimedAction {
			mTravelledX = 0;
			mTravelledY = 0;
			return new TimedAction(doAddMove, mDuration, mEffect);
		}
		
		/**

		*/
		protected function doAddMove (inValue:Number) : Boolean {
			var targetX:Number = (1-inValue) * mParamAddX;
			var targetY:Number = (1-inValue) * mParamAddY;
			mDO.x += (targetX - mTravelledX);
			mDO.y += (targetY - mTravelledY);
			mTravelledX = targetX;
			mTravelledY = targetY;
			return true;
		}
	}
}
