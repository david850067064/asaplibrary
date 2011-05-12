package demo.SimpleSite.controller {
	import demo.SimpleSite.data.AppSettings;
	import demo.SimpleSite.event.NavigationEvent;
	import demo.SimpleSite.ui.SimpleButton;

	import flash.events.MouseEvent;

	public class HomeController extends ProjectController {
		public var tRoundedBtn : SimpleButton;
		public var tPictureBtn : SimpleButton;

		function HomeController() {
			super();
			addEventListener(MouseEvent.CLICK, handleButtonClick);
		}

		/**
		Called when a thumb is clicked.
		 */
		private function handleButtonClick(e : MouseEvent) : void {
			switch (e.target) {
				case tRoundedBtn:
				case tPictureBtn:
				default:
					dispatchEvent(new NavigationEvent(AppSettings.GALLERY_NAME, this));
			}
		}
	}
}