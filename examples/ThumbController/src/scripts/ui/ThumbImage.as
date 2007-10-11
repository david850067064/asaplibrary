package ui {

	import flash.display.MovieClip;

	import org.asaplibrary.ui.buttons.ButtonStateDelegate;
	import org.asaplibrary.ui.buttons.ButtonStateDelegateEvent;
	
	public class ThumbImage extends MovieClip {
		
		private var mId:String;
		private var mDelegate:ButtonStateDelegate;
		private static const D:Class = ButtonStateDelegate;

		public var tBorder:MovieClip;
				
		function ThumbImage () {
			mDelegate = new ButtonStateDelegate(this);
			mDelegate.addEventListener(ButtonStateDelegateEvent.UPDATE, update);
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
		
		private function update (e:ButtonStateDelegateEvent) : void {
		
			switch (e.state) {
				case D.SELECTED:
				case D.OVER:
					tBorder.visible = true;
					break;
				case D.NORMAL:
				case D.OUT:
				case D.DESELECTED:
					tBorder.visible = false;
					break;
				default:
					tBorder.visible = false;
			}	
			
			buttonMode = e.enabled;
		}

	}
}