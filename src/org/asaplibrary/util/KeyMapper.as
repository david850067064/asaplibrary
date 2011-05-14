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
package org.asaplibrary.util {
	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	/**
	 * Class for directly coupling Keyboard events to actions, without having to bother about event filtering
	 * 
	 * @use:
	 * <code>
	mKeyMapper = new KeyMapper(LocalController.globalStage);
	mKeyMapper.setMapping(Keyboard.ENTER, submit, KeyboardEvent.KEY_UP);
	mKeyMapper.setMapping(Keyboard.ESCAPE, cancel, KeyboardEvent.KEY_UP);
	mKeyMapper.setMapping(Keyboard.KEY_UP, moveUp, null, true);	// event type defaults to KEY_DOWN when null; the function moveUp receives the KeyboardEvent event when called
	 * </code>
	 * Make sure to clean up when you're done:
	 * <code>
	 * mKeyMapper.die();
	 * </code>
	 */
	public class KeyMapper {
		private var mKeyDownMap : Object = new Object();
		private var mKeyUpMap : Object = new Object();
		private var mStage : Stage;

		/**
		 *	Constructor
		 *	@param inStage: a valid Stage type object
		 */
		public function KeyMapper(inStage : Stage) {
			mStage = inStage;

			mStage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDownEvent);
			mStage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUpEvent);
		}

		/**
		 *	Map a key to a handler function for a specific event (key up or down), optionally passing the event itself
		 *	@param inKey: see Keyboard class for possible values
		 *	@param inHandler: function to be called when the key is pressed or released; by default called without parameters
		 *	@param inEventType: specify KeyboardEvent.KEY_UP for key-up events (default), or KeyboardEvent.KEY_DOWN for key-down events
		 *	@param inSendEvent: when true, the KeyboardEvent event is passed to the handler function
		 */
		public function setMapping(inKey : uint, inHandler : Function, inEventType : String, inSendEvent : Boolean = false) : void {
			var map : Object = (inEventType == KeyboardEvent.KEY_UP) ? mKeyUpMap : mKeyDownMap;

			map[inKey] = new KeyData(inHandler, inSendEvent);
		}

		/**
		 *	Cleanup objects and event handlers
		 */
		public function die() : void {
			mKeyDownMap = null;
			mKeyUpMap = null;

			mStage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDownEvent);
			mStage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyUpEvent);
		}

		private function handleKeyDownEvent(e : KeyboardEvent) : void {
			if (mKeyDownMap[e.keyCode]) (mKeyDownMap[e.keyCode] as KeyData).handle(e);
		}

		private function handleKeyUpEvent(e : KeyboardEvent) : void {
			if (mKeyUpMap[e.keyCode]) (mKeyUpMap[e.keyCode] as KeyData).handle(e);
		}
	}
}
import flash.events.KeyboardEvent;

class KeyData {
	public var handler : Function;
	public var doSendEvent : Boolean;

	public function KeyData(inHandler : Function, inSendEvent : Boolean) {
		handler = inHandler;
		doSendEvent = inSendEvent;
	}

	public function handle(e : KeyboardEvent) : void {
		if (doSendEvent) handler(e);
		else handler();
	}
}
