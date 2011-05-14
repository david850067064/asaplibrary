package demo.FlowManager.controller {
	import demo.FlowManager.data.AppSettings;
	import demo.FlowManager.ui.MenuButton;

	import org.asaplibrary.management.flow.*;
	import org.asaplibrary.util.actionqueue.*;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class MenuController extends FlowSection {
		private static const XPOS : Number = 10;
		private static const YPOS : Number = 8;
		private static const MARGIN_RIGHT : Number = 10;
		public var tBackground : MovieClip;
		public var tIntro : MenuButton;
		public var tSectionOne : MenuButton;
		public var tSectionOneOne : MenuButton;
		private var mSelectedButton : MenuButton;
		private var mButtons : Object;

		function MenuController() {
			super();

			mButtons = new Object();

			tBackground.alpha = .6;

			var x : Number = XPOS;
			x += addButton(AppSettings.SECTION_INTRO, "Intro", x) + MARGIN_RIGHT;
			x += addButton(AppSettings.SECTION1, "One", x) + MARGIN_RIGHT;
			x += addButton(AppSettings.SECTION1_1, "Register", x) + MARGIN_RIGHT;
			x += addButton(AppSettings.SECTION2, "Two", x) + MARGIN_RIGHT;
			x += addButton(AppSettings.SECTION3, "Three", x) + MARGIN_RIGHT;
			x += addButton(AppSettings.SECTION4, "Four", x) + MARGIN_RIGHT;
			x += addButton(AppSettings.SECTION4_1, "Four.1", x) + MARGIN_RIGHT;
			FlowManager.defaultFlowManager.addEventListener(FlowNavigationEvent._EVENT, handleNavigationEvent);
		}

		public override function getName() : String {
			return AppSettings.SECTION_MENU;
		}

		/**
		Do not hide
		 */
		public override function get startAction() : IAction {
			visible = true;
			alpha = 0;
			var queue : ActionQueue = new ActionQueue();
			queue.addAction(new AQFade().fade(this, .5, 0, 1));
			return queue;
		}

		/**
		Do not hide
		 */
		public override function get stopAction() : IAction {
			return null;
		}

		protected function addButton(inId : String, inLabel : String, inX : Number) : Number {
			var button : MenuButton = new MenuButton();
			button.setData(inLabel, inId);
			button.x = inX;
			button.y = YPOS;
			addChild(button);
			button.addEventListener(MouseEvent.MOUSE_UP, handleButtonClick);
			mButtons[inId] = button;
			return button.width;
		}

		/**
		Called when a button is clicked.
		 */
		protected function handleButtonClick(e : MouseEvent) : void {
			// stop other classes processing this event
			e.stopImmediatePropagation();
			var button : MenuButton = e.currentTarget as MenuButton;
			if (button == mSelectedButton) return;
			// do not draw yet, but wait until we receive an update event in handleNavigationEvent
			FlowManager.defaultFlowManager.goto(button.id, button);
		}

		protected function setSelectedButton(inButton : MenuButton) : void {
			if (mSelectedButton) mSelectedButton.select(false);
			mSelectedButton = inButton;
			mSelectedButton.select(true);
		}

		protected function handleNavigationEvent(e : FlowNavigationEvent) : void {
			switch (e.subtype) {
				case FlowNavigationEvent.WILL_UPDATE:
				case FlowNavigationEvent.UPDATE:
					// stop other classes processing this event
					e.stopImmediatePropagation();
					if (mSelectedButton && mSelectedButton.id == e.name) return;
					var button : MenuButton = mButtons[e.name];
					if (button != null) {
						setSelectedButton(mButtons[e.name]);
					}
					break;
				default:
				//
			}
		}
	}
}
