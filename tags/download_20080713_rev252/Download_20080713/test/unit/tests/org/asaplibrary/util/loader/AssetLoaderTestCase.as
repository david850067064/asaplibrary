/**
@todo
How to test a loading error?
*/

package org.asaplibrary.util.loader {
	
	import asunit.framework.TestCase;
	import org.asaplibrary.util.loader.*;
	import org.asaplibrary.util.FrameDelay;

	public class AssetLoaderTestCase extends TestCase {
		
		private static const IMG_URL_GOOD:String = "testdata/AssetLoaderTestCase.png";
		private static const IMG_URL_BAD:String = "testdata/AssetLoaderTestCase_bad.png";
		private static const TEST_DELAY:Number = 62;

		private static var sCompleteCalled:Number = 0;
		private static const EXPECTED_COMPLETE_CALLED:Number = 2;
		
		//private static var sErrorCalled:Number = 0;
		//private static const EXPECTED_ERROR_CALLED:Number = 1;
		
		
		public override function run () : void {
			new FrameDelay(assertResults, TEST_DELAY);
			super.run();
		}
		
		public function testLoadAsset () : void {
			var loader:AssetLoader = new AssetLoader();
			loader.addEventListener(AssetLoaderEvent._EVENT, handleLoaded);
			loader.loadAsset(IMG_URL_GOOD, "good");
		}
		
		/*
		public function testLoadAssetBad () : void {
			var loader:AssetLoader = new AssetLoader();
			loader.addEventListener(AssetLoaderEvent._EVENT, handleLoaded);
			loader.loadAsset(IMG_URL_BAD, IMG_LOAD_NAME_BAD, false);
		}
		*/
		
		public function testStopLoadingAll () : void {
			var loader:AssetLoader = new AssetLoader();
			loader.addEventListener(AssetLoaderEvent._EVENT, handleLoaded);
			loader.loadAsset(IMG_URL_GOOD, "all");
			loader.stopLoadingAll();
		}
		
		public function testStopAsset () : void {
			var loader:AssetLoader = new AssetLoader();
			loader.addEventListener(AssetLoaderEvent._EVENT, handleLoaded);
			loader.loadAsset(IMG_URL_GOOD, "stop");
			loader.stopLoadingAsset("stop");
		}
		
		public function testStopAssetWrongName () : void {
			var loader:AssetLoader = new AssetLoader();
			loader.addEventListener(AssetLoaderEvent._EVENT, handleLoaded);
			loader.loadAsset(IMG_URL_GOOD, "wrong");
			loader.stopLoadingAsset("xxx");
		}
		
		private function handleLoaded (e:AssetLoaderEvent) : void {			
			switch (e.subtype) {
				case AssetLoaderEvent.COMPLETE: /*trace("COMPLETE: " + e);*/ AssetLoaderTestCase.sCompleteCalled++; break;
				//case AssetLoaderEvent.ERROR: trace("ERROR: " + e); AssetLoaderTestCase.sErrorCalled++; break;
			}
		}
		
		private function assertResults () : void {
			assertTrue("assertResults sCompleteCalled", sCompleteCalled == EXPECTED_COMPLETE_CALLED);
			//assertTrue("assertResults sErrorCalled", sErrorCalled == EXPECTED_ERROR_CALLED);
		}
	}
}
