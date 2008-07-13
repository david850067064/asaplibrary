package controller {

	import flash.events.*;

	import event.NavigationEvent;
	
	public class NavigationManager extends EventDispatcher {

		private static var mInstance:NavigationManager;

		private var mState:String;
		
		/**
		Supposedly private constructor
		*/
		function NavigationManager () {
			super();
		}
		
		/**
		Access point for the one instance of the NavigationManager
		*/
		public static function getInstance () : NavigationManager {
			if (mInstance == null) {
				mInstance = new NavigationManager();
			}
			return mInstance;
		}
		
		public function getState () : String {
			return mState;
		}
		
		public function setState (inState:String) : void {
			if (inState == mState) return;
			mState = inState;
			dispatchEvent(new NavigationEvent(mState, this));
		}
	}
}