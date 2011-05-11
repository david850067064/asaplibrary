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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	Class to generate onEnterFrame events.
	@usage
	<code>	
	FramePulse.addEnterFrameListener(handleEnterFrame);
	
	// function that handles onEnterFrame events
	public function handleEnterFrame (e:Event) : void {
		
	// code goes here...
	}
	</code>
	To stop receiving the onEnterFrame event:
	<code>
	FramePulse.removeEnterFrameListener(handleEnterFrame);
	</code>
	 */
	public class FramePulse extends EventDispatcher {
		private static var sSprite : Sprite = null;

		/**
		Add a listener to the FramePulse
		@param inHandler: function to be called on enterframe, with parameter FramePulseEvent
		 */
		public static function addEnterFrameListener(inHandler : Function) : void {
			if (sSprite == null) {
				sSprite = new Sprite();
			}
			sSprite.addEventListener(Event.ENTER_FRAME, inHandler);
		}

		/**
		Remove a listener from the FramePulse
		@param inHandler: function that was previously added
		 */
		public static function removeEnterFrameListener(inHandler : Function) : void {
			if (sSprite != null) {
				sSprite.removeEventListener(Event.ENTER_FRAME, inHandler);
			}
		}
	}
}