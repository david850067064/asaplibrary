
package ui {

	import flash.display.MovieClip;
	
	import org.asaplibrary.ui.buttons.ButtonStateDelegate;
	import org.asaplibrary.ui.buttons.ButtonStateDelegateEvent;
	
	/**
	Class used for "previous" and "next" buttons.
	*/
	public class NextButton extends MovieClip {
	
		private var mDelegate:ButtonStateDelegate;
		private static const D:Class = ButtonStateDelegate;
		
		/**
		
		*/
		public function NextButton () {
			mDelegate = new ButtonStateDelegate(this);
			mDelegate.addEventListener(ButtonStateDelegateEvent.UPDATE, update);
		}
		
		/**
		
		*/
		public function enable (inState:Boolean) : void {
			mDelegate.enable(inState);
		}
		
		/**
		
		*/
		private function update (e:ButtonStateDelegateEvent) : void {
		
			var frame:String;

			switch (e.state) {
				case D.OVER:
					frame = "over";
					break;
				case D.OUT:
					frame = "out";
					break;
				case D.NORMAL:
					frame = "normal";
					break;
				case D.DISABLED:
					frame = "disabled";
					break;
				default:
					frame = "normal";
			}	
			gotoAndPlay(frame);
			buttonMode = e.enabled;
		}
	
	}
}