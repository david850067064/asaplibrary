package demo.NotificationCenter.controller {
	import org.asaplibrary.management.movie.*;

	/**
	This example movie shows how NotificationCenter can be used to communicate between objects that do not know each other.
	Here, clicking on the retangular sender button causes a Notification to be sent to any object that is subscribed to its name. The externally loaded Observer will start responding after an observer has been added.
	 */
	public class AppController extends LocalController {
		private const OBSERVER_URL:String = "Observer.swf";
		
		function AppController() {
			MovieManager.getInstance().addEventListener(MovieManagerEvent._EVENT, handleMovieManager);
			MovieManager.getInstance().loadMovie(OBSERVER_URL, "Observer");
		}

		private function handleMovieManager(e : MovieManagerEvent) : void {
			if (e.subtype != MovieManagerEvent.MOVIE_READY) return;
			addChild(e.container);
		}
	}
}
