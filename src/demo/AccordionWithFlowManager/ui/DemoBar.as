package demo.AccordionWithFlowManager.ui {
	import demo.AccordionWithFlowManager.ui.accordion.*;

	import flash.text.TextField;

	public class DemoBar extends Bar {
		public var tTitle : TextField;

		public function setTitle(inTitle : String) : void {
			tTitle.text = inTitle;
		}

		public override function drawNormal() : void {
			gotoAndStop("up");
		}

		public override function drawOver() : void {
			gotoAndStop("over");
		}

		public override function drawSelected() : void {
			gotoAndStop("selected");
		}
	}
}