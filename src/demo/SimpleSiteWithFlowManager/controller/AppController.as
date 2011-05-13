package demo.SimpleSiteWithFlowManager.controller {
	import demo.SimpleSiteWithFlowManager.data.AppSettings;

	import org.asaplibrary.management.flow.*;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class AppController extends MovieClip {
		private var FM : FlowManager = FlowManager.defaultFlowManager;
		public var tHomeHolder : MovieClip;
		public var tGalleryHolder : MovieClip;
		public var tMenuHolder : MovieClip;

		function AppController() {
			super();
			listen();
			display();
		}

		protected function listen() : void {
			FM.addEventListener(FlowNavigationEvent._EVENT, handleNavigationEvent);
		}

		protected function display() : void {
			FM.goto(AppSettings.HOME_NAME);
			FM.goto(AppSettings.MENU_NAME, this, false, false);
		}

		protected function handleNavigationEvent(e : FlowNavigationEvent) : void {
			switch (e.subtype) {
				case FlowNavigationEvent.LOADED:
					e.stopImmediatePropagation();
					attachMovie(e);
					break;
			}
		}

		protected function attachMovie(e : FlowNavigationEvent) : void {
			var section : IFlowSection = FM.getSectionByName(e.name);
			if (section != null) {
				switch (e.name) {
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
				var data : FlowNavigationData = FM.getFlowNavigationDataByName(e.name);
				FM.goto(e.destination, data.trigger, data.stopEverythingFirst, data.updateState);
			}
		}
	}
}