package demo.AccordionWithFlowManager.ui.accordion {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;	

	public class PaneContent extends MovieClip implements IPaneContent {
				
		public function setContent (inObject:Object) : void {
			var displayObject:DisplayObject = inObject as DisplayObject;
			if (displayObject == null) return;
			try {
				removeChildAt(0);
			} catch (e:RangeError) {
				//
			}
			addChild(displayObject);
		}
		
		public override function get height () : Number {
			var contentObject:DisplayObject;
			try {
				contentObject = getChildAt(0);
			} catch (e:RangeError) {
				//
			}
			if (contentObject != null) {
				return contentObject.height * contentObject.scaleY;
			}
			// else  
			return super.height * scaleY;
		}

	}
}