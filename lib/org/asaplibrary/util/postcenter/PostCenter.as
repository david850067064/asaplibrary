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

package org.asaplibrary.util.postcenter {

	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	import flash.events.EventDispatcher;

	/**
	Send messages safely and cross-browser from Flash to HTML/Javascript.
	Windows Internet Explorer cannot handle <code>navigateToURL</code> messages that are sent quickly in succession; PostCenter functions as intermediary and queues and batches messages where possible.
	If you need to sent messages from multiple places in your application it becomes a difficult task to manage the timings of these messages. It is safer to let PostCenter deal with this.
	@use
	<code>
	var message:String;
	var pc:PostCenter = PostCenter.defaultPostCenter;
	message = "javascript:sendStatsOne(" + contentId + ")";
	pc.send(message);
	message = "javascript:sendStatsTwo(" + contentId + ")";
	pc.send(message);	
	</code>
	@usageNote
	Calls to the same window are concatenated and sent as one string.
	For example:
	<code>
	var message:String;
	var pc:PostCenter = PostCenter.defaultPostCenter;
	message = "javascript:sendStatsOne(" + contentId + ")";
	pc.send(message); // is sent to default window "_self"
	message = "javascript:sendStatsTwo(" + contentId + ")";
	pc.send(message); // is appended to the first message
	</code>
	These 2 messages are sent together. A subsequent call to a different window will be sent after a delay:
	<code>
	message = "javascript:notifyFrameLocation(" + contentId + ")";
	pc.send(message, "_top");
	</code>
	@usageNote
	Be careful with using multiple PostCenter objects: timings are not synchronized and postings to the browser may conflict with each other. Use <code>PostCenter.defaultPostCenter</code> unless you know what you are doing!
	@todo PostCenter currently ignores the parameter 'method' ("GET" or "POST").
	*/
	public class PostCenter extends EventDispatcher {

		private static var sDefaultPostCenter:PostCenter;

		private var mName:String;

		/**
		List of objects of type {@link PostCenterMessage}.
		*/
		private var mMessages:Array = new Array;

		/**
		The number of milliseconds between postings. Note that the first messages will be sent after {@link #FIRST_SEND_DELAY} milliseconds.
		*/
		private static const SEND_DELAY:uint = 50;

		/**
		The number of milliseconds before the first posting.
		*/
		private static const FIRST_SEND_DELAY:uint = 20;

		/**
		Timer object to delay posting.
		*/
		private var mTimer:Timer;

		/**
		Callback function, called after posting the message; used for debugging.
		*/
		private var mCallback:Function;

		/**
		Creates a new PostCenter. Use only when you need a custom PostCenter instance. For default use, call {@link #defaultPostCenter}.
		@param inName: (optional) identifier name of this PostCenter - used for debugging
		*/
		function PostCenter(inName:String = "Anonymous PostCenter") {
			super();
			if (inName != null) {
				mName = inName;
			}
		}

		/**
		@return The default global instance of the PostCenter.
		*/
		public static function get defaultPostCenter():PostCenter {
			if (sDefaultPostCenter == null) {
				sDefaultPostCenter = new PostCenter("Default PostCenter");
			}
			return sDefaultPostCenter;
		}

		/**
		Adds a message to the send queue. Get notified by the send progress by subscribing to {@link PostCenterMessage#_EVENT}.
		@param inMessage : text to be sent
		@param inWindow : (optional) name of the window to send message to: either the name of a specific window, or one of the following values: "_self" (the current frame in the current window), "_blank" (a new window), "_parent" (the parent of the current frame), "_top" (the top-level frame in the current window); default "_self"
		@example
		The following code sends a message to call a javascript function <code>sendStats</code> with parameter <code>myId</code> to window "_self":
		<code>
		PostCenter.defaultPostCenter.send("javascript:sendStats('" + myId + "')"), "_self");
		</code>
		*/
		public function send(inMessage:String, inWindow:String = "_self"):void {
			var message:PostCenterMessage = new PostCenterMessage(inMessage, inWindow);
			mMessages.push(message);
			
			// process the first items with a small delay
			// so that a number of subsequent calls to send can still be combined
			if (mTimer == null) {
				initTimer(FIRST_SEND_DELAY);
			}
		}

		/**
		Creates a send string from waiting PostCenterMessage objects.
		@param e: the timer event
		*/
		private function processMessageQueue(e:TimerEvent = null):void {
			resetTimer();
			
			if (mMessages.length == 0) {
				return;
			}
			
			// concatenate messages as long as the target window is the same
			var outText:String = "";
			var window:String = null;
			while (mMessages.length > 0) {
				// peek into message queue:
				if (window != null && mMessages[0].window != window) {
					// this is a different window than the previous one
					break;
				} else {
					var msg:PostCenterMessage = PostCenterMessage(mMessages.shift());
					if (window == null) {
						window = msg.window;
					}
					// concatenate message
					outText += msg.message + ";";
				}
			}
			if (outText.length > 0) {
				sendMessage(outText, window);
			}
			if (mMessages.length > 0) {
				initTimer();
			}
			if (mMessages.length == 0) {
				notifyAllSent();
			}
		}

		/**
		Sends the message to the browser.
		@param inMessage : text to be sent
		@param inWindow : the window name; see {@link #send}
		@sends PostCenterEvent#MESSAGE_SENT
		*/
		private function sendMessage(inMessage:String, inWindow:String):void {
			navigateToURL(new URLRequest(inMessage), inWindow);
			dispatchEvent(new PostCenterEvent(PostCenterEvent.MESSAGE_SENT, inMessage));
		}

		/**
		Notifies listeners that all messages in the queue have been sent.
		@sends PostCenterEvent#ALL_SENT
		*/
		private function notifyAllSent () : void {
			dispatchEvent(new PostCenterEvent(PostCenterEvent.ALL_SENT));
		}
		
		/**
		Stops the timer.
		*/
		private function resetTimer():void {
			if (mTimer) mTimer.stop();
			mTimer = null;
		}

		/**
		Initializes the timer.
		*/
		private function initTimer(inDelay:uint = 0):void {
			var delay:uint = inDelay ? inDelay : SEND_DELAY;
			mTimer = new Timer(delay, 1);
			mTimer.addEventListener(TimerEvent.TIMER, processMessageQueue);
			mTimer.start();
		}

		public override function toString():String {
			return "com.lostboys.util.postcenter.PostCenter; name=" + mName;
		}
	}
}

/**
Data object for PostCenter.
*/
class PostCenterMessage {

	internal var message:String;
	internal var window:String;

	/**
	Creates a new PostCenterMessage.
	@param inMessage : text to be sent
	@param inWindow : the window name; see {@link PostCenter#send}
	 */
	public function PostCenterMessage( inMessage:String, inWindow:String) {
		message = inMessage;
		window = inWindow;
	}
}