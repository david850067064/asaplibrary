package controller {

	import org.asaplibrary.management.flow.*;
	import org.asaplibrary.util.actionqueue.*;

	public class ProjectSection extends LocalControllerFlowSection {

		private static const FADE_OUT_DURATION:Number = .2;
		private static const FADE_IN_DURATION:Number = .7;
		
		function ProjectSection (inName:String) {
			super(inName);
		}

		public override function get startAction () : IAction {
			var queue:ActionQueue = new ActionQueue();
			queue.addAction(new AQSet().setAlpha(this, 0));
			queue.addAction(new AQSet().setVisible(this, true));
			const CURRENT:Number = Number.NaN;
			queue.addAction( new AQFade().fade( this, FADE_IN_DURATION, CURRENT, 1 ));
			return queue;
		}
		
		public override function get stopAction () : IAction {
			var queue:ActionQueue = new ActionQueue();
			const CURRENT:Number = Number.NaN;
			queue.addAction( new AQFade().fade( this, FADE_OUT_DURATION, CURRENT, 0 ));
			queue.addAction(new AQSet().setVisible(this, false));
			return queue;
		}
		
	}
}