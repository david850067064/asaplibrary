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
package org.asaplibrary.util.debug {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	Event object sent by {@link Log}. Subscribe to type <code>_EVENT</code>.
	 */
	public class LogEvent extends Event {
		/** Event type. */
		public static const _EVENT : String = "onLogEvent";
		public var level : String;
		public var text : String;
		public var sender : String;

		/**
		Creates a new LogEvent.
		
		 */
		public function LogEvent(inLevel : String, inText : String, inSender : String) {
			super(_EVENT);

			level = inLevel;
			text = inText;
			sender = inSender;
		}

		public override function toString() : String {
			return getQualifiedClassName(this) + ": level=" + level + "; text=" + text + "; sender=" + sender;
		}

		/**
		Creates a copy of an existing LogEvent.
		 */
		public override function clone() : Event {
			return new LogEvent(level, text, sender);
		}
	}
}