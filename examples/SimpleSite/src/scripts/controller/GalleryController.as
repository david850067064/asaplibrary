package controller {
	
	import org.asaplibrary.management.movie.*;
	
	import data.AppSettings;
	
	public class GalleryController extends LocalController {
		
		function GalleryController () {
			super(AppSettings.GALLERY_NAME);
		}

	}
	
}