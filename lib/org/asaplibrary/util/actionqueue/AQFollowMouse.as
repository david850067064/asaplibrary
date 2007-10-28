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

	// Adobe classes
	import flash.display.DisplayObject;
	
	// ASAP classes
	import org.asaplibrary.util.actionqueue.*;
		
	public class AQFollowMouse {
		
		private var mDO:DisplayObject;
		private var mDuration:Number;
		
		private var mTimeDiv:Number;
		private var mLocDiv:Number;
		private var mOffsetX:Number;
		private var mOffsetY:Number;
		private var mCallbackObject:Object;
		private var mCallBackMethod:Function;
		
		private var mX:Number;
		private var mY:Number;
				
		public function followMouse (inDO:DisplayObject,
									 inDuration:Number = Number.NaN,
									 inTimeDiv:Number = Number.NaN,
									 inLocDiv:Number = Number.NaN,
									 inOffsetX:Number = Number.NaN,
									 inOffsetY:Number = Number.NaN,
									 inCallbackObject:Object = null,
									 inCallBackMethod:Function = null) : Function {
	
			mDO = inDO;
			mDuration = inDuration;
			
			mTimeDiv = !isNaN(inTimeDiv) ? inTimeDiv : 1.0;
			mLocDiv = !isNaN(inLocDiv) ? inLocDiv : 1.0;
			
			// correction against artifacts (x, y flipflopping to negative values):
			if (mLocDiv < mTimeDiv) mLocDiv = mTimeDiv;

			mOffsetX = !isNaN(inOffsetX) ? inOffsetX : 0;
			mOffsetY = !isNaN(inOffsetY) ? inOffsetY : 0;
			mCallbackObject = inCallbackObject;
			mCallBackMethod = inCallBackMethod;
			
			return initDoFollowMouse;
		}
		
		/**
		
		*/
		protected function initDoFollowMouse () : TimedAction {
			mX = mDO.x;
			mY = mDO.y;
			return new TimedAction(this, doFollowMouse, mDuration, null);
		}
		
		/**

		*/
		protected function doFollowMouse (inValue:Number) : Boolean {
			mX -= ( (1 / mLocDiv) * (mX - mOffsetX) - mDO.parent.mouseX) * mTimeDiv;
			mY -= ( (1 / mLocDiv) * (mY - mOffsetY) - mDO.parent.mouseY) * mTimeDiv;
			if (mCallBackMethod != null) {
				mCallBackMethod.call( mCallbackObject, mDO, mX, mY );
			} else {
				mDO.x = mX;
				mDO.y = mY;
			}
			return true;
		}
		
	}
}
