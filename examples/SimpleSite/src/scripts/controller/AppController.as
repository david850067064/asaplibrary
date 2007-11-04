package controller {

	import flash.display.MovieClip;

	import org.asaplibrary.management.movie.*;
	import org.asaplibrary.util.actionqueue.*;

	import event.NavigationEvent;
	import data.AppSettings;
	
	public class AppController extends LocalController {
		
		private static const FADE_OUT_DURATION:Number = .2;
		private static const FADE_IN_DURATION:Number = .7;
		
		public var tMovieHolder:MovieClip;
		public var tMenuHolder:MovieClip;
		
		private var mCurrentController:LocalController;
		
		function AppController () {
			super("AppController");
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
			
			var lc:LocalController = MovieManager.getInstance().getLocalControllerByName(state);
			if (lc != null) {
				// already loaded
				showMovie(lc);
			} else {
				loadNewMovie(state);
			}
		}
		
		protected function showMovie (inController:LocalController) : void {

			addChild(inController);
			inController.alpha = 0;
			inController.visible = true;
			
			var queue:ActionQueue = new ActionQueue();
			const CURRENT:Number = Number.NaN;
			
			switch (inController.getName()) {
				case AppSettings.HOME_NAME:
				case AppSettings.GALLERY_NAME:
					if (mCurrentController != null) {
						// hide old
						queue.addAction( new AQFade().fade( mCurrentController, FADE_OUT_DURATION, CURRENT, 0 ));
						queue.addAction( new AQSet().setVisible( mCurrentController, false));
					}
					mCurrentController = inController;
					break;
				default:
					//
			}
			// show new
			queue.addAction( new AQFade().fade(inController, FADE_IN_DURATION, 0, 1));
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