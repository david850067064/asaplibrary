package demo.AccordionWithFlowManager.ui {
	import demo.AccordionWithFlowManager.ui.accordion.*;

	import flash.display.MovieClip;
	import flash.text.TextField;

	public class DemoPaneTextContent extends MovieClip implements IPaneContent {
		public var tMask : MovieClip;
		public var tContent : TextField;

		public function setContent(inObject : Object) : void {
			text = String(inObject);
		}

		public function set text(inText : String) : void {
			tContent.text = inText;
			var contentHeigth : Number = tContent.textHeight;
			contentHeigth += 10;
			tMask.height = tContent.height = contentHeigth;
		}

		public override function get height() : Number {
			return tContent.textHeight + 10;
		}
	}
}