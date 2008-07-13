package org.asaplibrary.util.actionqueue {
	
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	
	import asunit.framework.TestCase;
	import AsUnitTestRunner;
	import org.asaplibrary.util.actionqueue.*;
	import org.asaplibrary.util.FrameDelay;
	import org.asaplibrary.util.debug.Log;
	
	/**
	@todo Markers
	*/
	public class ActionQueueTestCase extends TestCase {
		
		private static var sAddActionCalled:int = 0;
		private static const EXPECTED_ADD_ACTION_CALLED_COUNT:int = 2;
		private static var sAddActionParams:String = "";
		private static const EXPECTED_ADD_ACTIONS_PARAMS:String = "A";
		private static var sTestInsertQueueParams:String = "";
		private static const EXPECTED_INSERT_QUEUE_PARAMS:String = "ABECD";
		private static var sTestaddActionCount:Number = 0;
		private static const EXPECTED_ADD_METHOD_COUNT = 4;
		private static var sTestInsertQueueActionsString:String = "";
		private static const EXPECTED_INSERT_QUEUE_ACTIONS:String = "ABCDE";
		private static var sTestSkipValue:int = 0;
		private static const EXPECTED_SKIP_VALUE:int = 1;
		private static var sResetQueueValue:Number = 0;
		private static const EXPECTED_RESET_QUEUE_VALUE:Number = 1;
		private static var sAfterPauseValue:Number = 0;
		private static const EXPECTED_AFTER_PAUSE_VALUE:Number = 1;
		
		private static var SHAPE_PROPERTY_HEIGHT:Shape;
		private static const EXPECTED_PROPERTY_HEIGHT:Number = 98;
		private static var SHAPE_PROPERTY_Y:Shape;
		private static const EXPECTED_PROPERTY_Y:Number = 401;
		
		private static var sEventSTARTEDCalled:uint = 0;
		private static const EXPECTED_EVENT_STARTED_CALLED:uint = 1;
		private static var sEventFINISHEDCalled:uint = 0;
		private static const EXPECTED_EVENT_FINISHED_CALLED:uint = 2;
		private static var sEventQUITCalled:uint = 0;
		private static const EXPECTED_EVENT_QUIT_CALLED:uint = 1;
		private static var sEventPAUSEDCalled:uint = 0;
		private static const EXPECTED_EVENT_PAUSED_CALLED:uint = 1;
		private static var sEventRESUMEDCalled:uint = 0;
		private static const EXPECTED_EVENT_RESUMED_CALLED:uint = 1;
		private static var sEventSTOPPEDCalled:uint = 0;
		private static const EXPECTED_EVENT_STOPPED_CALLED:uint = 1;
		
		private static var sOrderedEventList:String = "";
		private static const EXPECTED_ORDERED_EVENT_LIST:String = "onActionStartedonActionFinished";
		
		// Not tested yet
		private static var sEventMARKER_PASSEDCalled:uint = 0;
		private static const EXPECTED_EVENT_MARKER_PASSED_CALLED:uint = 0;
		
		private static var sLoopCalled:Number = 0;
		private static const EXPECTED_LOOP_CALLED:Number = 3;
		
		private static const TEST_DELAY:Number = 31;
		private static const CURRENT:Number = Number.NaN;

		private var mInstance:ActionQueueTestCase = this as ActionQueueTestCase;
		private var mCanvas : Sprite;

		
		public function ActionQueueTestCase (inCanvas:Sprite) {
			super();
			
			mCanvas = inCanvas;
		}
		
		/**
		List tests that should be run first - before any function starting with 'test'.
		*/
		public override function run() : void {

			doTestAddAction();
			doTestAddActionBeforeAndAfter();
			doTestReset();
			//doTestQuit();
			doTestIsFinished();
			doTestPauseAndContinue();
			doTestTogglePlay();
			doTestAddPause();
			doTestSkip();

			doTestFade();
			doTestMove();
			doTestScale();
			doTestAddAsynchronousAction();
			doTestSet();
			doTestAddMove();
			doTestFollowMouse();
			doTestBlink();
			doTestPulse();
			doTestProperty();
			doTestEvents();
			doTestEventsOrder();
			doTestLoops();
			
			new FrameDelay(startTests, TEST_DELAY);
		}
		
		/**
		Now call each public function starting with 'test'.
		*/
		public function startTests () : void {
			super.run();
		}
		
		public function testEvaluateResult () : void {

			assertTrue("ActionQueueTestCase sAddActionCalled", sAddActionCalled == EXPECTED_ADD_ACTION_CALLED_COUNT);

			assertTrue("ActionQueueTestCase sAddActionParams", sAddActionParams == EXPECTED_ADD_ACTIONS_PARAMS);
			
			assertTrue("ActionQueueTestCase sTestaddActionCount", sTestaddActionCount == EXPECTED_ADD_METHOD_COUNT);

			assertTrue("ActionQueueTestCase sResetQueueValue", sResetQueueValue == EXPECTED_RESET_QUEUE_VALUE);

			assertTrue("ActionQueueTestCase sTestSkipValue", sTestSkipValue == EXPECTED_SKIP_VALUE);
			
			// Events
			assertTrue("ActionRunner EXPECTED_EVENT_STARTED_CALLED", (sEventSTARTEDCalled == EXPECTED_EVENT_STARTED_CALLED));
			
			assertTrue("ActionRunner EXPECTED_EVENT_FINISHED_CALLED", (sEventFINISHEDCalled == EXPECTED_EVENT_FINISHED_CALLED));
			
			assertTrue("ActionRunner EXPECTED_EVENT_QUIT_CALLED", (sEventQUITCalled == EXPECTED_EVENT_QUIT_CALLED));
			
			assertTrue("ActionRunner EXPECTED_EVENT_PAUSED_CALLED", (sEventPAUSEDCalled == EXPECTED_EVENT_PAUSED_CALLED));
			
			assertTrue("ActionRunner EXPECTED_EVENT_RESUMED_CALLED", (sEventRESUMEDCalled == EXPECTED_EVENT_RESUMED_CALLED));
			
			assertTrue("ActionRunner EXPECTED_EVENT_STOPPED_CALLED", (sEventSTOPPEDCalled == EXPECTED_EVENT_STOPPED_CALLED));
			
			assertTrue("ActionRunner EXPECTED_EVENT_MARKER_PASSED_CALLED", (sEventMARKER_PASSEDCalled == EXPECTED_EVENT_MARKER_PASSED_CALLED));

			assertTrue("ActionRunner EXPECTED_EVENT_MARKER_PASSED_CALLED", (sLoopCalled == EXPECTED_LOOP_CALLED));
			
			assertTrue("ActionRunner EXPECTED_ORDERED_EVENT_LIST", (sOrderedEventList == EXPECTED_ORDERED_EVENT_LIST));
			
			evaluatePropertyHeight();
			evaluatePropertyY();
		}
		
		private function doTestAddAction () : void {
			var queueAddAction:ActionQueue = new ActionQueue("ActionQueueTestCase addAction");
			queueAddAction.addAction( performAddAction, "A" );
			
			var action:Action = new Action(performAddAction);
			queueAddAction.addAction(action);
			
			queueAddAction.run();
		}

		private function performAddAction (inValue:String = "") : void {
			sAddActionParams += inValue;
			sAddActionCalled++;
		}
		
		private function doTestAddActionBeforeAndAfter () : void {
			var queue:ActionQueue = new ActionQueue("ActionQueueTestCase addActionBeforeAndAfter");
			queue.addAction( performTestaddAction2 ); // increment by to 1
			queue.addAction( mInstance, "performTestaddAction2" ); // increment to 2
			queue.addAction( mInstance, "performTestaddAction2" ); // increment to 3
			queue.run();
			queue.addAction( mInstance, "performTestaddAction2" );
			queue.run();
		}
		
		public function performTestaddAction2 () : void {
			sTestaddActionCount++;
		}
		
		private function doTestReset () : void {
			var queue:ActionQueue = new ActionQueue("reset queue");
			queue.addAction( this, "funcResetValue" );
			queue.reset();
			queue.addAction( this, "funcResetValue" );
			queue.run();
		}
		
		public function funcResetValue () : void {
			sResetQueueValue++;
		}
		
		public function dummyFunc () : void {
			//
		}

		private function doTestQuit () : void {
			var queue:ActionQueue = new ActionQueue("quit queue");
			queue.addAction( this, "dummyFunc" );
			queue.quit();
		}
		
		private function doTestIsFinished () : void {
			var queue:ActionQueue = new ActionQueue("finished queue");
			queue.addAction( this, "dummyFunc" );
			queue.run();
			assertTrue("ActionQueueTestCase doTestIsFinished", queue.isFinished());
		}
		
		private function doTestPauseAndContinue () : void {
			var pauseQueue = new ActionQueue("test pause and continue");
			pauseQueue.pause();
			assertTrue("ActionQueueTestCase test pause and continue is paused", pauseQueue.isPaused());
			pauseQueue.run();
			assertTrue("ActionQueueTestCase test pause and continue is paused 2", pauseQueue.isPaused());
			pauseQueue.resume();
			assertFalse("ActionQueueTestCase test pause and continue is paused 3", pauseQueue.isPaused());
		}
		
		private function doTestTogglePlay () : void {
			var queue = new ActionQueue("toggle play");
			queue.pause();
			assertTrue("ActionQueueTestCase toggle play 1", queue.isPaused());
			queue.togglePlay();
			assertFalse("ActionQueueTestCase toggle play 2", queue.isPaused());
			queue.togglePlay();
			assertTrue("ActionQueueTestCase toggle play 1", queue.isPaused());
		}
		
		private function doTestAddPause () : void {
			var queue = new ActionQueue("addPause");
			queue.addPause(0.1);
			queue.addAction(doAfterPause);
			queue.addPause(); // pause queue
			queue.addAction(doAfterPause); // should not get called
			queue.run();
			new FrameDelay(evaluateAfterPause, TEST_DELAY);
		}
		
		private function doAfterPause () : void {
			sAfterPauseValue++;
		}
		
		private function evaluateAfterPause () : void {
			assertTrue("ActionQueueTestCase after addPause", sAfterPauseValue == EXPECTED_AFTER_PAUSE_VALUE);
		}
		
		private function doTestSkip () : void {
			var skipQueue = new ActionQueue("skip");
			skipQueue.addAction( addToSkip );
			skipQueue.addAction( addToSkip );
			skipQueue.skip();
			skipQueue.run();
			
		}
		
		public function addToSkip () : void {
			sTestSkipValue++;
		}		

		public function doTestFade () : void {
			var shape:Shape = createRectShape(0xff0000, 50, 50);
			
			var queue:ActionQueue = new ActionQueue("fade");
			queue.addAction( new AQFade().fade(shape, .3, CURRENT, 0 ));
			queue.run();
			new FrameDelay(evaluateShapeProperty, TEST_DELAY, [shape, 'alpha', 0]);
		}
		
		public function doTestMove () : void {
			var shape:Shape = createRectShape(0xff00ff, 100, 50);	
			
			var queue:ActionQueue = new ActionQueue("move");
			queue.addAction( new AQMove().move(shape, .3, CURRENT, CURRENT, CURRENT, 100 ));
			queue.run();
			new FrameDelay(evaluateShapeProperty, TEST_DELAY, [shape, 'x', 100]);
			new FrameDelay(evaluateShapeProperty, TEST_DELAY, [shape, 'y', 100]);
		}
		
		public function doTestScale () : void {
			var shape:Shape = createRectShape(0xff00ff, 250, 50);	
			
			var queue:ActionQueue = new ActionQueue("scale");
			queue.addAction( new AQScale().scale(shape, .3, CURRENT, CURRENT, 2.5, 2.5 ));
			queue.run();
			new FrameDelay(evaluateShapeProperty, TEST_DELAY, [shape, 'scaleX', 2.5]);
		}
		
		public function doTestAddAsynchronousAction () : void {
			var shape:Shape = createRectShape(0xff00ff, 350, 50);	
			
			var queue:ActionQueue = new ActionQueue("scale");
			queue.addAsynchronousAction( new AQFade().fade(shape, .3, CURRENT, .5 ));
			queue.addAction( new AQScale().scale(shape, .3, CURRENT, CURRENT, 2.5, 2.5 ));
			queue.run();
			new FrameDelay(evaluateShapeProperty, TEST_DELAY, [shape, 'scaleX', 2.5]);
			new FrameDelay(evaluateShapeProperty, TEST_DELAY, [shape, 'alpha', .5]);
		}
		
		public function doTestSet () : void {
			doTestSetLoc();
			doTestSetVisible();
			doTestSetAlpha();
			doTestSetScale();
			doTestSetToMouse();
			doTestSetCenterOnStage();
		}
		
		private function doTestSetLoc() : void {
			var shape:Shape = createRectShape(randomColor(), 400, 10);	
			
			var queue:ActionQueue = new ActionQueue("doTestSetLoc");
			queue.addAction(new AQSet().setLoc(shape, CURRENT, 20));
			queue.run();
			new FrameDelay(evaluateShapeProperty, TEST_DELAY, [shape, 'x', 400]);
			new FrameDelay(evaluateShapeProperty, TEST_DELAY, [shape, 'y', 20]);
		}
		
		private function doTestSetVisible() : void {
			var shape:Shape = createRectShape(randomColor(), 400, 40);	
			
			var queue:ActionQueue = new ActionQueue("doTestSetVisible");
			queue.addAction(new AQSet().setVisible(shape, false));
			queue.run();
			new FrameDelay(evaluateShapeProperty, TEST_DELAY, [shape, 'visible', false]);
		}
		
		private function randomColor () : int {
			return 30000 + Math.floor(Math.random() * 30000);
		}
		
		private function doTestSetAlpha() : void {
			var shape:Shape = createRectShape(randomColor(), 400, 80);	
			
			var queue:ActionQueue = new ActionQueue("doTestSetAlpha");
			queue.addAction(new AQSet().setAlpha(shape, 0));
			queue.run();
			
			new FrameDelay(evaluateShapeProperty, TEST_DELAY, [shape, 'alpha', 0]);
		}
		
		private function doTestSetScale() : void {
			doTestSetScaleX();
			doTestSetScaleY();
		}
		
		private function doTestSetScaleX() : void {
			var shape:Shape = createRectShape(randomColor(), 400, 120);	
			
			var queue:ActionQueue = new ActionQueue("doTestSetScaleX");
			queue.addAction(new AQSet().setScale(shape, .5, CURRENT));
			queue.run();
			new FrameDelay(evaluateShapeProperty, TEST_DELAY, [shape, 'scaleX', .5]);
		}
		
		private function doTestSetScaleY() : void {
			var shape:Shape = createRectShape(randomColor(), 400, 140);	
			
			var queue:ActionQueue = new ActionQueue("doTestSetScaleY");
			queue.addAction(new AQSet().setScale(shape, CURRENT, .5));
			queue.run();
			new FrameDelay(evaluateShapeProperty, TEST_DELAY, [shape, 'scaleY', .5]);
		}
		
		private function doTestSetToMouse() : void {
			var shape:Shape = createRectShape(randomColor(), 400, 180);	
			
			var queue:ActionQueue = new ActionQueue("doTestSetToMouse");
			queue.addAction(new AQSet().setToMouse(shape));
			queue.run();
			var mouseX:Number = mCanvas.mouseX;
			var mouseY:Number = mCanvas.mouseY;
			new FrameDelay(evaluateShapeProperty, TEST_DELAY, [shape, 'x', mouseX]);
			new FrameDelay(evaluateShapeProperty, TEST_DELAY, [shape, 'y', mouseY]);
		}
		
		private function doTestSetCenterOnStage() : void {
			
			var shape:Shape = createRectShape(randomColor(), 400, 180);	
			
			var queue:ActionQueue = new ActionQueue("doTestSetCenterOnStage");
			queue.addAction(new AQSet().centerOnStage(shape, 50, 0));
			queue.run();
			var centerX:Number = mCanvas.stage.stageWidth/2 + 50;
			var centerY:Number = mCanvas.stage.stageHeight/2;
			new FrameDelay(evaluateShapeProperty, TEST_DELAY, [shape, 'x', centerX]);
			new FrameDelay(evaluateShapeProperty, TEST_DELAY, [shape, 'y', centerY]);
		}
		
		/**
		Visual tests
		*/
		private function doTestBlink() : void {
			doTestBlinkCount();
			doTestBlinkDuration();
			doTestMaskBlink();
		}
		
		/**
		Visual test
		*/
		private function doTestBlinkCount() : void {
			var shape:Shape = createRectShape(0xffffff, 50, 200);	
			shape.alpha = 0;
			
			var queue:ActionQueue = new ActionQueue("doTestBlinkCount");
			queue.addAction(new AQBlink().blink(shape, 4, 1, 1, .1, .1));
			queue.run();
		}
		
		/**
		Visual test
		*/
		private function doTestBlinkDuration() : void {
			var shape:Shape = createRectShape(0xffffff, 50, 220);	
			shape.alpha = 0;
			
			var queue:ActionQueue = new ActionQueue("doTestBlinkDuration");
			queue.addAction(new AQBlink().blink(shape, 4, 2, 1, .1, .1, 2));
			queue.run();
		}
		
		/**
		Visual test
		*/
		private function doTestMaskBlink () : void {
			var shape:Shape = createRectShape(0xffffff, 50, 240);	
			
			var queue:ActionQueue = new ActionQueue("blink");
			queue.addAction( new AQBlink().maskBlink(shape, 4, 1, true, 2 ));
			queue.run();
		}
		
		private function doTestAddMove () : void {
			var shape:Shape = createRectShape(0xff9900, 150, 50);	
			
			var queue:ActionQueue = new ActionQueue("addmove");
			queue.addAction( new AQAddMove().addMove(shape, .3, -10, 50 ));
			queue.run();
			new FrameDelay(evaluateTestAddMove, TEST_DELAY, [shape, 100]);
		}
		
		private function evaluateTestAddMove (s:Shape, value:Number) : void {
			// because of rounding errors we cannot measure y to the floating point, so we use a round
			assertTrue("ActionQueueTestCase evaluateTestAddMove", Math.round(s.y) == Math.round(value));
		}
		
		/**
		Visual tests
		*/
		private function doTestFollowMouse () : void {
			doTestFollowMouseDraw();
			doTestFollowMouseBallBack();
		}
		
		/**
		Visual test
		*/
		private function doTestFollowMouseDraw () : void {
			var shape:Shape = createRectShape(randomColor(), 200, 200);	
			
			var queue:ActionQueue = new ActionQueue("followmouse");
			queue.addAction( new AQFollowMouse().followMouse(shape, 0, 0.15 ));
			queue.run();
		}
		
		/**
		Visual test
		*/
		private function doTestFollowMouseBallBack () : void {
			var shape:Shape = createRectShape(randomColor(), 200, 200);	
			
			var queue:ActionQueue = new ActionQueue("doTestFollowMouseBallBack");
			var NULL:Number = Number.NaN;
			queue.addAction( new AQFollowMouse().followMouse(shape, 0, .15, NULL, 25, 0, followMouseCallBackFunc ));
			queue.run();
		}
		
		private function followMouseCallBackFunc (inShape:Shape, inX:Number, inY:Number) : void {
			inShape.x = inX;
			inShape.y = inY;
		}
		
		public function doTestPulse () : void {
			doTestPulseFade();
			doTestPulseScale();
		}
		
		private function doTestPulseFade () : void {
			var shape:Shape = createRectShape(randomColor(), 350, 320);	
			shape.alpha = 0;
			var queue:ActionQueue = new ActionQueue("pulse fade");
			queue.addAction( new AQPulse().fade(shape, 6, 0.6, 1, .2, 1) );
			queue.run();
		}
		
		private function doTestPulseScale () : void {
			var shape:Shape = createRectShape(0x0066ff, 350, 340);	
			
			var queue:ActionQueue = new ActionQueue("pulse scale");
			queue.addAction( new AQPulse().scale(shape, 6, 0.6, 1, .2, 1) );
			queue.run();
		}
		
		public function doTestProperty () : void {
			doTestPropertyHeight();
			doTestPropertyY();
		}
		
		private function doTestPropertyHeight () : void {
			SHAPE_PROPERTY_HEIGHT = createRectShape(randomColor(), 450, 320);	
			var queue:ActionQueue = new ActionQueue("property height");
			queue.addAction( new AQProperty().change(SHAPE_PROPERTY_HEIGHT, "height", .6, NaN, EXPECTED_PROPERTY_HEIGHT) );
			queue.run();
		}
		
		private function evaluatePropertyHeight () : void {
			assertTrue("ActionRunner EXPECTED_PROPERTY_HEIGHT", (SHAPE_PROPERTY_HEIGHT["height"] == EXPECTED_PROPERTY_HEIGHT));
		}
		
		private function doTestPropertyY () : void {
			SHAPE_PROPERTY_Y = createRectShape(randomColor(), 475, 320);	
			var queue:ActionQueue = new ActionQueue("property y");
			queue.addAction( new AQProperty().change(SHAPE_PROPERTY_Y, "y", .6, NaN, EXPECTED_PROPERTY_Y) );
			queue.run();
		}
		
		private function evaluatePropertyY () : void {
			assertTrue("ActionRunner EXPECTED_PROPERTY_Y", (SHAPE_PROPERTY_Y["y"] == EXPECTED_PROPERTY_Y));
		}
		
		private function doTestEvents () : void {
			var queue:ActionQueue = new ActionQueue();
			queue.addAction(new Action(dummyFunc));
			queue.addEventListener(ActionEvent._EVENT, onActionEvent);
			queue.run();
			queue.pause();
			queue.resume();
			queue.stop();
			queue.quit();
		}
		
		private function doTestEventsOrder () : void {
			var queue:ActionQueue = new ActionQueue();
			queue.addAction(new Action(dummyFunc));
			queue.addEventListener(ActionEvent._EVENT, onActionEventOrder);
			queue.run();
		}
		
		private function doTestLoops () : void {
			var queue:ActionQueue = new ActionQueue();
			queue.addStartLoop("LOOP", 3);
			queue.addAction(loopCalled);
			queue.addEndLoop("LOOP");
			queue.run();
		}
		
		private function loopCalled () : void {
			sLoopCalled++;
		}
		
		private function onActionEvent (e:ActionEvent) : void {
			switch (e.subtype) {
				case ActionEvent.STARTED:
					sEventSTARTEDCalled++;
					break;
				case ActionEvent.FINISHED:
					sEventFINISHEDCalled++;
					break;
				case ActionEvent.QUIT:
					sEventQUITCalled++; 
					break;
				case ActionEvent.PAUSED:
					sEventPAUSEDCalled++; 
					break;
				case ActionEvent.RESUMED:
					sEventRESUMEDCalled++; 
					break;
				case ActionEvent.STOPPED:
					sEventSTOPPEDCalled++; 
					break;
				case ActionEvent.MARKER_VISITED:
					sEventMARKER_PASSEDCalled++; 
					break;
			}
		}
		
		
		private function onActionEventOrder (e:ActionEvent) : void {
			sOrderedEventList += e.subtype;
		}
		
		private function createRectShape (inColor:int, inX:int, inY:int) : Shape {
			var s:Shape = new Shape();
			mCanvas.addChild(s);
			
			drawColoredRectIn(s.graphics, inColor);
			s.x = inX;
			s.y = inY;
			return s;
		}
		
		private function evaluateShapeProperty (s:Shape, type:String, value:Number) : void {
			
//			trace("evaluateShapeProperty: " + type + " should be:" + value + " is:" + s[type]);
			assertTrue("ActionQueueTestCase evaluateShapeProperty " + type, s[type] == value);
		}
		
		private function drawColoredRectIn(target:Graphics, color:int):void {
			target.lineStyle(0, color, 0);
			target.beginFill(color);
			var size:Number = 20;
			target.drawRect(-size/2, -size/2, size, size);
		}
		
		public override function toString () : String {
			return ";org.asaplibrary.util.actionqueue.ActionQueueTestCase";
		}
	}
	
}

