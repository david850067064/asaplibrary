package controller {

	import flash.events.MouseEvent;	
	// ASAP Library classes
	import data.AppSettings;
	import event.NavigationEvent;	
	import ui.MenuButton;	

	public class MenuController extends ProjectController {
	
		public var tHomeBtn:MenuButton;
		public var tGalleryBtn:MenuButton;
				
		private var mSelectedButton:MenuButton;
					
		function MenuController () {
			super();
			listen();
			selfUpdate();
		}
		
		protected function listen () : void {
			NavigationManager.getInstance().addEventListener( NavigationEvent._EVENT, handleNavigationUpdate );
			
			tHomeBtn.addEventListener(MouseEvent.CLICK, handleButtonClick);
			tGalleryBtn.addEventListener(MouseEvent.CLICK, handleButtonClick);
		}
		
		protected function selfUpdate () : void {
			var state:String = NavigationManager.getInstance().getState();
			updateSelectedButtonState(state);
		}
		
		protected function handleNavigationUpdate (e:NavigationEvent) : void {
			updateSelectedButtonState(e.state);
		}
		
		protected function updateSelectedButtonState (inState:String) : void {
			switch (inState) {
				case AppSettings.HOME_NAME :
					setSelectedButton(tHomeBtn);
					break;
				case AppSettings.GALLERY_NAME :
					setSelectedButton(tGalleryBtn);
					break;
				default:
					//
			}
		}
		
		protected function handleButtonClick (e:MouseEvent) : void {
			switch (e.target) {
				case tHomeBtn:
					dispatchEvent(new NavigationEvent(AppSettings.HOME_NAME, this));
					break;
				case tGalleryBtn:
					dispatchEvent(new NavigationEvent(AppSettings.GALLERY_NAME, this));
					break;
				default:
					//
			}
		}
		
		protected function setSelectedButton (inButton:MenuButton) : void {
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