
package ui {
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.asaplibrary.ui.buttons.*;	

	/**
	
	*/
	public class MenuButton extends GenericButton {

		/**
		
		*/
		public function MenuButton () {
			super();
		}

		public function enable (inState:Boolean) : void {
			mDelegate.enable(inState);
		}
		
		public function select (inState:Boolean) : void {
			mDelegate.select(inState);
		}
		
		/**
		
		*/
		protected override function update (e:ButtonBehaviorEvent) : void {
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
					break;
				default:
					drawUpState();
			}
			buttonMode = enabled = !e.selected;
		}
		
		protected override function drawUpState () : void {
			var ct:ColorTransform = new ColorTransform();
			ct.color = 0xffffff;
			tLabel.transform.colorTransform = ct;
			
			var format:TextFormat = new TextFormat();
			format.underline = true;
			tLabel.defaultTextFormat = format;
			tLabel.setTextFormat(format);
		}
		
		protected override function drawOverState () : void {
			var ct:ColorTransform = new ColorTransform();
			ct.color = 0x000000;
			tLabel.transform.colorTransform = ct;
			
			var format:TextFormat = new TextFormat();
			format.underline = true;
			tLabel.setTextFormat(format);
		}
		
		private function drawSelectedState () : void {
			var ct:ColorTransform = new ColorTransform();
			ct.color = 0x000000;
			tLabel.transform.colorTransform = ct;
			
			var format:TextFormat = new TextFormat();
			format.underline = false;
			tLabel.setTextFormat(format);
		}
	
	}
}