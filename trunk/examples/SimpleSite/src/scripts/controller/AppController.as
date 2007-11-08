package controller {

	import flash.display.MovieClip;

	import org.asaplibrary.management.movie.*;
	import org.asaplibrary.util.actionqueue.*;

	import event.NavigationEvent;
	import data.AppSettings;
	
	public class AppController extends LocalController {
		
		private var mCurrentController:ProjectController;
		
		public var tHomeHolder:MovieClip;
		public var tGalleryHolder:MovieClip;
		public var tMenuHolder:MovieClip;
		
		function AppController () {
			super(AppSettings.MAIN_NAME);
			listen();
			loadMenu();
			gotoHome();
		}
		
		protected function listen () : void {
			// listen for navigation events
			addEventListener(NavigationEvent._EVENT, handleNavigationUpdate);
			
			// Listen for event when movies are loaded and ready to play
			MovieManager.getInstance().addEventListener( MovieManagerEvent._EVENT, onMovieEvent );
		}
		
		protected function loadMenu () : void {
			loadNewMovie(AppSettings.MENU_NAME);
		}
		
		protected function gotoHome () : void {
			dispatchEvent(new NavigationEvent(AppSettings.HOME_NAME, this));
		}
		
		/**
		Handles MovieManagerEvents.
		*/
		protected function onMovieEvent (e:MovieManagerEvent) {
			if (e.subtype == MovieManagerEvent.MOVIE_READY) {
				showMovie(e.controller);
			}
		}
		
		/**
		Handles NavigationEvents.
		*/
		protected function handleNavigationUpdate (e:NavigationEvent) : void {
			var state:String = e.state;
			var navMan:NavigationManager = NavigationManager.getInstance();
			if (state == navMan.getState()) return;
			// else: a new state
			navMan.setState(state);
			
			var lc:LocalController = MovieManager.getInstance().getLocalControllerByName(state, true);
			if (lc != null) {
				// already loaded
				showMovie(lc);
			} else {
				loadNewMovie(state);
			}
		}
		
		protected function showMovie (inController:LocalController) : void {

			switch (inController.getName()) {
				case AppSettings.MENU_NAME:
					tMenuHolder.addChild(inController);
					break;
				case AppSettings.HOME_NAME:
					tHomeHolder.addChild(inController);
					break;
				case AppSettings.GALLERY_NAME:
					tGalleryHolder.addChild(inController);
					break;
			}
			inController.alpha = 0;
			inController.visible = true;
			
			var queue:ActionQueue = new ActionQueue();
						
			switch (inController.getName()) {
				case AppSettings.HOME_NAME:
				case AppSettings.GALLERY_NAME:
					if (mCurrentController != null) {
						// hide old
						queue.addAction( mCurrentController.stopAction );
					}
					mCurrentController = inController as ProjectController;
					break;
			}
			// show new
			queue.addAction( inController.startAction );
			queue.run();
		}

		protected function loadNewMovie (inMovieName:String) : void {
		
			switch (inMovieName) {
				case AppSettings.HOME_NAME:
					MovieManager.getInstance().loadMovie( AppSettings.HOME_URL, AppSettings.HOME_NAME, false );					
					break;
				case AppSettings.GALLERY_NAME:
					MovieManager.getInstance().loadMovie( AppSettings.GALLERY_URL, AppSettings.GALLERY_NAME, false );
					break;
				case AppSettings.MENU_NAME:
					MovieManager.getInstance().loadMovie(AppSettings.MENU_URL, AppSettings.MENU_NAME, false );
					break;
				default:
					break;
			}
		}
			
	}
}