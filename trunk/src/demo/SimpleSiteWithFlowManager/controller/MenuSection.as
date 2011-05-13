package demo.SimpleSiteWithFlowManager.controller {
	import demo.SimpleSiteWithFlowManager.data.AppSettings;
	import demo.SimpleSiteWithFlowManager.ui.MenuButton;

	import org.asaplibrary.management.flow.*;

	import flash.events.MouseEvent;

	public class MenuSection extends ProjectSection {
		public var tHomeBtn : MenuButton;
		public var tGalleryBtn : MenuButton;
		private var mSelectedButton : MenuButton;
		private var FM : FlowManager = FlowManager.defaultFlowManager;

		function MenuSection() {
			super(AppSettings.MENU_NAME);
			listen();
			selfUpdate();
			if (isStandalone()) {
				startStandalone();
			}
		}

		protected function listen() : void {
			tHomeBtn.addEventListener(MouseEvent.CLICK, handleButtonClick);
			tGalleryBtn.addEventListener(MouseEvent.CLICK, handleButtonClick);
			FM.addEventListener(FlowNavigationEvent._EVENT, handleNavigationEvent);
		}

		protected function selfUpdate() : void {
			var state : String = FM.getCurrentSectionName();
			updateSelectedButtonState(state);
		}

		protected function handleNavigationEvent(e : FlowNavigationEvent) : void {
			switch (e.subtype) {
				case FlowNavigationEvent.UPDATE:
				// fall through
				case FlowNavigationEvent.WILL_LOAD:
				// fall through
				case FlowNavigationEvent.WILL_UPDATE:
					updateSelectedButtonState(e.name);
					break;
			}
		}

		protected function updateSelectedButtonState(inState : String) : void {
			switch (inState) {
				case AppSettings.HOME_NAME :
					setSelectedButton(tHomeBtn);
					break;
				case AppSettings.GALLERY_NAME :
					setSelectedButton(tGalleryBtn);
					break;
			}
		}

		protected function handleButtonClick(e : MouseEvent) : void {
			switch (e.target) {
				case tHomeBtn:
					FM.goto(AppSettings.HOME_NAME, e.target);
					break;
				case tGalleryBtn:
					FM.goto(AppSettings.GALLERY_NAME, e.target);
					break;
			}
		}

		protected function setSelectedButton(inButton : MenuButton) : void {
			if (mSelectedButton != null) {
				mSelectedButton.select(false);
				mSelectedButton.enable(true);
			}
			mSelectedButton = inButton;
			mSelectedButton.select(true);
			mSelectedButton.enable(false);
		}
	}
}