package controller {

	import flash.events.Event;
	import flash.display.MovieClip;
	import fl.controls.Button;
	
	import org.asaplibrary.util.loader.AssetLoader;
	import org.asaplibrary.util.loader.AssetLoaderEvent;
	
	import ui.ProgressImage;
	
	public class AppController extends MovieClip {
		
		private static const MULTI_LOADER_COUNT:uint = 8;
		private static const IMAGE_Y_DISTANCE:uint = 50;
		
		private const mImageUrls:Array = [
			"http://www.marsdaily.com/images/nasa-mars-mro-victoria-crater-section-desktop-1280.jpg",
			"http://www.simplydumb.com/wp-content/uploads/2007/07/nasa-drunk.gif",
			"http://img.dailymail.co.uk/i/pix/2007/07_03/nasa1R3107_1000x1000.jpg",
			"http://soho.nascom.nasa.gov/data/summary/gif/050120/seit_00195_fd_20050120_2238.gif",
			"http://home-1.tiscali.nl/~edwinsel/land/sat/corsica,sat,hr%20(nasa)_se.jpg",
			"http://www.ocean.com/resources/FEATURE/wilmacolor.jpg",
			"http://www.spacearchive.info/2007-03-06-nasa-dust-storm-large.jpg",
			"http://www.astro.uio.no/ita/nyheter/HUDF_0304/HUDF_IR_full.jpg",
			"http://nssdc.gsfc.nasa.gov/planetary/image/earth_night.jpg",
			"http://www.jpl.nasa.gov/images/earth/arctic/arctic20070515-hi-res.jpg",
			"http://photojournal.jpl.nasa.gov/jpeg/PIA06141.jpg"
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
				var image:ui.ProgressImage = new ui.ProgressImage();
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