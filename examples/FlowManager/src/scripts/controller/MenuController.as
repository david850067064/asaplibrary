package controller {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	import org.asaplibrary.management.movie.LocalController;
	import org.asaplibrary.management.flow.*;
	import org.asaplibrary.util.actionqueue.*;	

	import ui.MenuButton;
	import data.AppSettings;
	
	public class MenuController extends FlowSection {
		
		private static const XPOS:Number = 10;
		private static const YPOS:Number = 8;
		private static const MARGIN_RIGHT:Number = 10;
		
		public var tBackground:MovieClip;
		public var tIntro:MenuButton;
		public var tSectionOne:MenuButton;
		public var tSectionOneOne:MenuButton;
		
		private var mSelectedButton:MenuButton;
		private var mButtons:Object;
		private var mLeft:Number = XPOS;
		
		function MenuController () {
			super("Menu");
			
			mButtons = new Object();
			
			tBackground.alpha = .6;
			
			var x:Number = XPOS;
			x += addButton(AppSettings.SECTION_INTRO, "Intro", x) + MARGIN_RIGHT;
			x += addButton(AppSettings.SECTION1, "One", x) + MARGIN_RIGHT;
			x += addButton(AppSettings.SECTION1_1, "Register", x) + MARGIN_RIGHT;
			x += addButton(AppSettings.SECTION2, "Two", x) + MARGIN_RIGHT;
			x += addButton(AppSettings.SECTION3, "Three", x) + MARGIN_RIGHT;
			x += addButton(AppSettings.SECTION4, "Four", x) + MARGIN_RIGHT;
			FlowManager.getInstance().addEventListener(FlowNavigationEvent._EVENT, handleNavigationEvent);
		}
		
		/**
		Do not hide
		*/
		public override function get showAction () : IAction {
			visible = true;
			alpha = 0;
			var queue:ActionQueue = new ActionQueue();
			queue.addAction(new AQFade().fade(this, .5, 0, 1));
			return queue;
		}
		
		/**
		Do not hide
		*/
		public override function get hideAction () : IAction {
			return null;
		}
		
		private function addButton (inId:String, inLabel:String, inX:Number) : Number {
			var button:MenuButton = new MenuButton();
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
		private function handleButtonClick (e:MouseEvent) : void {
			var button:MenuButton = e.currentTarget as MenuButton;
			if (button == mSelectedButton) return;
			// do not draw yet, but wait until we receive an update event in handleNavigationEvent
			dispatchEvent(new FlowNavigationEvent(FlowNavigationEvent.UPDATE, button.id, this));
		}
		
		private function setSelectedButton (inButton:MenuButton) : void {
			if (mSelectedButton) mSelectedButton.select(false);
			mSelectedButton = inButton;
			mSelectedButton.select(true);
		}
		
		private function handleNavigationEvent (e:FlowNavigationEvent) : void {
			switch (e.subtype) {
				case FlowNavigationEvent.WILL_UPDATE:
				case FlowNavigationEvent.UPDATE:
					e.stopImmediatePropagation();
					if (mSelectedButton && mSelectedButton.id == e.name) return;
					var button:MenuButton = mButtons[e.name];
					if (button != null) {
						setSelectedButton( mButtons[e.name] );
					}
					break;
				default:
					//
			}
		}
		
		
	}

}
