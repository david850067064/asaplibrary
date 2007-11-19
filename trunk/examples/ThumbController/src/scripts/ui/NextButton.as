
package ui {
	import flash.display.MovieClip;
	
	import org.asaplibrary.ui.buttons.*;	

	/**
	Class used for "previous" and "next" buttons.
	*/
	public class NextButton extends MovieClip {
	
		private var mDelegate:ButtonBehavior;
		
		/**
		
		*/
		public function NextButton () {
			mDelegate = new ButtonBehavior(this);
			mDelegate.addEventListener(ButtonBehaviorEvent._EVENT, update);
		}
		
		/**
		
		*/
		public function enable (inState:Boolean) : void {
			mDelegate.enable(inState);
		}
		
		/**
		
		*/
		private function update (e:ButtonBehaviorEvent) : void {
		
			var frame:String;

			switch (e.state) {
				case ButtonStates.OVER:
					frame = "over";
					break;
				case ButtonStates.OUT:
					frame = "out";
					break;
				case ButtonStates.NORMAL:
					frame = "normal";
					break;
				case ButtonStates.DISABLED:
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