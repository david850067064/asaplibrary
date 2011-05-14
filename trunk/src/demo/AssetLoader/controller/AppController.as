package demo.AssetLoader.controller {

	import flash.events.Event;
	import flash.display.MovieClip;
	import fl.controls.Button;
	
	import org.asaplibrary.util.loader.AssetLoader;
	import org.asaplibrary.util.loader.AssetLoaderEvent;
	
	import demo.AssetLoader.ui.ProgressImage;
	
	public class AppController extends MovieClip {
		
		private static const MULTI_LOADER_COUNT:uint = 8;
		private static const IMAGE_Y_DISTANCE:uint = 50;
		
		private const mImageUrls:Array = [
			"http://imgsrc.hubblesite.org/hu/db/images/hs-2011-14-b-xlarge_web.jpg",
			"http://imgsrc.hubblesite.org/hu/db/images/hs-2011-11-a-xlarge_web.jpg",
			"http://imgsrc.hubblesite.org/hu/db/images/hs-2011-08-a-xlarge_web.jpg",
			"http://imgsrc.hubblesite.org/hu/db/images/hs-2011-06-a-xlarge_web.jpg",
			"http://imgsrc.hubblesite.org/hu/db/images/hs-2011-01-b-xlarge_web.jpg",
			"http://imgsrc.hubblesite.org/hu/db/images/hs-2010-27-a-xlarge_web.jpg",
			"http://imgsrc.hubblesite.org/hu/db/images/hs-2010-36-a-xlarge_web.jpg",
			"http://imgsrc.hubblesite.org/hu/db/images/hs-2010-29-a-xlarge_web.jpg",
			"http://imgsrc.hubblesite.org/hu/db/images/hs-2010-24-a-xlarge_web.jpg",
			"http://imgsrc.hubblesite.org/hu/db/images/hs-2010-13-e-xlarge_web.jpg",
			"http://imgsrc.hubblesite.org/hu/db/images/hs-2009-29-b-xlarge_web.jpg"
		];
		private var mImageClips:Object;
		private var mLoader:AssetLoader;
		
		public var tProgress:MovieClip;
		public var tImagesCombined:MovieClip;
		public var tImagesSingle:MovieClip;
		public var tSingleButton:Button;
		public var tCombinedButton:Button;
		
		function AppController ( ) {
			super();
			initUI();
		}
		
		private function initUI () : void {
			initUICombined();
			initUISingle();
		}
		
		private function initUICombined () : void {
			mImageClips = new Object();
			tCombinedButton.addEventListener("click", loadImagesCombined);
			tProgress.scaleX = 0;
		}
		
		private function initUISingle () : void {
			tSingleButton.addEventListener("click", loadImagesSingle);
		}
		
		/**
		Loads images with 1 (combined) AssetLoader.
		*/
		private function loadImagesCombined (e:Event) : void {
			mLoader = new AssetLoader( MULTI_LOADER_COUNT );
			mLoader.addEventListener( AssetLoaderEvent._EVENT, handleLoaderEvent );
			
			var i:uint, ilen:uint = mImageUrls.length;
			for (i=0; i<ilen; ++i) {
				var image:MovieClip = new MovieClip();
				tImagesCombined.addChild(image);
				image.y = i*IMAGE_Y_DISTANCE;
				var name:String = String(i);
				mImageClips[name] = image;
				mLoader.loadAsset(mImageUrls[i], name);
			}
		}
		
		/**
		Loads images with a AssetLoader for each image.
		*/
		private function loadImagesSingle (e:Event) : void {
			var i:uint, ilen:uint = mImageUrls.length;
			for (i=0; i<ilen; ++i) {
				var image:demo.AssetLoader.ui.ProgressImage = new demo.AssetLoader.ui.ProgressImage();
				tImagesSingle.addChild(image);
				image.y = i*IMAGE_Y_DISTANCE;
				image.load( mImageUrls[i] );
			}
		}
		
		/**
		Triggered by combined AssetLoader. Called when all images are loaded.
		*/
		private function handleLoaderEvent ( e:AssetLoaderEvent ) : void {
			switch (e.subtype) {
				case AssetLoaderEvent.PROGRESS:
					var totalLoaded:uint = mLoader.getTotalBytesLoaded();
					var totalBytesCount:uint = mLoader.getTotalBytesCount();
					tProgress.scaleX = Number(totalLoaded) / Number(totalBytesCount);
					break;
				case AssetLoaderEvent.COMPLETE:
					var image:MovieClip = mImageClips[e.name];
					e.asset.alpha = .7;
					image.addChild(e.asset);
					break;
				case AssetLoaderEvent.ALL_LOADED:
					tProgress.scaleX = 0;
					break;
				case AssetLoaderEvent.ERROR:
					reportError(e.error);
					break;
			}
		}
		
		private function reportError (inError:String) : void {
			trace("Combined loader error:" + inError);
		}
	}
}