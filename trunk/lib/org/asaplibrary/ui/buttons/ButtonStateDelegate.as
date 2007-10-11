package org.asaplibrary.ui.buttons {
	
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.asaplibrary.ui.buttons.ButtonStateDelegateEvent;
	
	public class ButtonStateDelegate extends EventDispatcher {
		
		public static const NONE:uint =       0;
		
		public static const NORMAL:uint =     (1<<1);
		public static const OVER:uint =       (1<<2);
		public static const OUT:uint =        (1<<3);
		public static const ENABLED:uint =    (1<<4);
		public static const DISABLED:uint =   (1<<5);
		public static const SELECTED:uint =   (1<<6);
		public static const DESELECTED:uint = (1<<7);


		/**
		The selected state. Usually this means the button will be highlighted and not clickable.
		*/
		protected var mSelected:Boolean = false;
		
		/**
		
		*/
		protected var mEnabled:Boolean = true;
		
		
		/**
		
		*/
		protected var mRollOver:Boolean = false;
		
		/**
		
		*/
		protected var mPressed:Boolean = false;
		
		/**
		
		*/
		protected var mState:uint;
		
		/**
		
		*/
		public function ButtonStateDelegate (inButton:MovieClip) {
			inButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			inButton.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			inButton.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			inButton.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			//inButton.addEventListener(MouseEvent.CLICK, clickHandler);
			//inButton.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			//inButton.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			
			update();
		}
	
		/**
		
		*/
		public function select (inState:Boolean) : void {
			var changed:Boolean = mSelected != inState;
			mSelected = inState;
			if (changed) {
				update(null, mSelected ? SELECTED : DESELECTED);
			}
		}

		/**
		
		*/
		public function enable (inState:Boolean) : void {
			var changed:Boolean = mEnabled != inState;
			mEnabled = inState;
			if (changed) {
				update(null, mEnabled ? ENABLED : DISABLED);
			}
		}

		/**
		
		*/
		protected function mouseDownHandler (e:MouseEvent = null) : void {
			mPressed = true;
			mRollOver = true;
			if (mSelected || !mEnabled) return;
			update(e, OVER);
		}
		
		/**
		
		*/
		protected function mouseOutHandler (e:MouseEvent = null) : void {
			mPressed = false;
			mRollOver = false;
			if (mSelected || !mEnabled) return;
			update(e, OUT);
		}
		
		/**
		
		*/
		protected function mouseOverHandler (e:MouseEvent = null) : void {
			mRollOver = true;
			if (mSelected || !mEnabled) return;
			update(e, OVER);
		}
		
		/**
		
		*/
		protected function mouseUpHandler (e:MouseEvent = null) : void {
			mPressed = false;
			if (mSelected || !mEnabled) return;
			update(e, OVER);
		}
		
		/**
		
		*/
		protected function update (e:MouseEvent = null, inState:uint = NONE) : void {
			var drawState:uint = inState;
			if (drawState == NONE) {
				drawState = NORMAL;
			}
			
			if (mState == drawState) return;
		
			dispatchEvent(new ButtonStateDelegateEvent(
				ButtonStateDelegateEvent.UPDATE,
				drawState,
				mSelected,
				mEnabled,
				mPressed,
				e
			));			
			mState = drawState;
		}
	}
}