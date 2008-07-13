package controller {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.asaplibrary.management.flow.*;
	import org.asaplibrary.util.FrameDelay;
	import org.asaplibrary.util.StageUtils;
	import org.asaplibrary.util.actionqueue.*;
	
	import data.AppSettings;
	
	import fl.motion.easing.Quadratic;
	
	import ui.*;	

	public class AppController extends FlowSection {
		
		public var tSections:MovieClip;
		public var tMenu:MovieClip;

		private var mLoaderAnim:Loader;

		protected var FM:FlowManager = FlowManager.defaultFlowManager;
		
		function AppController () {
			super();

			initMenu();
			listen();
			initFlowManager();
			new FrameDelay(display); // wait one frame, otherwise we get a flickering of assets on the stage
		}
		
		protected function initMenu () : void {
			// show the menu later
			tMenu.visible = false;
		}
		
		protected function listen () : void {
			// listen for button clicks			
			addEventListener(MouseEvent.MOUSE_UP, handleButtonClick);
			// listen for FlowManager updates such as loaded movies
			FM.addEventListener(FlowNavigationEvent._EVENT, handleNavigationEvent);
		}
		
		protected function initFlowManager () : void {
			FM.setDownloadDirectory(""); // use current dir
			
			var rule:FlowRule;
			
			// after the intro, go to section 1
			rule = new FlowRule(
				AppSettings.SECTION_INTRO,
				FlowOptions.START_END,
				FlowOptions.ANY,
				proceedToSection1
			);
			FM.addRule(rule);
			
			// do not hide with sibling sections
			rule = new FlowRule(
				null,
				FlowOptions.STOP,
				FlowOptions.DISTANT|FlowOptions.SIBLING,
				doNotHide
			);
			FM.addRuleForSections (
				rule,
				[AppSettings.SECTION1, AppSettings.SECTION2, AppSettings.SECTION3, AppSettings.SECTION4]
			);
			
			rule = new FlowRule(
				null,
				FlowOptions.START,
				FlowOptions.ANY,
				moveSection
			);
			FM.addRuleForSections (
				rule,
				[AppSettings.SECTION1, AppSettings.SECTION2, AppSettings.SECTION3, AppSettings.SECTION4]
			);
		}
		
		protected function display () : void {
			visible = true; // necessary because this is a FlowSection as well
			FM.goto(AppSettings.SECTION_INTRO);
			FM.goto(AppSettings.SECTION_MENU, this, false, false);
		}
		
		protected function proceedToSection1 (inSection:IFlowSection) : void {
			FM.goto(AppSettings.SECTION1, this, false);
		}
		
		protected function doNotHide (inSection:IFlowSection) : void {
			// do nothing
		}
	
		protected function moveSection (inSection:IFlowSection) : void {
			var x:Number, y:Number;
			switch (inSection.getName()) {
				case AppSettings.SECTION1:
					x = 0; y = 40;
					break;
				case AppSettings.SECTION2:
					x = -400; y = 40;
					break;
				case AppSettings.SECTION3:
					x = 0; y = -260;
					break;
				case AppSettings.SECTION4:
					x = -400; y = -260;
					break;
			}
			var queue:ActionQueue = moveQueue(x, y);
			FM.addAction(inSection.startAction);
			FM.addAction(queue);
		}
		
		protected function moveQueue (inX:Number, inY:Number) : ActionQueue {
			var queue:ActionQueue = new ActionQueue("moveToSection");
			var CURRENT:Number = Number.NaN;
			var effect:Function = fl.motion.easing.Quadratic.easeInOut;
			queue.addAction(new AQMove().move(tSections, .5, CURRENT, CURRENT, inX, inY, effect));
			return queue;
		}
		
		protected function handleNavigationEvent (e:FlowNavigationEvent) : void {
			e.stopImmediatePropagation();
			switch (e.subtype) {
				case FlowNavigationEvent.UPDATE:
					FM.goto(e.name);
					break;
				case FlowNavigationEvent.WILL_LOAD:
					// movie is about to be loaded
					prepareMovie(e);
					break;
				case FlowNavigationEvent.LOADED:
					// just for this demo, add a little pause just to show the loader
					// otherwise use:
					//attachMovie(e);
					new FrameDelay(attachMovie, 30, [e]);
					break;
				default:
					//
			}
		}
		
		/**
		Called when a button is clicked.
		*/
		protected function handleButtonClick (e:MouseEvent) : void {
			e.stopImmediatePropagation();
			if (e.type != MouseEvent.MOUSE_UP) {
				return;
			}
			if (e.target is GenericButton) {
				var name:String = GenericButton(e.target).id;
				FM.goto(name);
			}
		}
		
		/**
		
		*/
		protected function prepareMovie (e:FlowNavigationEvent) : void {
			if (e.name.indexOf(AppSettings.SECTION4) != -1) {
				// move to position
				var x:Number, y:Number;
				x = -400; y = -260;
				var queue:ActionQueue = moveQueue(x, y);
				queue.addAction(showLoader);
				queue.run();
			}
		}
		
		/**
		
		*/
		protected function showLoader () : void {
			mLoaderAnim = new Loader();
			addChild(mLoaderAnim);
			StageUtils.centerOnStage(mLoaderAnim);
		}
		
		/**
		
		*/
		protected function hideLoader () : void {
			if (mLoaderAnim != null) {
				removeChild(mLoaderAnim);
			}
		}
		
		/**
		
		*/
		protected function attachMovie (e:FlowNavigationEvent) : void {
			var section:IFlowSection = FM.getSectionByName(e.name);
			if (section != null) {
				var clip:DisplayObject = tSections.addChild(DisplayObject(section));
				if (e.name == AppSettings.SECTION4) {
					clip.x = 400;
					clip.y = 300;
				}
				hideLoader();
				FM.goto(e.destination);
			}
		}
		
	}

}
