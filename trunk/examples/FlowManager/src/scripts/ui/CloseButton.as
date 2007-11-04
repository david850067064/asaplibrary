
package ui {

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.ColorTransform;
	
	import org.asaplibrary.ui.buttons.*;
	
	/**
	
	*/
	public class CloseButton extends MovieClip {

		protected var mDelegate:ButtonBehaviorDelegate;
		protected static const S:Class = ButtonStates;
		
		public function CloseButton () {
			mDelegate = new ButtonBehaviorDelegate(this);
			mDelegate.addEventListener(ButtonBehaviorDelegateEvent._EVENT, update);
			// don't handle mouse events on children
			mouseChildren = false;
			drawUpState();
		}
		
		protected function update (e:ButtonBehaviorDelegateEvent) : void {
			switch (e.state) {
				case S.SELECTED:
				case S.OVER:
					drawOverState();
					break;
				case S.NORMAL:
				case S.OUT:
				case S.DESELECTED:
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