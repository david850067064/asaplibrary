package org.asaplibrary.management.movie {
	
	import flash.display.DisplayObject;

	import asunit.framework.TestCase;
	import org.asaplibrary.management.movie.*;
	import org.asaplibrary.util.loader.AssetLoader;
	import org.asaplibrary.util.FrameDelay;

	public class MovieManagerTestCase extends TestCase {

		private static const TEST_DELAY:Number = 31;

		private static const MOVIE_NAME:String = "MM_TEST_MOVIE";
		private static const MOVIE_URL:String = "testdata/LocalControllerTestCase.swf";
		
		private static var sLoadedCalled:Number = 0;
		private static const EXPECTED_LOADED_CALLED:Number = 1;
		
		private static var sInitializedCalled:Number = 0;
		private static const EXPECTED_INITIALIZED_CALLED:Number = 1;
		
		private static var sReadyCalled:Number = 0;
		private static const EXPECTED_READY_CALLED:Number = 1;
		
		public override function run () : void {
			new FrameDelay(assertResults, TEST_DELAY);
			super.run();
		}
		
		public function testConstructor() : void {
			var instance:MovieManager = MovieManager.getInstance();
			assertTrue("MovieManager testConstructor", instance);
		}
		
		public function testGetLoader() : void {
			var instance:MovieManager = MovieManager.getInstance();
			var loader:AssetLoader = instance.getLoader();
			assertTrue("MovieManager getLoader", loader != null);
			assertTrue("MovieManager getLoader", loader is AssetLoader);
		}
		
		public function testLoadMovie() : void {
			var instance:MovieManager = MovieManager.getInstance();
			instance.addEventListener(MovieManagerEvent._EVENT, handleMovieLoaded);
			instance.loadMovie(MOVIE_URL, MOVIE_NAME);
		}
		
		private function handleMovieLoaded (e:MovieManagerEvent) : void {
			switch (e.subtype) {
				case MovieManagerEvent.MOVIE_LOADED:
					sLoadedCalled++;
					break;
				case MovieManagerEvent.CONTROLLER_INITIALIZED: 
					sInitializedCalled++;
					break;
				case MovieManagerEvent.MOVIE_READY:
					sReadyCalled++;
					assertTrue("handleMovieLoaded container", e.controller is LocalController);
					assertTrue("handleMovieLoaded container", e.container is DisplayObject);
					assertTrue("handleMovieLoaded getLocalControllerByName", MovieManager.getInstance().getLocalControllerByName(MOVIE_NAME, true) == e.controller);
					// show
					addChild(e.container);
					
					MovieManager.getInstance().removeMovie(MOVIE_NAME);
					
					assertTrue("handleMovieLoaded removeMovie", MovieManager.getInstance().getLocalControllerByName(MOVIE_NAME, true) == null);
					MovieManager.getInstance().removeEventListener(MovieManagerEvent._EVENT, handleMovieLoaded);
					break;
			}
		}
		
		private function assertResults () : void {
			assertTrue("assertResults sLoadedCalled", sLoadedCalled == EXPECTED_LOADED_CALLED);
			assertTrue("assertResults sInitializedCalled", sInitializedCalled == EXPECTED_INITIALIZED_CALLED);
			assertTrue("assertResults sReadyCalled", sReadyCalled == EXPECTED_READY_CALLED);
		}
	}
}

