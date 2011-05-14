package demo.Form.controller {
	import flash.events.Event;
	
	/**
	 * @author eric-paul.lecluse
	 */
	public class AssetEvent extends Event {
		public static const _EVENT:String = "assetManagerEvent";
		public static const START : String = "load start";
		public static const PROGRESS:String = "load progress";
		public static const COMPLETE:String = "finished loading";
		public static const ERROR:String = "error loading";
		public static const ALL_COMPLETE : String = "all assets finished loading";
		
		public var subtype:String;
		public var name: String;
		public var loadedBytesCount: Number;
		public var totalBytesCount: Number;

		public function AssetEvent(inSubtype : String, inName:String) {
			super(_EVENT);
			
			subtype = inSubtype;
			name = inName;
		}
	}
}
