package demo.AccordionWithFlowManager.ui.accordion {
	import fl.motion.easing.Cubic;

	import org.asaplibrary.management.flow.*;

	import flash.display.MovieClip;

	/**
	 * Download Grant Skinner's easing library from http://gskinner.com/libraries/gtween/
	 */

	public class Accordion extends MovieClip {
		protected const DEFAULT_DURATION : Number = .5;
		protected const DEFAULT_EFFECT : Function = Cubic.easeOut;
		protected var mName : String;
		protected var mPanes : Array; /**< Of type Pane */
		protected var mFlowManager : FlowManager;
		protected var mDuration : Number = DEFAULT_DURATION;
		protected var mEffect : Function = DEFAULT_EFFECT;

		function Accordion(inName : String, inFlowManager : FlowManager) {
			super();
			mName = inName;
			mFlowManager = inFlowManager;
			mFlowManager.addEventListener(FlowNavigationEvent._EVENT, handleNavigationEvent);
			mPanes = new Array();
		}

		public override function toString() : String {
			return "Accordion: " + mName;
		}

		public function getPaneAtIndex(inIndex : uint) : Pane {
			return mPanes[inIndex];
		}

		public function setPaneAtIndex(inPane : Pane, inIndex : uint) : void {
			mPanes[inIndex] = inPane;
		}

		public override function get height() : Number {
			var h : Number = 0;
			var i : uint, ilen : uint = mPanes.length;
			for (i = 0; i < ilen; ++i) {
				h += Pane(mPanes[i]).height;
			}
			return h;
		}

		public function setDuration(inDuration : Number) : void {
			mDuration = inDuration;
		}

		public function getDuration() : Number {
			return mDuration;
		}

		public function setEffect(inEffect : Function) : void {
			mEffect = inEffect;
		}

		public function getEffect() : Function {
			return mEffect;
		}

		protected function getLastPane() : Pane {
			return mPanes[mPanes.length - 1];
		}

		protected function addPane(inPane : Pane) : void {
			inPane.setPrevious(getLastPane());
			mPanes.push(inPane);
			addChild(inPane);
		}

		protected function handleNavigationEvent(e : FlowNavigationEvent) : void {
			e.stopImmediatePropagation();
			var pane : Pane;
			switch (e.subtype) {
				case FlowNavigationEvent.SECTIONS_STOPPING:
					pane = mFlowManager.getSectionByName(e.name) as Pane;
					updatePaneStates(e.stoppingSections, PaneOptions.CLOSING);
					break;
				case FlowNavigationEvent.SECTIONS_STARTING:
					pane = mFlowManager.getSectionByName(e.name) as Pane;
					updatePaneStates(e.startingSections, PaneOptions.OPENING);
					break;
			}
		}

		/**
		Passes the 'closing' or 'opening' state to the panes that are affected by the navigation change.
		 */
		protected function updatePaneStates(inPaneNames : Array, inPaneState : uint) : void {
			var i : uint, ilen : uint = inPaneNames.length;
			var pane : Pane;
			for (i = 0; i < ilen; ++i) {
				pane = mFlowManager.getSectionByName(inPaneNames[i]) as Pane;
				pane.setState(inPaneState);
			}
		}
	}
}
