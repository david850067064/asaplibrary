package org.asaplibrary.util.sound {
	import flash.events.Event;

	/**
	 * @author stephan.bezoen
	 */
	public class SoundEvent extends Event {
		public var name : String;

		public function SoundEvent(inType : String, inName : String) {
			super(inType);

			name = inName;
		}

		override public function clone() : Event {
			return new SoundEvent(type, name);
		}
	}
}
