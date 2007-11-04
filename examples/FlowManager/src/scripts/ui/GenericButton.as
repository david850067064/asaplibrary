
package ui {

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.ColorTransform;
	
	import org.asaplibrary.ui.buttons.*;
	import org.asaplibrary.management.flow.*;
	
	/**
	
	*/
	public class GenericButton extends MovieClip {
	
		protected var mDelegate:ButtonBehaviorDelegate;
		protected static const S:Class = ButtonStates;
		protected static const MAGIC_TEXTWIDTH_PADDING:Number = 5;
		
		protected var mId:String;
		
		public var tLabel:TextField;
		public var tHitarea:MovieClip;
		
		/**
		
		*/
		public function GenericButton () {
			mDelegate = new ButtonBehaviorDelegate(this);
			mDelegate.addEventListener(ButtonBehaviorDelegateEvent._EVENT, update);
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