
package controller {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.asaplibrary.data.array.ArrayEnumerator;
	import org.asaplibrary.data.array.TraverseArrayEnumerator;
	import org.asaplibrary.data.array.TraverseArrayEnumeratorEvent;
	import org.asaplibrary.util.actionqueue.*;
	import org.asaplibrary.util.loader.*;
	
	import ui.ImagePlaceholder;
	import ui.NextButton;
	import ui.ThumbImage;
		
	/**
	This demo illustrates the use of a TraverseArrayEnumerator as a "thumb pager". The enumerator traverses a list of image ids, to be fetched with <code>getCurrentObject</code>, <code>getNextObject</code> and <code>getPreviousObject</code>. The "previous" and "next" buttons are activated/deactivated by events.
	*/
	public class ThumbController extends MovieClip {
		
		public static const IMAGE_LIST:Array = ["Agave.jpg", "Clown-Fish.jpg", "Daisies.jpg", "Dandelion-Seeds.jpg", "Dandelion.jpg", "Faux-Fur.jpg"];
		public static const IMAGE_URL_FOLDER:String = "../img/big/";
		public static const THUMB_URL_FOLDER:String = "../img/thumbs/";
	
		private static const FADE_IN_DURATION:Number = .4; // in seconds
	
		private static const THUMB_WIDTH:Number = 32 + 6; // add borders
		private static const THUMB_HEIGHT:Number = 20 + 6; // add borders
		private static const THUMB_OFFSET:Number = 1; // pixels between thumbs
		
		public var tImage:ImagePlaceholder;
		public var tThumb:ImagePlaceholder;
		public var tPrevious:NextButton;
		public var tNext:NextButton;
		
		private var mThumbs:Object = new Object();
		private var mImageLoader:AssetLoader;
		private var mThumbLoader:AssetLoader;
		private var mThumbPager:TraverseArrayEnumerator;
		private var mFadeQueue:ActionQueue;
		private var mCurrentImage:DisplayObject;
		
		public function ThumbController () {
			super();
			mImageLoader = new AssetLoader();
			mImageLoader.addEventListener(AssetLoaderEvent._EVENT, handleImageLoadDone);
			mThumbLoader = new AssetLoader();
			mThumbLoader.addEventListener(AssetLoaderEvent._EVENT, handleThumbLoadDone);
			initUI();
		}
		
		/**
		Initializes interface variables. Selects the first thumb and loads the corresponding big image.
		*/
		private function initUI () : void {

			// create a thumb enumerator
			mThumbPager = new TraverseArrayEnumerator(createThumbs());
	
			// listen for update events
			mThumbPager.addEventListener(TraverseArrayEnumeratorEvent._EVENT, handleThumbUpdate);
			
			tNext.addEventListener(MouseEvent.CLICK, handleNextClick);
			tPrevious.addEventListener(MouseEvent.CLICK, handleNextClick);
			
			// select first thumb and load corresponding big image
			activateThumb(mThumbPager.getNextObject());
		}
		
		/**
		Called on AssetLoader events.
		*/
		private function handleImageLoadDone (e:AssetLoaderEvent) : void {
			switch (e.subtype) {
				case AssetLoaderEvent.COMPLETE: displayImage(e);
				break;
			}
		}
		
		/**
		Displays and fades in the main image.
		*/
		private function displayImage (e:AssetLoaderEvent) : void {
	
			var image:DisplayObject = e.asset as DisplayObject;
			
			if (mCurrentImage) {
				removeChild(mCurrentImage);
			}
			addChild(image);

			image.x = tImage.x;
			image.y = tImage.y;
			image.alpha = 0;
			image.visible = true;
			
			mCurrentImage = image;
			
			mFadeQueue = new ActionQueue();
			mFadeQueue.addAction(new AQFade().fade(image, FADE_IN_DURATION, 0, 1));
			mFadeQueue.run();
		}
		
		/**
		Called on AssetLoader events.
		*/
		private function handleThumbLoadDone (e:AssetLoaderEvent) : void {
			switch (e.subtype) {
				case AssetLoaderEvent.COMPLETE: displayThumb(e);
				break;
			}
		}
			
		/**
		Displays a thumb image.
		*/
		private function displayThumb (e:AssetLoaderEvent) : void {
	
			var image:DisplayObject = e.asset as DisplayObject;
			var id:String = e.name;
			
			// retrieve thumb
			var thumb:ThumbImage = mThumbs[id];
			thumb.addChild(image);
		}
		
		/**
		Creates and arranges the thumb objects. Starts loading thumb images.
		*/
		private function createThumbs () : Array {
	
			var thumbList:Array = new Array();
			var x:Number = tThumb.x;
			var y:Number = tThumb.y;
			
			var e:ArrayEnumerator = new ArrayEnumerator(IMAGE_LIST);
			var imgName:String;
			
			while (imgName = e.getNextObject()) {
				
				var id:String = imgName;
				var thumb:ThumbImage = new ThumbImage();
				thumb.id = id;
				thumb.name = id;
				thumb.width = THUMB_WIDTH;
				thumb.height = THUMB_HEIGHT;
				thumb.x = x;
				x += THUMB_WIDTH + THUMB_OFFSET;
				thumb.y = y;
				addChild(thumb);
				thumb.addEventListener(MouseEvent.CLICK, handleThumbClick);
				loadThumb(id);
				thumbList.push(thumb);
				
				// store reference to find thumb when it is loaded
				mThumbs[id] = thumb;
			}
			return thumbList;
		}
		
		/**
		Disables the next button if there is a 'next' object, otherwise it is enabled.
		Disables the previous button if there is a 'previous' object, otherwise it is enabled.
		*/
		private function handleThumbUpdate (e:TraverseArrayEnumeratorEvent) : void {
			tNext.enable(mThumbPager.hasNextObject());
			tPrevious.enable(mThumbPager.hasPreviousObject());
			var thumb:ThumbImage = e.value as ThumbImage;
			var id:String = thumb.id;
			loadImage(id);
		}
		
		/**
		Activates a new thumb and orders to load the corresponding main image.
		@param inThumb : the new thumb
		@param inOldThumb : (optional) the old thumb
		*/
		private function activateThumb (inThumb:ThumbImage, 
										inOldThumb:ThumbImage = null) : void {
			if (inOldThumb) {
				inOldThumb.select(false);
			}
			inThumb.select(true); 
		}
		
		/**
		Invokes loading of a new main image.
		*/
		private function loadImage (inId:String) : void {
			var url:String = IMAGE_URL_FOLDER + inId;
			mImageLoader.loadAsset(url, inId);
		}
		
		/**
		Invokes loading of a thumb image.
		*/
		private function loadThumb (inId:String) : void {
			var url:String = THUMB_URL_FOLDER + inId;
			mThumbLoader.loadAsset(url, inId);
		}
		
		/**
		Called when a thumb is clicked.
		*/
		private function handleThumbClick (e:MouseEvent) : void {
			var thumb:ThumbImage = e.currentTarget as ThumbImage;
			var oldThumb:ThumbImage = mThumbPager.getCurrentObject();
			if (thumb == oldThumb) return;
			mThumbPager.setCurrentObject(thumb); // will update the enumerator			
			activateThumb(thumb, oldThumb);
		}
		
		/**
		Called when a next or previous button is clicked.
		*/
		private function handleNextClick (e:MouseEvent) : void {
			var oldThumb:ThumbImage = mThumbPager.getCurrentObject();
			var newThumb:ThumbImage;
			if (MovieClip(e.currentTarget).name == "tNext") {
				newThumb = mThumbPager.getNextObject();
			}
			if (MovieClip(e.currentTarget).name == "tPrevious") {
				newThumb = mThumbPager.getPreviousObject();
			}
			if (newThumb != null) {
				activateThumb(newThumb, oldThumb);
			}
		}
		
	}

}
