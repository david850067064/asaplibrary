package org.asaplibrary.util {
	import flash.display.Stage;
	import flash.events.KeyboardEvent;		

	/**
	 * Class for directly coupling Keyboard events to actions, without having to bother about event filtering
	 * 
	 * @use:
	 * <code>
			mKeyMapper = new KeyMapper(LocalController.globalStage);
			mKeyMapper.setMapping(Keyboard.ENTER, submit);
			mKeyMapper.setMapping(Keyboard.ESCAPE, cancel);
	 * </code>
	 * Make sure to clean up when you're done:
	 * <code>
	 * mKeyMapper.die();
	 * </code>
	 */
	public class KeyMapper {
		private var mMap : Object = new Object();
		private var mStage : Stage;

		
		public function KeyMapper (inStage:Stage) {
			mStage = inStage;
			mStage.addEventListener(KeyboardEvent.KEY_UP, handleKeyEvent);
		}
		
		/**
		 *
		 */
		public function setMapping (inKey:uint, inHandler:Function) : void {
			mMap[inKey] = inHandler;
		}
		
		/**
		 *
		 */
		public function die () : void {
			mMap = null;
			mStage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyEvent);
		}
		
		private function handleKeyEvent(e : KeyboardEvent) : void {
			if (mMap[e.keyCode]) mMap[e.keyCode]();
		}
	}
}
