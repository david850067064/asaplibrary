package controller {

	import flash.events.MouseEvent;

	import org.asaplibrary.management.movie.*;

	import data.AppSettings;
	import event.NavigationEvent;
	import ui.SimpleButton;
	
	public class HomeController extends LocalController {
		
		public var tRoundedBtn:SimpleButton;
		public var tPictureBtn:SimpleButton;
		
		/**
		
		*/
		function HomeController () {
			super("HomeController");
			addEventListener(MouseEvent.CLICK, handleButtonClick);
		}

		/**
		Called when a thumb is clicked.
		*/
		private function handleButtonClick (e:MouseEvent) : void {
			switch (e.target) {
				case tRoundedBtn:
				case tPictureBtn:
				default:
					dispatchEvent(new NavigationEvent(AppSettings.GALLERY_NAME, this));
			}
		}
		
	}
}