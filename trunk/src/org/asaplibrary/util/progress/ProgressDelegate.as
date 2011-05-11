/*
Copyright 2009 by the authors of asaplibrary, http://asaplibrary.org

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
package org.asaplibrary.util.progress {
	import org.asaplibrary.util.FramePulse;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;

	/**
	 * Class for monitoring progress of objects that don't provide progress events by themselves.
	 * This class sends ProgressEvent type events when a change in the monitored class has occurred.
	 * 
	 * Use:
	 * - Create functions in the class to be monitored that provide the part and the total of the progress
	 * - Construct the delegate with these functions
	 * - Add an event listener for ProgressEvent.PROGRESS to the delegate
	 * - Call start() to start monitoring the progress, and stop() when monitoring is no longer necessary
	 * 
	 * If the parameter autoStopWhenFull is true, the delegate stops monitoring automatically when the following conditions have been met:
	 * - part is equal to total AND
	 * - both part and total are greater than zero
	 * If this automatic behaviour is insufficient, provide false as parameter to the constructor and self-regulate stopping the delegate.
	 */
	public class ProgressDelegate extends EventDispatcher implements IHasProgress {
		private var mProvidePart : Function;
		private var mProvideTotal : Function;
		private var mAutoStopWhenFull : Boolean;
		private var mCurrentPart : uint;
		private var mCurrentTotal : uint;

		/**
		 * Constructor
		 * @param inPartProvider: function that returns the loaded or played part as uint
		 * @param inTotalProvider: function that returns the total as uint
		 * @param inAutoStopWhenFull: if true, progress monitoring will stop automatically when at 100%
		 */
		public function ProgressDelegate(inPartProvider : Function, inTotalProvider : Function, inAutoStopWhenFull : Boolean = true) {
			super();

			mProvidePart = inPartProvider;
			mProvideTotal = inTotalProvider;

			mCurrentPart = mProvidePart();
			mCurrentTotal = mProvideTotal();

			mAutoStopWhenFull = inAutoStopWhenFull;
		}

		/**
		 *	Start monitoring the progress
		 */
		public function start() : void {
			FramePulse.addEnterFrameListener(monitorProgress);
		}

		/**
		 *	Stop monitoring the progress
		 */
		public function stop() : void {
			FramePulse.removeEnterFrameListener(monitorProgress);
		}

		/**
		 * Monitor the progress, send a ProgressEvent if necessary
		 */
		public function monitorProgress(e : Event = null) : void {
			var part : uint = mProvidePart();
			var total : uint = mProvideTotal();

			if ((part == mCurrentPart) && (total == mCurrentTotal)) return;

			mCurrentPart = part;
			mCurrentTotal = total;

			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, part, total));

			if (mAutoStopWhenFull && (part == total) && (part > 0)) stop();
		}

		public function addProgressHandler(inHandler : Function) : void {
			addEventListener(ProgressEvent.PROGRESS, inHandler);
		}

		public function removeProgressHandler(inHandler : Function) : void {
			removeEventListener(ProgressEvent.PROGRESS, inHandler);
		}
	}
}
