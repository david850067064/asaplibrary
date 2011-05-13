package demo.SimpleSiteWithFlowManager.controller {

	import flash.events.MouseEvent;

	import org.asaplibrary.management.flow.*;

	import demo.SimpleSiteWithFlowManager.data.AppSettings;
	import demo.SimpleSiteWithFlowManager.ui.SimpleButton;
	
	public class HomeSection extends ProjectSection {
		
		public var tRoundedBtn:SimpleButton;
		public var tPictureBtn:SimpleButton;

		function HomeSection () {
			super(AppSettings.HOME_NAME);
			addEventListener(MouseEvent.CLICK, handleButtonClick);
			if (isStandalone()) {
				startStandalone();
			}
		}

		/**
		Called when a thumb is clicked.
		*/
		private function handleButtonClick (e:MouseEvent) : void {
			switch (e.target) {
				case tRoundedBtn:
				case tPictureBtn:
					e.stopImmediatePropagation();
					FlowManager.defaultFlowManager.goto(AppSettings.GALLERY_NAME);
					break;
			}
		}
		
	}
}