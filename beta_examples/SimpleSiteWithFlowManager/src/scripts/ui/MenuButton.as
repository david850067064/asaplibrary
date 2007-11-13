package ui {
	
	public class MenuButton extends SimpleButton {
		
		public function select (inState:Boolean) : void {
			mDelegate.select(inState);
		}
		
		public function enable (inState:Boolean) : void {
			mDelegate.enable(inState);
		}

	}
}