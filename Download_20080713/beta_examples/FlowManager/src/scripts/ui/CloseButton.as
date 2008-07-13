
package ui {
	import flash.display.MovieClip;
	
	import org.asaplibrary.ui.buttons.*;	

	/**
	
	*/
	public class CloseButton extends MovieClip {

		protected var mDelegate:ButtonBehavior;
		
		public function CloseButton () {
			mDelegate = new ButtonBehavior(this);
			mDelegate.addEventListener(ButtonBehaviorEvent._EVENT, update);
			// don't handle mouse events on children
			mouseChildren = false;
			drawUpState();
		}
		
		protected function update (e:ButtonBehaviorEvent) : void {
			switch (e.state) {
				case ButtonStates.SELECTED:
				case ButtonStates.OVER:
					drawOverState();
					break;
				case ButtonStates.NORMAL:
				case ButtonStates.OUT:
				case ButtonStates.DESELECTED:
					drawUpState();
					break;
				default:
					drawUpState();
			}
			buttonMode = enabled = !e.selected;
		}
		
		protected function drawUpState () : void {
			gotoAndStop("up");
		}
		
		protected function drawOverState () : void {
			gotoAndStop("over");
		}
	
	}
}