package demo.ThumbController.ui {
	import org.asaplibrary.ui.buttons.*;

	import flash.display.MovieClip;

	public class ThumbImage extends MovieClip {
		private var mId : String;
		private var mDelegate : ButtonBehavior;
		public var tBorder : MovieClip;

		function ThumbImage() {
			mDelegate = new ButtonBehavior(this);
			mDelegate.addEventListener(ButtonBehaviorEvent._EVENT, update);
			tBorder.visible = false;
			select(false);
		}

		public function select(inState : Boolean) : void {
			mDelegate.select(inState);
		}

		public function get id() : String {
			return mId;
		}

		public function set id(inId : String) : void {
			mId = inId;
		}

		private function update(e : ButtonBehaviorEvent) : void {
			switch (e.state) {
				case ButtonStates.SELECTED:
				case ButtonStates.OVER:
					tBorder.visible = true;
					break;
				case ButtonStates.NORMAL:
				case ButtonStates.OUT:
				case ButtonStates.DESELECTED:
					tBorder.visible = false;
					break;
				default:
					tBorder.visible = false;
			}
			buttonMode = !e.selected;
		}
	}
}