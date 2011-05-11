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
	Action method to control the timed blinking (making more or less visible) of a DisplayObject.
	Options are:
	<ul>
	<li>Blinking an individual object by periodically setting its alpha values; this makes it possible to let a DisplayObject blink while be visible at the same time</li>
	<li>Showing and hiding a group of objects by moving their mask clip (this sets the visibility; no alpha values)</li>
	</ul>	
	 */
	public class AQBlink extends AQBaseSinusoid {
		public static var MASK_OFFSCREEN_X : Number = -9999;
		// mask blink parameters
		private var mPosX : Number;
		private var mHideAtStart : Boolean;

		/**
		Lets a DisplayObject blink (toggle between 2 alpha values).
		@param inDO : DisplayObject to blink
		@param inCount : the number of times the object should blink (the number of cycles, where each cycle is a full sine curve)
		@param inFrequency : number of blinks per second
		@param inMaxAlpha : the highest alpha when blinking; when no value is passed the current inDO's current alpha is used
		@param inMinAlpha : the lowest alpha when blinking; when no value is passed the current inDO's current alpha is used
		@param inStartAlpha : (optional) the starting alpha; if not given, a calculated middle value is used. The resulting starting alpha depends on the position of that value on a sine curve.
		@param inDuration : (optional: pass either inDuration or inCount - if inDuration is given, inCount will be ignored) length of blinking in seconds; when 0, blinking is infinite, otherwise the movement will be stopped as soon as the duration has passed; in seconds
		@param inEffect : (optional) an effect function, for instance one of the fl.transitions.easing methods
		@return A reference to {@link #initDoBlink} that in turn returns the performing blink {@link TimedAction}.
		@example
		This code will let a shape blink 4 times with a frequency of 2 blinks per second, with a max alpha of 1 and a min alpha of 0.1, starting out with min alpha:
		<code>
		var queue:ActionQueue = new ActionQueue();
		queue.addAction(new AQBlink().blink(shape, 4, 2, 1, .1, .1));
		queue.run();
		</code>
		This code will do the same, but for a duration of 2 seconds:
		<code>
		var queue:ActionQueue = new ActionQueue();
		queue.addAction(new AQBlink().blink(shape, 4, 2, 1, .1, .1, 2));
		queue.run();
		</code>
		 */
		public function blink(inDO : DisplayObject, inCount : int, inFrequency : Number, inMaxAlpha : Number, inMinAlpha : Number, inStartAlpha : Number = Number.NaN, inDuration : Number = Number.NaN, inEffect : Function = null) : Function {
			mDO = inDO;
			mCount = inCount;
			mFrequency = inFrequency;
			mDuration = inDuration;
			mEffect = inEffect;

			mParamMinValue = inMinAlpha;
			mParamMaxValue = inMaxAlpha;
			mParamStartValue = inStartAlpha;

			mPerformFunction = doBlink;
			// return the function that will be called by ActionRunner
			return initDoBlink;
		}

		/**
		Initializes the starting values.
		 */
		protected function initDoBlink() : TimedAction {
			mMaxValue = (!isNaN(mParamMaxValue)) ? mParamMaxValue : mDO.alpha;
			mMinValue = (!isNaN(mParamMinValue)) ? mParamMinValue : mDO.alpha;
			return super.init();
		}

		/**
		Calculates and sets the alpha value of the DisplayObject.
		@param inValue: the percentage value for each sine cycle, ranging from 0 to 1.
		@return True (the animation will not be interrupted).
		 */
		protected function doBlink(inValue : Number) : Boolean {
			var amplitude : Number = Math.sin(inValue * 2 * Math.PI + mPIOffset);
			mDO.alpha = (amplitude > 0) ? mMaxValue : mMinValue;
			return true;
		}

		/**
		When you have multiple objects that should simply be hidden while blinking, a simple solution is to use a mask and put all objects under the mask. Then you only have to control the mask to set the visibility of its contents. But masks cannot be given an alpha value, so you cannot use {@link #blink}. <code>maskBlink</code> moves the mask off screen (x position to {@link #MASK_OFFSCREEN_X}).
		@param inDO : the mask to move back and forth with a blinking frequency
		@param inCount : the number of times the object should blink (the number of cycles, where each cycle is a full sine curve)
		@param inFrequency : number of blinks per second
		@param inHideAtStart : (optional) if true the blinking starts with the object set to invisible; if false it starts with the object set to visible; default is true (visible)
		@param inDuration : (optional: pass either inDuration or inCount - if inDuration is given, inCount will be ignored) length of blinking in seconds; when 0, blinking is infinite, otherwise the movement will be stopped as soon as the duration has passed; in seconds
		@param inEffect : (optional) an effect function, for instance one of the fl.motion.easing methods
		@return A reference to {@link #initDoMaskBlink} that in turn returns the performing mask blink {@link TimedAction}.
		@example
		This code shows and hides a mask object for 2 seconds (count of 4 will be ignored) with frequency of 4 per second, starting out visible:
		<code>
		var queue:ActionQueue = new ActionQueue();
		queue.addAction( new AQBlink().maskBlink(shape, 4, 1, true, 2 ));
		queue.run();
		</code>
		 */
		public function maskBlink(inDO : DisplayObject, inCount : int, inFrequency : Number, inHideAtStart : Boolean = true, inDuration : Number = Number.NaN, inEffect : Function = null) : Function {
			mDO = inDO;
			mCount = inCount;
			mFrequency = inFrequency;
			mDuration = inDuration;
			mEffect = inEffect;

			mPosX = inDO.x;
			mHideAtStart = inHideAtStart;

			// return the function that will be called by ActionRunner
			return initDoMaskBlink;
		}

		/**
		Initializes the starting values.
		 */
		protected function initDoMaskBlink() : TimedAction {
			mPIOffset = 0;
			if (mHideAtStart) {
				mPIOffset = -Math.PI;
			}

			var cycleDuration : Number = 1.0 / mFrequency;
			// in seconds

			var frameAction : TimedAction = new TimedAction(doMaskBlink, cycleDuration, mEffect);
			var loopCount : uint = calculateLoopCount(mCount, mDuration, cycleDuration);
			frameAction.setLoop(true);
			// loops loopCount or infinite if mDuration == 0
			frameAction.setLoopCount(loopCount);

			return frameAction;
		}

		/**
		Calculates and sets the x position of the mask.
		@param inValue: the percentage value for each sine cycle, ranging from 0 to 1.
		@return True (the animation will not be interrupted).
		 */
		protected function doMaskBlink(inValue : Number) : Boolean {
			var amplitude : Number = Math.sin(inValue * 2 * Math.PI + mPIOffset);
			mDO.x = (amplitude > 0) ? MASK_OFFSCREEN_X : mPosX;
			return true;
		}
	}
}