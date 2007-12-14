package org.asaplibrary.data.xml {
	import flash.events.Event;
	
	/**
	 * @author stephan
	 */
	public class ServiceEvent extends Event {
		/** Generic type of event */
		public static const _EVENT:String = "onServiceEvent";
		
		/** subtype of event sent when loading and parsing went ok */
		public static const COMPLETE:String = "loadComplete";
		/** subtype of event sent when there was an error loading the data */
		public static var LOAD_ERROR:String = "loadError";
		/** subtype of event sent when there was an error parsing the data */
		public static var PARSE_ERROR:String = "parseError";
		
		/** subtype of event */
		public var subtype:String;
		/** name of original request*/
		public var name:String;
		/** if applicable, a single array of typed data objects */
		public var list:Array;
		/** if applicable, a single object */
		public var object:Object;
		/** if applicable, a string describing the error */
		public var error:String;
	
		
		public function ServiceEvent(inSubtype : String, inName:String = null, inList:Array = null, inObject:Object = null, inError:String = null) {
			super(_EVENT);
			
			subtype = inSubtype;
			name = inName;
			list = inList;
			object = inObject;
			error = inError;
		}

		override public function clone () : Event {
			return new ServiceEvent(subtype, name, list, object, error);
		}
		
		override public function toString() : String {
			return "org.asaplibrary.data.xml.ServiceEvent: subtype = " + subtype + ", name = " + name;
		}
	}
}
