package controller {
	import flash.display.MovieClip;
	
	import org.asaplibrary.management.flow.*;
	import org.asaplibrary.util.actionqueue.*;
	
	import data.AppSettings;	

	public class SectionIntro extends FlowSection {
		
		public var tIntroAnim:MovieClip;

		function SectionIntro () {
			super( AppSettings.SECTION_INTRO );
		}
		
		/**
		Play the intro animation to the end, then fade out.
		For subsequent calls to startAction, make sure the clip is visible: we add 'setVisible' and 'setAlpha' at the start of the ActionQueue.
		*/
		public override function get startAction () : IAction {

			var endOfAnimationCheck:Function = function () : Boolean {
				return (tIntroAnim.currentLabel == "end");
			};
			var condition:Condition = new Condition (endOfAnimationCheck);
						
			var queue:ActionQueue = new ActionQueue("SectionIntro");
			queue.addAction(new AQSet().setVisible(this, true));
			queue.addAction(new AQSet().setAlpha(this, 1));
			queue.addAction(new AQTimeline().gotoAndPlay(tIntroAnim, 1));
			queue.addCondition(condition);
			queue.addAction(new AQFade().fade(this, 1, 1, 0));
			return queue;
		}
		
	}

}
