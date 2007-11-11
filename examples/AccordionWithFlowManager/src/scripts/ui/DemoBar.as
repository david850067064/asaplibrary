package ui {

	import flash.display.MovieClip;
	import flash.text.TextField;

	import ui.accordion.*;
	
	public class DemoBar extends Bar {
		
		public var tTitle:TextField;
		
		public function setTitle (inTitle:String) : void {
			tTitle.text = inTitle;
		}
		
		public override function drawNormal () : void {
			gotoAndStop("up");
		}
		
		public override function drawOver () : void {
			gotoAndStop("over");
		}
		
		public override function drawSelected () : void {
			gotoAndStop("selected");
		}

	}
}