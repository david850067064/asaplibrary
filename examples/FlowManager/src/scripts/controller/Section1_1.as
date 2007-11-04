package controller {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import fl.motion.easing.*;

	import org.asaplibrary.management.flow.*;
	import org.asaplibrary.util.actionqueue.*;

	import data.AppSettings;
	import ui.CloseButton;
	
	public class Section1_1 extends FlowSection {
		
		public var tNumber:MovieClip;
		public var tClose:CloseButton;
		
		function Section1_1 () {
			super( AppSettings.SECTION1_1 );
			tNumber.tText.text = "1.1";
			tClose.addEventListener(MouseEvent.MOUSE_UP, handleClose);

		}

		private function handleClose (e:MouseEvent) : void {
			FlowManager.getInstance().goto(AppSettings.SECTION1);
		}
		
		public override function get showAction () : IAction {
			var queue:ActionQueue = new ActionQueue("Section1_1 show");
			queue.addAction(new AQSet().setVisible(this, true));
			queue.addAction(new AQSet().setScale(this, .5, .5));
			const CURRENT:Number = Number.NaN;
			var effect:Function = Elastic.easeOut;
			queue.addAction(new AQScale().scale(this, .8, CURRENT, CURRENT, 1, 1, effect));
			return queue;
		}
		
		public override function get hideAction () : IAction {
			var queue:ActionQueue = new ActionQueue("Section1_1 hide");
			const CURRENT:Number = Number.NaN;
			var effect:Function = Quadratic.easeOut;
			queue.addAction(new AQScale().scale(this, .3, CURRENT, CURRENT, 0, 0, effect));
			queue.addAction(new AQSet().setVisible(this, false));
			return queue;
		}
		
	}

}
