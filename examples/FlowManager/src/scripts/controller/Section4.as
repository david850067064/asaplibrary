package controller {
	import org.asaplibrary.management.flow.*;
	import org.asaplibrary.util.actionqueue.*;
	
	import data.AppSettings;
	
	import fl.motion.easing.*;
	
	import ui.GenericButton;	

	public class Section4 extends LocalControllerFlowSection {

		public var Show_Section2:GenericButton;
		public var Show_Section3:GenericButton;
		public var Show_Register:GenericButton;
		public var Show_Section4_1:GenericButton;
		
		function Section4 () {
			super( AppSettings.SECTION4 );
			
			Show_Section2.setData("Show 2", AppSettings.SECTION2);
			Show_Section3.setData("Show 3", AppSettings.SECTION3);
			Show_Register.setData("Register now", AppSettings.SECTION1_1);
			Show_Section4_1.setData("Show 4.1", AppSettings.SECTION4_1);
			
			alpha = 0;
			visible = false;
			
			if (isStandalone()) {
				startStandalone();
			}
		}

		public override function get startAction () : IAction {
			var queue:ActionQueue = new ActionQueue("Section4 show");
			queue.addAction(new AQSet().setVisible(this, true));
			const CURRENT:Number = Number.NaN;
			var effect:Function = Quadratic.easeOut;
			// use an asychronous action so we don't have to wait each time
			// before this section moves into view
			// (in AppController the startAction is called before moving the stage)
			queue.addAsynchronousAction(new AQFade().fade(this, .8, CURRENT, 1, effect));
			return queue;
		}
	}

}
