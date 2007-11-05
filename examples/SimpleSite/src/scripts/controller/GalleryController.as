package controller {
	
	import org.asaplibrary.management.movie.*;
	
	import data.AppSettings;
	
	public class GalleryController extends ProjectController {
		
		function GalleryController () {
			super(AppSettings.GALLERY_NAME);
		}

	}
	
}