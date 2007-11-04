/**
TEST:

----
----
1 2 
 O
3 4


(all: move rules)
O = intro timeline anim
1 = simple show/hide
2 = fade show/hide
3 = fade show/hide +
	3.1 fade show/hide
4 = simple show/hide + 
	4.1 external swf
*/

package controller {

	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import fl.motion.easing.*;

	import org.asaplibrary.management.movie.LocalController;
	import org.asaplibrary.management.flow.*;
	import org.asaplibrary.util.actionqueue.*;	
	import org.asaplibrary.util.FrameDelay;
	import org.asaplibrary.util.StageUtils;
	
	import data.AppSettings;
	import ui.*;
	
	public class AppController extends LocalController {
		
		public var tSections:MovieClip;
		public var tMenu:MovieClip;

		private var mLoaderAnim:Loader;

		public static const OPTIONS:Class = FlowSectionOptions;		
		protected var FM:FlowManager = FlowManager.getInstance();
		
		function AppController () {
			super("AppController");

			initMenu();
			listen();
			initFlowManager();
			start();
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
				OPTIONS.SHOW_END,
				OPTIONS.ANY,
				proceedToSection1
			);
			FM.addRule(rule);
			
			// do not hide with sibling sections
			rule = new FlowRule(
				null,
				OPTIONS.HIDE,
				OPTIONS.DISTANT|OPTIONS.SIBLING,
				doNotHide
			);
			FM.addRuleForSections (
				rule,
				[AppSettings.SECTION1, AppSettings.SECTION2, AppSettings.SECTION3, AppSettings.SECTION4]
			);
			
			rule = new FlowRule(
				null,
				OPTIONS.SHOW,
				OPTIONS.ANY,
				moveSection
			);
			FM.addRuleForSections (
				rule,
				[AppSettings.SECTION1, AppSettings.SECTION2, AppSettings.SECTION3, AppSettings.SECTION4]
			);
	
		}
		
		protected function start () : void {
			FM.goto(AppSettings.SECTION_INTRO);
			FM.goto(AppSettings.SECTION_MENU, false, false);
		}
		
		protected function proceedToSection1 (inSection:IFlowSection) : void {
			FM.goto(AppSettings.SECTION1, false);
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
					break
				case AppSettings.SECTION4:
					x = -400; y = -260;
					break;
			}
			var queue:ActionQueue = moveQueue(x, y);
			FM.addAction(inSection.showAction);
			FM.addAction(queue);
		}
		
		protected function moveQueue (inX:Number, inY:Number) : ActionQueue {
			var queue:ActionQueue = new ActionQueue("moveToSection");
			var CURRENT:Number = Number.NaN;
			var effect:Function = Quadratic.easeInOut;
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
					prepareMovie(e.name);
					break;
				case FlowNavigationEvent.LOADED:
					// just for this demo, add a little pause just to show the loader
					new FrameDelay(attachMovie, 45, [e.name]);
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
		protected function prepareMovie (inId:String) : void {
			switch (inId) {
				case AppSettings.SECTION4: 
					// move to position
					var x:Number, y:Number;
					x = -400; y = -260;
					var queue:ActionQueue = moveQueue(x, y);
					queue.addAction(showLoader);
					queue.run();
					break;
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
			removeChild(mLoaderAnim);
		}
		
		/**
		
		*/
		protected function attachMovie (inId:String) : void {
			var section:IFlowSection = FM.getSectionByName(inId);
			if (section != null) {
				var clip:DisplayObject = tSections.addChild(DisplayObject(section));
				if (inId == AppSettings.SECTION4) {
					clip.x = 400;
					clip.y = 300;
				}
				hideLoader();
				FM.goto(inId);
			}
		}
		
	}

}
