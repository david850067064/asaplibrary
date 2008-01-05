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

	import flash.events.Event;
	
	/**
	Event object sent by {@link PostCenter}. Subscribe to type <code>_EVENT</code>.
	*/
	public class PostCenterEvent extends Event {

		/** Event type. */
		public static const _EVENT:String = "onPostCenterEvent";
	
		public static const MESSAGE_SENT:String = "messageSent";
		public static const ALL_SENT:String = "allSent";

		public var subtype:String;
		public var message:String;
		
		/**
		Creates a new PostCenterEvent.
		@param inSubtype: either subtype; see above
		*/
		public function PostCenterEvent (inSubtype:String, inMessage:String = null) {
			super(_EVENT);
			
			subtype = inSubtype;
			message = inMessage;
		}
		
		public override function toString ():String {
			return ";org.asaplibrary.util.postcenter.PostCenter; subtype=" + subtype + "; message=" + message;
		}
		
		/**
		Creates a copy of an existing PostCenterEvent.
		*/
		public override function clone() : Event {
			return new PostCenterEvent(subtype, message);
		} 
	}
}