package demo.SimpleSite.ui {
	import org.asaplibrary.ui.buttons.*;

	import flash.display.MovieClip;

	public class SimpleButton extends MovieClip {
		protected var mDelegate : ButtonBehavior;

		function SimpleButton() {
			super();
			mDelegate = new ButtonBehavior(this);
			mDelegate.addEventListener(ButtonBehaviorEvent._EVENT, update);
			drawUpState();
		}

		private function update(e : ButtonBehaviorEvent) : void {
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

		private function drawUpState() : void {
			gotoAndStop("up");
		}

		private function drawOverState() : void {
			gotoAndStop("over");
		}

		private function drawSelectedState() : void {
			gotoAndStop("selected");
		}
	}
}