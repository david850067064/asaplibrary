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
	
	public class ActionQueueTestCase extends TestCase {
		
		private static var sMethodsCalledCount:int = 0;
		private static const EXPECTED_METHODS_CALLED_COUNT:int = 1;
		private static var sAddActionParams:String = "";
		private static const EXPECTED_ADD_ACTIONS_PARAMS:String = "A";
		private static var sTestInsertQueueParams:String = "";
		private static const EXPECTED_INSERT_QUEUE_PARAMS:String = "ABECD";
		private static var sTestaddActionCount:Number = 0;
		private static const EXPECTED_ADD_METHOD_COUNT = 4;
		private static var sTestInsertQueueActionsString:String = "";
		private static const EXPECTED_INSERT_QUEUE_ACTIONS:String = "ABCDE";
		private static var sTestSkipValue:int = 0;
		private static const EXPECTED_SKIP_VALUE:int = 3;
		private static var sClearQueueValue:Number = 2;
		private static const EXPECTED_CLEAR_QUEUE_VALUE:Number = 1;
		
		private static const TEST_DELAY:Number = 31;
		private static const CURRENT:Number = Number.NaN;

		private var mInstance:ActionQueueTestCase = this as ActionQueueTestCase;
		private var mCanvas : Sprite;

		
		public function ActionQueueTestCase (inCanvas:Sprite) {
			super();
			
			mCanvas = inCanvas;
		}
		
		/**
		Override run to pause test, add AQ actions and start test
		*/
		public override function run() : void {
			
			doTestAddAction();
			doTestAddActionBeforeAndAfter();
			doTestClear();
			//doTestQuit();
			doTestPauseAndContinue();
			// TODO: togglePlay
			doTestSkip();

			doTestFade();
			doTestMove();
			doTestScale();
			doTestScaleAndInstantAction();
			doTestSet();
			doTestAddMove();
			doTestFollowMouse();
			doTestBlink();
			doTestPulse();
			
			/*
			doTestInsertQueue();
			doTestInsertQueueActions();
			*/
			new FrameDelay(startTests, TEST_DELAY);
		}
		
		public function startTests () : void {
			super.run();
		}
		
		public function testEvaluateResult () : void {
			/*
			trace("sMethodsCalledCount=" + sMethodsCalledCount);
			trace("sAddActionParams=" + sAddActionParams);
			trace("sTestInsertQueueParams=" + sTestInsertQueueParams);
			trace("sTestaddActionCount=" + sTestaddActionCount);
			trace("sTestInsertQueueActionsString=" + sTestInsertQueueActionsString);
			//trace("sTestPauseAndSkipParams=" + sTestPauseAndSkipParams);
			*/
			
			assertTrue("ActionQueueTestCase sMethodsCalledCount", sMethodsCalledCount == EXPECTED_METHODS_CALLED_COUNT);

			assertTrue("ActionQueueTestCase sAddActionParams", sAddActionParams == EXPECTED_ADD_ACTIONS_PARAMS);
			
			assertTrue("ActionQueueTestCase sTestaddActionCount", sTestaddActionCount == EXPECTED_ADD_METHOD_COUNT);

			assertTrue("ActionQueueTestCase sClearQueueValue", sClearQueueValue == EXPECTED_CLEAR_QUEUE_VALUE);

			assertTrue("ActionQueueTestCase sTestSkipValue", sTestSkipValue == EXPECTED_SKIP_VALUE);	

/*
			assertTrue("ActionQueueTestCase sTestInsertQueueParams", sTestInsertQueueParams == EXPECTED_INSERT_QUEUE_PARAMS);

			
			assertTrue("ActionQueueTestCase sTestInsertQueueActionsString", sTestInsertQueueActionsString == EXPECTED_INSERT_QUEUE_ACTIONS);
*/
		}
		
		private function doTestAddAction () : void {
			var queueAddAction:ActionQueue = new ActionQueue("ActionQueueTestCase addAction");
			queueAddAction.addAction( performAddAction, "A" );
			queueAddAction.run();
		}

		private function performAddAction (inValue:String) : void {
			sAddActionParams += inValue;
			sMethodsCalledCount++;
		}
		
		private function doTestAddActionBeforeAndAfter () : void {

			var queue:ActionQueue = new ActionQueue("ActionQueueTestCase addActionBeforeAndAfter");
			queue.addAction( mInstance, performTestaddAction2 ); // increment by to 1
			queue.addAction( mInstance, "performTestaddAction2" ); // increment to 2
			queue.run();
			queue.addAction( mInstance, "performTestaddAction2" ); // increment to 3
			queue.run();
			assertTrue("ActionQueueTestCase addActionBeforeAndAfter", queue.isBusy());
			queue.addAction( mInstance, "performTestaddAction2" ); // want to increment to 4, but this will fail so the total amount is still 3
			queue.run();
		}
		
		public function performTestaddAction2 () : void {
			sTestaddActionCount++;
		}
		/*
		private function doTestInsertQueue () : void {
			var queue1:ActionQueue = new ActionQueue("ActionQueueTestCase insertQueue outer queue");
			queue1.addAction( mInstance, "addToTestInsertQueueString", "A" );
			queue1.addAction( mInstance, "addToTestInsertQueueString", "B" );
			
			var queue2:ActionQueue = new ActionQueue("ActionQueueTestCase insertQueue inserting queue").addAction( mInstance, "addToTestInsertQueueString", "C" ).addAction( mInstance, "addToTestInsertQueueString", "D" );
			
			queue1.insertQueue( queue2 );
			queue1.addAction( mInstance, "addToTestInsertQueueString", "E" );
			queue1.run();
		}
		
		public function addToTestInsertQueueString (inString:String) : void {
			sTestInsertQueueParams += inString;
		}
		
		private function doTestInsertQueueActions () : void {
			var queue1:ActionQueue = new ActionQueue("ActionQueueTestCase insertQueueActions first");
			queue1.addAction( mInstance, "addToTestInsertQueueActionsString", "A" );
			queue1.addAction( mInstance, "addToTestInsertQueueActionsString", "B" );
			
			var queue2:ActionQueue = new ActionQueue("ActionQueueTestCase insertQueueActions second").addPause(.01).addAction( mInstance, "addToTestInsertQueueActionsString", "C" ).addAction( mInstance, "addToTestInsertQueueActionsString", "D" );
			
			queue1.insertQueueActions( queue2 );
			queue1.addAction( mInstance, "addToTestInsertQueueActionsString", "E" );
			queue1.run();
		}
		
		public function addToTestInsertQueueActionsString (inString:String) : void {	
			sTestInsertQueueActionsString += inString;
		}
		*/
		
		private function doTestClear () : void {
			var queue:ActionQueue = new ActionQueue("clear queue");
			queue.addAction( this, "funcClearQueueValue" );
			queue.clear();
			queue.addAction( this, "funcClearQueueValue" );
			queue.run();
		}
		
		public function funcClearQueueValue () : void {
			sClearQueueValue--;
		}
		
		public function dummyFunc () : void {
			//
		}
		

		private function doTestQuit () : void {
			var queue:ActionQueue = new ActionQueue("quit queue");
			queue.addAction( this, "dummyFunc" );
			queue.quit();
		}
		
		private function doTestPauseAndContinue () : void {
			var pauseQueue = new ActionQueue("test pause and continue");
			pauseQueue.pause();
			assertTrue("ActionQueueTestCase test pause and continue is paused", pauseQueue.isPaused());
			pauseQueue.run();
			assertTrue("ActionQueueTestCase test pause and continue is paused 2", pauseQueue.isPaused());
			pauseQueue.play();
			assertFalse("ActionQueueTestCase test pause and continue is paused 3", pauseQueue.isPaused());
		}
		
		private function doTestSkip () : void {
			var skipQueue = new ActionQueue("skip");
			skipQueue.addAction( this, addToSkip );
			skipQueue.addAction( this, addToSkip );
			skipQueue.addAction( this, addToSkip );
			skipQueue.addAction( this, addToSkip );
			skipQueue.run();
			skipQueue.skip();
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
		
		public function doTestScaleAndInstantAction () : void {
			var shape:Shape = createRectShape(0xff00ff, 350, 50);	
			
			var queue:ActionQueue = new ActionQueue("scale");
			queue.addActionDoNotWaitForMe( new AQFade().fade(shape, .3, CURRENT, .5 ));
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
		
		private function evaluateTestAddMove (inArgs:Array) : void {
			var s:Shape = inArgs[0] as Shape;
			var value:Number = inArgs[1] as Number;
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
			queue.addAction( new AQFollowMouse().followMouse(shape, 0, .15, NULL, 25, 0, this, followMouseCallBackFunc ));
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
		
		private function evaluateTestFollowMouse (inArgs:Array) : void {
			var s:Shape = inArgs[0] as Shape;
			
			assertTrue("ActionQueueTestCase evaluateTestFollowMouse", Math.round(s.x) == Math.round(mCanvas.mouseX));
			assertTrue("ActionQueueTestCase evaluateTestFollowMouse", Math.round(s.y) == Math.round(mCanvas.mouseY));
		}
		

		private function createRectShape (inColor:int, inX:int, inY:int) : Shape {
			var s:Shape = new Shape();
			mCanvas.addChild(s);
			
			drawColoredRectIn(s.graphics, inColor);
			s.x = inX;
			s.y = inY;
			return s;
		}
		
		private function evaluateShapeProperty (inArgs:Array) : void {
			var s:Shape = inArgs[0] as Shape;
			var type:String = inArgs[1] as String;
			var value:Number = inArgs[2] as Number;
			
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

