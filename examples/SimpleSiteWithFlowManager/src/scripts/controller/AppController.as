package controller {

	import flash.display.MovieClip;
	import flash.display.DisplayObject;

	import org.asaplibrary.management.movie.*;
	import org.asaplibrary.management.flow.*;

	import data.AppSettings;
	
	public class AppController extends FlowSection {

		private var FM:FlowManager = FlowManager.getInstance();
		
		public var tHomeHolder:MovieClip;
		public var tGalleryHolder:MovieClip;
		public var tMenuHolder:MovieClip;
		
		function AppController () {
			super("AppController");
			listen();
			start();
		}
		
		protected function listen () : void {
			FM.addEventListener(FlowNavigationEvent._EVENT, handleNavigationEvent);
			
		}
		
		protected function start () : void {
			visible = true;
			FM.goto(AppSettings.HOME_NAME);
			FM.goto(AppSettings.MENU_NAME, false, false);
		}
		
		protected function handleNavigationEvent (e:FlowNavigationEvent) : void {			
			switch (e.subtype) {
				case FlowNavigationEvent.LOADED:
					e.stopImmediatePropagation();
					attachMovie(e.name);
					break;
			}
		}

		protected function attachMovie (inName:String) : void {
			var section:IFlowSection = FM.getSectionByName(inName);
			if (section != null) {
				switch (inName) {
					case AppSettings.MENU_NAME:
						tMenuHolder.addChild(DisplayObject(section));
						break;
					case AppSettings.HOME_NAME:
						tHomeHolder.addChild(DisplayObject(section));
						break;
					case AppSettings.GALLERY_NAME:
						tGalleryHolder.addChild(DisplayObject(section));
						break;
				}
				var data:FlowNavigationData = FM.getSectionNavigationDataByName(inName);
				FM.goto(data.name, data.stopEverythingFirst, data.updateState);
			}
		}
			
	}
}