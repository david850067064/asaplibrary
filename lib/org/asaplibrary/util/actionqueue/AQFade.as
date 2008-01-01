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
	
	/**
	Action method to control the timed fading of a DisplayObject.
	*/
	public class AQFade {
	
		private var mDO:DisplayObject;
		private var mDuration:Number;
		private var mEffect:Function;

		// parameters related to properties that may have changed at the time the performing function is called
		private var mParamStartAlpha:Number;
		private var mParamEndAlpha:Number;
		
		private var mStartAlpha:Number;
		private var mEndAlpha:Number;
		
		/**
		
		*/
		public function fade (inDO:DisplayObject, inDuration:Number, inStartAlpha:Number, inEndAlpha:Number, inEffect:Function = null) : Function {
			mDO = inDO;
			mDuration = inDuration;
			mEffect = inEffect;

			mParamStartAlpha = inStartAlpha;
			mParamEndAlpha = inEndAlpha;
			
			// return the function that will be called by ActionRunner
			return initDoFade;
		}
		
		/**
		
		*/
		protected function initDoFade () : TimedAction {
			mStartAlpha = (!isNaN(mParamStartAlpha)) ? mParamStartAlpha : mDO.alpha;
			mEndAlpha = (!isNaN(mParamEndAlpha)) ? mParamEndAlpha : mDO.alpha;
			return new TimedAction(doFade, mDuration, mEffect);
		}

		/**

		*/
		protected function doFade (inValue:Number) : Boolean {
			mDO.alpha = mEndAlpha - (inValue * (mEndAlpha - mStartAlpha));
			return true;
		}
		
	}
}
