﻿package controller {

	import flash.events.MouseEvent;

	import org.asaplibrary.management.flow.*;

	import data.AppSettings;
	import ui.SimpleButton;
	
	public class HomeSection extends ProjectSection {
		
		public var tRoundedBtn:SimpleButton;
		public var tPictureBtn:SimpleButton;

		function HomeSection () {
			super(AppSettings.HOME_NAME);
			addEventListener(MouseEvent.CLICK, handleButtonClick);
			if (isStandalone()) {
				showStandalone();
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
					FlowManager.getInstance().goto(AppSettings.GALLERY_NAME);
					break;
			}
		}
		
	}
}