package demo.AccordionWithFlowManager.ui.accordion {
	import org.asaplibrary.management.flow.*;
	import org.asaplibrary.ui.buttons.*;
	import org.asaplibrary.util.actionqueue.*;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class Pane extends FlowSection implements IPaneContent {
		
		public var tBar:Bar;
		public var tContent:PaneContent;
		public var tMask:MovieClip;

		protected var mAccordion:Accordion;
		protected var mParent:Pane; /**< Parent pane. */
		protected var mPrevious:Pane; /**< Previous sibling pane. */
		protected var mState:uint;
		protected var mHeight:Number = 0; /**< Current height. */
		protected var mIndex:int = -1; /**< Index number in accordion. */
		protected var mDelegate:ButtonBehavior;
		protected var mMoveQueue:ActionQueue;
		
		function Pane (inAccordion:Accordion, inIndex:int, inParent:Pane, inPrevious:Pane, inFlowManager:FlowManager) {
			super(null, inFlowManager);

			mIndex = inIndex;
			setAccordion(inAccordion);
			setParent(inParent);
			setPrevious(inPrevious);
			mMoveQueue = new ActionQueue();

			registerWithFlowManager();

			initAppearance();
			initBehavior();
			initSubscriptions();
		}
		
		public override function toString () : String {
			return "Pane: " + getName();
		}

		public function setPrevious (inPrevious:Pane) : void {
			if (mPrevious != null) {
				mPrevious.removeEventListener(PaneEvent._EVENT, handlePreviousPaneUpdate);
			}
			mPrevious = inPrevious;
			if (mPrevious != null) {
				mPrevious.addEventListener(PaneEvent._EVENT, handlePreviousPaneUpdate);
			}
		}
		
		public function setAccordion (inAccordion:Accordion) : void {
			mAccordion = inAccordion;
		}
		
		public function setParent (inParent:Pane) : void {
			if (mParent != null) {
				mParent.removeEventListener(PaneEvent._EVENT, handleClosingPaneUpdate);
			}
			mParent = inParent;
			if (mParent != null) {
				mParent.addEventListener(PaneEvent._EVENT, handleClosingPaneUpdate);
			}
		}
		
		/**
		The pane bar MovieClip.
		*/
		public function get bar () : Bar {
			return tBar;
		}
		
		/**
		Creates a nested name structure based on the index value and the parent pane's index.
		For example sub-pane '1' in pane '0' has the name '0.1'.
		*/
		public override function getName () : String {
			if (mIndex == -1) return null;
			var parentNames:Array = getParentNames();
			return parentNames.join(".");
		}
		
		public function isOpen () : Boolean {
			return mState == PaneOptions.OPEN;
		}
		
		public function update () : void {	
			var h:Number = isOpen() ? tContent.height : mHeight - heightClosed;
			height = h;
		}
		
		protected function setHeight (inHeight:Number) : void {
			height = inHeight;
		}
		
		public override function get height () : Number {
			return mHeight;
		}
		
		/**
		The bottom y position.
		*/
		public function get bottom () : Number {
			return y + height;
		}
		
		public function setState (inState:uint) : void {
			mState = inState;
		}
		
		public function getState () : uint {
			return mState;
		}
		
		public override function set height (inHeight:Number) : void {
			tMask.height = inHeight;
			mHeight = inHeight + heightClosed;
			if (mParent != null) {
				mParent.update();
			}
			dispatchEvent(new PaneEvent(PaneEvent.CHANGE, this));
			if (inHeight <= contentHeightClosed && mState != PaneOptions.CLOSED) {
				setClosed();
			}
		}
		
		public override function set y (inY:Number) : void {
			super.y = inY;
			dispatchEvent(new PaneEvent(PaneEvent.CHANGE, this));
		}
		
		public override function get startAction () : IAction {
			mMoveQueue.addAction(mDelegate.select, true);
			mMoveQueue.addAction(new AQFunction().call(setHeight, mAccordion.getDuration(), getContentHeight(), tContent.height, mAccordion.getEffect()));
			mMoveQueue.addAction(setState, PaneOptions.OPEN);
			return mMoveQueue;
		}
		
		public override function get stopAction () : IAction {
		
			if (mParent != null && mParent.getState() == PaneOptions.CLOSING) {
				// parent is closing, do nothing
				// (will get notified in handleClosingPaneUpdate)
				return;
			}
			// else (no closing parent)
			mMoveQueue.addAction(mDelegate.select, false);
			mMoveQueue.addAction(new AQFunction().call(setHeight, mAccordion.getDuration(), getContentHeight(), 0, mAccordion.getEffect()));
			mMoveQueue.addAction(setClosed);
			return mMoveQueue;
		}

		public function getIndex () : int {
			return mIndex;
		}
		
		public function setContent (inObject:Object) : void {
			if (inObject is DisplayObject) {
				tContent.setContent(DisplayObject(inObject));
			}
			height = 0;
		}
		
		protected function handlePreviousPaneUpdate (e:PaneEvent) : void {
			if (e.subtype == PaneEvent.CHANGE ) {
				if (e.pane == mPrevious) {
					y = e.pane.bottom;
				}
			}
		}
		
		protected function handleClosingPaneUpdate (e:PaneEvent) : void {
			if (e.subtype == PaneEvent.CLOSED ) {
				height = contentHeightClosed;
			}
		}
		
		protected function initAppearance () : void {
			visible = true;
			buttonMode = true;
		}
		
		protected function initBehavior () : void {
			mDelegate = new ButtonBehavior(this);
			mDelegate.addEventListener(ButtonBehaviorEvent._EVENT, updateBarStatus);
		}
		
		protected function initSubscriptions () : void {			
			tBar.addEventListener(MouseEvent.CLICK, handleBarClick);
		}
		
		protected function getParentNames (names:Array = null) : Array {
			if (names == null) names = new Array();
			names.unshift(String(mIndex));
			if (mParent == null) return names;
			// else 
			return mParent.getParentNames(names);
		}
		
		protected function get contentHeightClosed () : Number {
			return 0;
		}
		
		protected function get heightClosed () : Number {
			return contentHeightClosed + tBar.height;
		}
		
		protected function getContentHeight () : Number {
			return height - heightClosed;
		}
		
		protected function setClosed () : void {
			setState(PaneOptions.CLOSED);
			mDelegate.select(false);
			dispatchEvent(new PaneEvent(PaneEvent.CLOSED, this));
		}
		
		/**
		Handles the visual state of the bar.
		*/
		protected function updateBarStatus (e:ButtonBehaviorEvent) : void {
		
			switch (e.state) {
				case ButtonStates.SELECTED:
					tBar.drawSelected();
					break;
				case ButtonStates.OVER:
					tBar.drawOver();
					break;
				case ButtonStates.NORMAL:
				case ButtonStates.OUT:
				case ButtonStates.DESELECTED:
					tBar.drawNormal();
					break;
			}
		}
		
		protected function handleBarClick (e:MouseEvent) : void {
			var name:String = getName();
			var current:String = getFlowManager().getCurrentSectionName();
			if (current != name) {
				if (!isOpen()) {
					getFlowManager().goto(name);
					return;
				}
			}
			// so close current: back to parent
			// unless there is no parent: back to null (close all)
			var parentName:String = null;
			if (mParent != null) {
				parentName = mParent.getName();
			}
			getFlowManager().goto(parentName);
		}
		
	}
}