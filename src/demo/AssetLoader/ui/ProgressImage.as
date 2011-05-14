package demo.AssetLoader.ui {
	import org.asaplibrary.util.loader.AssetLoader;
	import org.asaplibrary.util.loader.AssetLoaderEvent;

	import flash.display.MovieClip;

	/**
	Loads an image or swf into the clip the class is attached to.
	 */
	public class ProgressImage extends MovieClip {
		private var mLoader : AssetLoader;
		private var mContent : MovieClip;
		private var mProgess : MovieClip;
		private static const PROGRESS_BAR_WIDTH : Number = 500;
		private static const PROGRESS_BAR_HEIGHT : Number = 4;

		function ProgressImage() {
			super();
		}

		private function initUI() : void {
			// check container
			if (mContent == null) {
				mContent = new MovieClip();
				addChild(mContent);
			}
			// check progress bar
			if (mProgess == null) {
				mProgess = new MovieClip();
				addChild(mProgess);
				with(mProgess.graphics) {
					lineStyle(0, 0x000000, 0);
					beginFill(0x000000, 50);
					moveTo(0, 0);
					lineTo(PROGRESS_BAR_WIDTH, 0);
					lineTo(PROGRESS_BAR_WIDTH, PROGRESS_BAR_HEIGHT);
					lineTo(0, PROGRESS_BAR_HEIGHT);
					lineTo(0, 0);
					endFill();
				}
				mProgess.scaleX = 0;
			}
		}

		/**
		Loads the image or swf.
		 */
		public function load(inURL : String) : void {
			initUI();
			mLoader = new AssetLoader();
			mLoader.addEventListener(AssetLoaderEvent._EVENT, handleLoaderEvent);
			mLoader.loadAsset(inURL, inURL);
		}

		/**
		Triggered by combined AssetLoader. Called when all images are loaded.
		 */
		private function handleLoaderEvent(e : AssetLoaderEvent) : void {
			switch (e.subtype) {
				case AssetLoaderEvent.PROGRESS:
					mProgess.scaleX = 1.0 * (Number(e.loadedBytesCount) / Number(e.totalBytesCount));
					break;
				case AssetLoaderEvent.COMPLETE:
					e.asset.alpha = .7;
					mContent.addChild(e.asset);
					mProgess.scaleX = 0;
					break;
				case AssetLoaderEvent.ERROR:
					reportError(e.error);
					break;
			}
		}

		private function reportError(inError : String) : void {
			trace("Single loader error:" + inError);
		}
	}
}