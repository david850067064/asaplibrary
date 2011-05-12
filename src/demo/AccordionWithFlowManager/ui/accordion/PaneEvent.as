package demo.AccordionWithFlowManager.ui.accordion {
	import flash.events.Event;	

	public class PaneEvent extends Event {
	
		public static const _EVENT:String = "paneEvent";
		public static const UPDATE:String = "paneUpdate";
		public static const CHANGE:String = "paneChange";
		public static const CLOSED:String = "paneClosed";
		
		public var pane:Pane;
		public var subtype:String;
		
		function PaneEvent(inSubtype:String, inPane:Pane) {
			super(_EVENT);
			subtype = inSubtype;
			pane = inPane;
		}
		
		public override function toString () : String {
			return "ui.accordion.PaneEvent: subtype=" + subtype + "; pane=" + pane;
		}
		
		public override function clone () : Event {
			return new PaneEvent(subtype, pane);
		}
	
	}
}