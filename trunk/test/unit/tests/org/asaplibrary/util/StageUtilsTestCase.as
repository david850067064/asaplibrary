package org.asaplibrary.util {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	
	import asunit.framework.TestCase;
	import org.asaplibrary.util.StageUtils;
		
	public class StageUtilsTestCase extends TestCase {
		
		private var mCanvas : Sprite;
		
		public function StageUtilsTestCase (inCanvas:Sprite) {
			super();
			mCanvas = inCanvas;
		}
		
		public function testCenterOnStage () : void {
			var shape:Shape = createRectShape(0xffffff, 0, 0);
			assertTrue("testCenterOnStage before set x", shape.x == 0);
			assertTrue("testCenterOnStage before set y", shape.y == 0);
			StageUtils.centerOnStage(shape);
			assertTrue("testCenterOnStage after set x", shape.x == 550/2);
			assertTrue("testCenterOnStage after set y", shape.y == 400/2);
			mCanvas.removeChild(shape);
		}
		
		public function testCenterOnStageOffset () : void {
			var shape:Shape = createRectShape(0xffffff, 0, 0);
			StageUtils.centerOnStage(shape, -50, -50);
			assertTrue("testCenterOnStageOffset after set x", shape.x == 550/2 - 50);
			assertTrue("testCenterOnStageOffset after set y", shape.y == 400/2 - 50);
			mCanvas.removeChild(shape);
		}
		
		private function createRectShape (inColor:int, inX:int, inY:int) : Shape {
			var s:Shape = new Shape();
			mCanvas.addChild(s);
			
			drawColoredRectIn(s.graphics, inColor);
			s.x = inX;
			s.y = inY;
			return s;
		}
		
		private function drawColoredRectIn(target:Graphics, color:int):void {
			target.lineStyle(0, color, 0);
			target.beginFill(color);
			var size:Number = 20;
			target.drawRect(-size/2, -size/2, size, size);
		}
		
		
	}
}
