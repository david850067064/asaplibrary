package controller {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.asaplibrary.management.flow.*;
	import org.asaplibrary.util.actionqueue.*;
	
	import data.AppSettings;
	
	import fl.motion.easing.*;
	
	import ui.CloseButton;	

	public class Section1_1 extends FlowSection {
		
		public var tNumber:MovieClip;
		public var tClose:CloseButton;
				
		function Section1_1 () {
			super();
			tNumber.tText.text = "1.1";
			tClose.addEventListener(MouseEvent.MOUSE_UP, handleClose);
		}
		
		public override function getName () : String {
			return AppSettings.SECTION1_1;
		}

		protected function handleClose (e:MouseEvent) : void {
			FlowManager.defaultFlowManager.goto(AppSettings.SECTION1);
		}
		
		public override function get startAction () : IAction {
			var queue:ActionQueue = new ActionQueue("Section1_1 show");
			queue.addAction(new AQSet().setVisible(this, true));
			queue.addAction(new AQSet().setScale(this, .5, .5));
			const CURRENT:Number = Number.NaN;
			var effect:Function = Elastic.easeOut;
			queue.addAction(new AQScale().scale(this, .8, CURRENT, CURRENT, 1, 1, effect));
			return queue;
		}
		
		public override function get stopAction () : IAction {
			var queue:ActionQueue = new ActionQueue("Section1_1 hide");
			const CURRENT:Number = Number.NaN;
			var effect:Function = Quadratic.easeOut;
			queue.addAction(new AQScale().scale(this, .3, CURRENT, CURRENT, 0, 0, effect));
			queue.addAction(new AQSet().setVisible(this, false));
			return queue;
		}
		
	}

}
