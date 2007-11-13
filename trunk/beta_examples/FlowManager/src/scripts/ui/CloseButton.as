
package ui {

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.ColorTransform;
	
	import org.asaplibrary.ui.buttons.*;
	
	/**
	
	*/
	public class CloseButton extends MovieClip {

		protected var mDelegate:ButtonBehavior;
		protected static const S:Class = ButtonStates;
		
		public function CloseButton () {
			mDelegate = new ButtonBehavior(this);
			mDelegate.addEventListener(ButtonBehaviorEvent._EVENT, update);
			// don't handle mouse events on children
			mouseChildren = false;
			drawUpState();
		}
		
		protected function update (e:ButtonBehaviorEvent) : void {
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