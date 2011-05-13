package demo.SimpleSiteWithFlowManager.controller {
	import demo.SimpleSiteWithFlowManager.data.AppSettings;

	public class GallerySection extends ProjectSection {
		function GallerySection() {
			super(AppSettings.GALLERY_NAME);
			if (isStandalone()) {
				startStandalone();
			}
		}
	}
}