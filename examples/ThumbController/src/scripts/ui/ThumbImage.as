package ui {

	import flash.display.MovieClip;

	import org.asaplibrary.ui.buttons.*;
	
	public class ThumbImage extends MovieClip {
		
		private var mId:String;
		private var mDelegate:ButtonBehaviorDelegate;
		private static const S:Class = ButtonStates;

		public var tBorder:MovieClip;
				
		function ThumbImage () {
			mDelegate = new ButtonBehaviorDelegate(this);
			mDelegate.addEventListener(ButtonBehaviorDelegateEvent._EVENT, update);
			tBorder.visible = false;
			select(false);
		}
		
		public function select (inState:Boolean) : void {
			mDelegate.select(inState);
		}

		public function get id () : String {
			return mId;
		}
		
		public function set id (inId:String) : void {
			mId = inId;
		}
		
		private function update (e:ButtonBehaviorDelegateEvent) : void {
		
			switch (e.state) {
				case S.SELECTED:
				case S.OVER:
					tBorder.visible = true;
					break;
				case S.NORMAL:
				case S.OUT:
				case S.DESELECTED:
					tBorder.visible = false;
					break;
				default:
					tBorder.visible = false;
			}
			buttonMode = !e.selected;
		}

	}
}