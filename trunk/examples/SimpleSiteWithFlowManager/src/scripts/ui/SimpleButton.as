package ui {

	import flash.display.MovieClip;

	import org.asaplibrary.ui.buttons.*;
	
	public class SimpleButton extends MovieClip {
		
		protected var mDelegate:ButtonBehaviorDelegate;

		function SimpleButton () {
			super();
			mDelegate = new ButtonBehaviorDelegate(this);
			mDelegate.addEventListener(ButtonBehaviorDelegateEvent._EVENT, update);
			drawUpState();
		}
		
		private function update (e:ButtonBehaviorDelegateEvent) : void {
			switch (e.state) {
				case ButtonStates.SELECTED:
					drawSelectedState();
					break;
				case ButtonStates.OVER:
					drawOverState();
					break;
				case ButtonStates.NORMAL:
				case ButtonStates.OUT:
				case ButtonStates.DESELECTED:
					drawUpState();
				default:
					break;
			}
			buttonMode = !e.selected;
		}
		
		private function drawUpState () : void {
			gotoAndStop("up");
		}
		
		private function drawOverState () : void {
			gotoAndStop("over");
		}
		
		private function drawSelectedState () : void {
			gotoAndStop("selected");
		}

	}
}