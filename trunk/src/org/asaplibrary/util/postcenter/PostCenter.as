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
package org.asaplibrary.util.postcenter {
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;

	/**			
	Send <code>navigateToURL</code> requests safely on all browsers.
	Windows Internet Explorer cannot handle <code>navigateToURL</code> messages that are sent out quickly in succession; PostCenter functions as intermediary and queues and batches requests where possible.
	If you need to sent requests from multiple places in your application it becomes a difficult task to manage the timings of these requests. It is safer to let PostCenter deal with this.
	
	<strong>Note that it is still recommended to use ExternalInterface for Flash to Javascript communication.</strong> For example, you may safely send out Javascript calls in succession (even on IE 6):
	<code>
	ExternalInterface.call("updateContent", 1);
	ExternalInterface.call("updateContent", 2);
	ExternalInterface.call("updateContent", 3);
	</code>
	@use
	<strong>Sending out a URLRequest</strong>
	This is an example from Flash Help, extended to be sent out with PostCenter:
	<code>
	// compose the request:
	var url:String = "http://www.adobe.com";
	var variables:URLVariables = new URLVariables();
	variables.exampleSessionId = new Date().getTime();
	variables.exampleUserLabel = "Your Name";
	var request:URLRequest = new URLRequest(url);
	request.data = variables;
	// send out the request:
	PostCenter.defaultPostCenter.sendRequest(request); // no window specified: will be sent to the current window
	</code>
	
	<strong>Sending out a message string</strong>
	Multiple calls to the same window are concatenated and sent as one URLRequest.
	We will use a Javascript call as example, though you preferable should use ExternalInterface for this purpose.
	<code>
	var message:String;
	var pc:PostCenter = PostCenter.defaultPostCenter;
	message = "Javascript:sendStatsOne(" + contentId + ")";
	pc.sendMessage(message);
	message = "Javascript:sendStatsTwo(" + contentId + ")";
	pc.sendMessage(message);	
	</code>
	@usageNote
	Be careful with using multiple PostCenter objects: timings are not synchronized and postings to the browser may conflict with each other. Use <code>PostCenter.defaultPostCenter</code> unless you know what you are doing!
	
	 */
	public class PostCenter extends EventDispatcher {
		/**
		The default PostCenter instance.
		 */
		private static var sDefaultPostCenter : PostCenter;
		/**
		The PostCenter identifier, used for debugging only.
		 */
		private var mName : String;
		/**
		List of objects of type {@link PostCenterMessage}.
		 */
		private var mMessages : Array = new Array;
		/**
		The number of milliseconds between postings. Note that the first messages will be sent only after {@link #FIRST_SEND_DELAY} milliseconds. 100ms is a safe interval for Internet Explorer 6.
		 */
		private static const SEND_DELAY : uint = 100;
		/**
		The number of milliseconds before the first posting.
		 */
		private static const FIRST_SEND_DELAY : uint = 10;
		/**
		Timer object to delay posting.
		 */
		private var mTimer : Timer;

		/**
		Creates a new PostCenter. Use only when you need a custom PostCenter instance. For default use, call {@link #defaultPostCenter}.
		@param inName: (optional) identifier name of this PostCenter - used for debugging
		 */
		function PostCenter(inName : String = "Anonymous PostCenter") {
			super();
			if (inName != null) {
				mName = inName;
			}
		}

		/**
		@return The default global instance of the PostCenter.
		 */
		public static function get defaultPostCenter() : PostCenter {
			if (sDefaultPostCenter == null) {
				sDefaultPostCenter = new PostCenter("Default PostCenter");
			}
			return sDefaultPostCenter;
		}

		/**
		Adds a URLRequest to the send queue. Each request will be sent after {@link #SEND_DELAY} milliseconds.
		Get notified by the send progress by subscribing to {@link PostCenterEvent#_EVENT}.
		Specify in the URLRequest if the send method should be GET or POST.
		@param inRequest: the URLRequest to send
		@param inWindow : (optional) name of the window to send message to: either the name of a specific window, or one of the following values: "_self" (the current frame in the current window), "_blank" (a new window), "_parent" (the parent of the current frame), "_top" (the top-level frame in the current window); default "_self"
		 */
		public function sendURLRequest(inRequest : URLRequest, inWindow : String = "_self") : void {
			var message : PostCenterMessage = new PostCenterMessage(inWindow, inRequest);
			mMessages.push(message);

			// process the first items with a small delay
			// so that a number of subsequent calls to send can still be combined
			if (mTimer == null) {
				initTimer(FIRST_SEND_DELAY);
			}
		}

		/**
		Adds a message to the send queue. Multiple messages to the same window get concatenated into 1 URLRequest. 
		Get notified by the send progress by subscribing to {@link PostCenterEvent#_EVENT}.
		Messages are sent out with a GET send method.
		@param inMessage : text to be sent
		@param inWindow : the window name; see {@link PostCenter#sendURLRequest}
		 */
		public function sendMessage(inMessage : String, inWindow : String = "_self") : void {
			var message : PostCenterMessage = new PostCenterMessage(inWindow, null, inMessage);
			mMessages.push(message);

			// process the first items with a small delay
			// so that a number of subsequent calls to send can still be combined
			if (mTimer == null) {
				initTimer(FIRST_SEND_DELAY);
			}
		}

		/**
		Sends out URLRequests from waiting PostCenterMessage objects.
		If {@link #sendMessage} has been used to send one or more messages, these messages are concatenated when they have the same target window, otherwise these will be sent as separate URLRequests.
		Each request is sent after {@link #SEND_DELAY} milliseconds, except for the first request that is sent after {@link #FIRST_SEND_DELAY} milliseconds.
		@param e: the timer event (unused)
		@sends PostCenterEvent#ALL_SENT
		 */
		private function processMessageQueue(e : TimerEvent = null) : void {
			resetTimer();

			if (mMessages.length == 0) {
				return;
			}

			// concatenate messages as long as the target window is the same
			var totalMessage : String = "";
			var request : URLRequest = null;
			var window : String = null;
			while (mMessages.length > 0) {
				// peek into message queue:
				if (window != null && PostCenterMessage(mMessages[0]).window != window) {
					// this is a different window than the previous one
					break;
				} else {
					var msg : PostCenterMessage = PostCenterMessage(mMessages.shift());
					if (window == null) {
						window = msg.window;
					}
					if (msg.message != null) {
						// concatenate message
						totalMessage += msg.message + ";";
					}
					if (msg.request != null) {
						request = msg.request;
						// can't concatenate - send out this one
						break;
					}
				}
			}
			if (totalMessage.length > 0 && request == null) {
				// create request
				request = new URLRequest(totalMessage);
			}
			sendRequest(request, window);
			if (mMessages.length > 0) {
				initTimer();
			}
			if (mMessages.length == 0) {
				// Notify listeners that all messages in the queue have been sent.
				dispatchEvent(new PostCenterEvent(PostCenterEvent.ALL_SENT));
			}
		}

		/**
		Sends the request to the browser.
		@param inRequest : request to be sent
		@param inWindow : the window name; see {@link #sendURLRequest}
		@sends PostCenterEvent#REQUEST_SENT
		@todo Handle errors
		 */
		private function sendRequest(inRequest : URLRequest, inWindow : String) : void {
			try {
				navigateToURL(inRequest, inWindow);
			} catch (e : Error) {
				// handle error here
			}
			dispatchEvent(new PostCenterEvent(PostCenterEvent.REQUEST_SENT, inRequest));
		}

		/**
		Stops the timer.
		 */
		private function resetTimer() : void {
			if (mTimer) mTimer.stop();
			mTimer = null;
		}

		/**
		Initializes the timer.
		 */
		private function initTimer(inDelay : uint = 0) : void {
			var delay : uint = inDelay ? inDelay : SEND_DELAY;
			mTimer = new Timer(delay, 1);
			mTimer.addEventListener(TimerEvent.TIMER, processMessageQueue);
			mTimer.start();
		}

		/**
		@exclude
		 */
		public override function toString() : String {
			return getQualifiedClassName(this) + "; name=" + mName;
		}
	}
}
import flash.net.URLRequest;

/**
Data object for PostCenter.
 */
class PostCenterMessage {
	internal var window : String;
	internal var request : URLRequest;
	internal var message : String;

	/**
	Creates a new PostCenterMessage.
	@param inWindow : the window name; see {@link PostCenter#sendURLRequest}
	@param inRequest : request to be sent
	@param inMessage : text to be sent (if inRequest is null)
	 */
	public function PostCenterMessage(inWindow : String, inRequest : URLRequest = null, inMessage : String = null) {
		window = inWindow;
		request = inRequest;
		message = inMessage;
	}
}
