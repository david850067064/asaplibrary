
package ui {
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.asaplibrary.ui.buttons.*;	

	/**
	
	*/
	public class GenericButton extends MovieClip {
	
		protected var mDelegate:ButtonBehavior;
		protected static const MAGIC_TEXTWIDTH_PADDING:Number = 5;
		
		protected var mId:String;
		
		public var tLabel:TextField;
		public var tHitarea:MovieClip;
		
		/**
		
		*/
		public function GenericButton () {
			mDelegate = new ButtonBehavior(this);
			mDelegate.addEventListener(ButtonBehaviorEvent._EVENT, update);
			// don't handle mouse events on children
			mouseChildren = false;
			drawUpState();
			
			tHitarea.visible = false;
		}
		
		public function setData (inLabel:String, inId:String) : void {
			setLabel(inLabel);
			mId = inId;
		}
		
		public function get id () : String {
			return mId;
		}
		
		public function set id (inId:String) : void {
			mId = inId;
		}
		
		protected function setLabel (inLabel:String) : void {
			tLabel.text = inLabel;
			var w:Number = tLabel.textWidth + MAGIC_TEXTWIDTH_PADDING;
			tLabel.width = w;
			tHitarea.width = w;
		}
		
		/**
		
		*/
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
			var ct:ColorTransform = new ColorTransform();
			ct.color = 0xffffff;
			tLabel.transform.colorTransform = ct;
			
			var format:TextFormat = new TextFormat();
			format.underline = true;
			tLabel.defaultTextFormat = format;
			tLabel.setTextFormat(format);
		}
		
		protected function drawOverState () : void {
			var ct:ColorTransform = new ColorTransform();
			ct.color = 0x00ccff;
			tLabel.transform.colorTransform = ct;
			
			var format:TextFormat = new TextFormat();
			format.underline = true;
			tLabel.setTextFormat(format);
		}
		
	}
}