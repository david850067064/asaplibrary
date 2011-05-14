package demo.Form.controller {
	import org.asaplibrary.util.debug.Log;
	import org.asaplibrary.util.loader.AssetLoader;
	import org.asaplibrary.util.loader.AssetLoaderEvent;

	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author eric-paul.lecluse
	 */
	public class AssetManager extends EventDispatcher {
		private static const theInstance : AssetManager = new AssetManager();

		public static function getInstance() : AssetManager {
			return theInstance;
		}

		private var mAssetLoader : AssetLoader;
		/** objects of type RuntimeAsset */
		private var mAssetList : Array = [];

		public function AssetManager() {
			if (theInstance) throw new Error("Singleton: use AssetManager.getInstance()");

			mAssetLoader = new AssetLoader();
			mAssetLoader.addEventListener(AssetLoaderEvent._EVENT, handleAssetLoaderEvent);
		}

		/**
		 * Load new asset provider
		 * @param inSWFName: unique identifier
		 * @param inPath: location of swf
		 */
		public function loadSWF(inSWFName : String, inPath : String = "") : void {
			mAssetLoader.loadAsset(inPath + inSWFName, inSWFName);
		}

		/**
		 * Instantiate a new asset, optionally from a named asset
		 * Loops over all assets and tries to instantiate from the requested class.
		 * @param inLinkageClassName the string classname of the Flash IDE library asset.
		 * @param inAssetName:(optional) name of asset to load from; if not provided, all assets are searched
		 * @throws an error if the linked class was not found in any asset, or no asset was found with the specified asset name
		 */
		public function instantiate(inLinkageClassName : String, inAssetName : String = null) : DisplayObject {
			var ra : RuntimeAsset;

			// if asset name provided, load from specified asset
			if (inAssetName) {
				ra = getAssetByName(inAssetName);
				if (!ra) throw new Error("Asset with name " + inAssetName + " not found.");

				return new (ra.info.applicationDomain.getDefinition(inLinkageClassName))();
			}

			// if asset name not provided, load from any asset
			var leni : uint = mAssetList.length;
			for (var i : uint = 0; i < leni; i++) {
				try {
					ra = mAssetList[i];
					return new (ra.info.applicationDomain.getDefinition(inLinkageClassName))();
				} catch (e : Error) {
				}
			}
			throw new Error("Linked Class not found in any asset: " + inLinkageClassName);
		}

		private function handleAssetLoaderEvent(e : AssetLoaderEvent) : void {
			switch (e.subtype) {
				case AssetLoaderEvent.ERROR:
					Log.error("handleAssetLoaderEvent error: " + e.error, toString());
					dispatchEvent(new AssetEvent(AssetEvent.ERROR, e.name));
					break;
				case AssetLoaderEvent.START:
					var se : AssetEvent = new AssetEvent(AssetEvent.START, e.name);
					se.loadedBytesCount = 0;
					se.totalBytesCount = e.totalBytesCount;
					dispatchEvent(se);
					break;
				case AssetLoaderEvent.PROGRESS:
					var pe : AssetEvent = new AssetEvent(AssetEvent.PROGRESS, e.name);
					pe.loadedBytesCount = e.loadedBytesCount;
					pe.totalBytesCount = e.totalBytesCount;
					dispatchEvent(pe);
					break;
				case AssetLoaderEvent.COMPLETE:
					handleAssetLoaded(e);
					break;
				case AssetLoaderEvent.ALL_LOADED:
					dispatchEvent(new AssetEvent(AssetEvent.ALL_COMPLETE, e.name));
					break;
			}
		}

		private function handleAssetLoaded(e : AssetLoaderEvent) : void {
			var ra : RuntimeAsset = new RuntimeAsset();
			ra.name = e.name;
			ra.instance = e.asset;
			ra.info = e.loaderInfo;
			ra.bytes = e.loadedBytesCount;
			ra.loader = e.loader;
			mAssetList.push(ra);

			dispatchEvent(new AssetEvent(AssetEvent.COMPLETE, e.name));
		}

		private function getAssetByName(inAssetName : String) : RuntimeAsset {
			var leni : uint = mAssetList.length;
			for (var i : uint = 0; i < leni; i++) {
				var ra : RuntimeAsset = mAssetList[i];
				if (ra.name == inAssetName) return ra;
			}
			Log.error("getAssetByName: name not found " + inAssetName, toString());
			return null;
		}

		override public function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.LoaderInfo;

class RuntimeAsset {
	public var name : String;
	public var info : LoaderInfo;
	public var instance : DisplayObject;
	public var loader : Loader;
	public var bytes : int;

	public function toString() : String {
		return "; RuntimeAsset ";
	}
}
