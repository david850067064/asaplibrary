﻿package org.asaplibrary.util {
	
	import asunit.framework.TestCase;
	import org.asaplibrary.util.NumberUtils;
		
	public class NumberUtilsTestCase extends TestCase {
		
		public function testRandomInRange () : void {
			var r:Number;
			
			r = NumberUtils.randomInRange(Number.NaN, Number.NaN);
			assertTrue("NumberUtilsTest testRandomInRange Number.NaN Number.NaN", (isNaN(r)));
			
			r = NumberUtils.randomInRange(Number.NaN, 1);
			assertTrue("NumberUtilsTest testRandomInRange Number.NaN 1", (isNaN(r)));
			
			r = NumberUtils.randomInRange(1, Number.NaN);
			assertTrue("NumberUtilsTest testRandomInRange 1 Number.NaN", (isNaN(r)));
			
			r = NumberUtils.randomInRange(1, 0);
			assertTrue("NumberUtilsTest testRandomInRange 1 0", (r >= 0 && r <= 1));
			
			r = NumberUtils.randomInRange(0, 1);
			assertTrue("NumberUtilsTest testRandomInRange 1 0", (r >= 0 && r <= 1));
			
			r = NumberUtils.randomInRange(-1, 0);
			assertTrue("NumberUtilsTest testRandomInRange -1 0", (r >= -1 && r <= 0));
			
			r = NumberUtils.randomInRange(-.1, .1);
			assertTrue("NumberUtilsTest testRandomInRange -.1 .1", (r >= -.1 && r <= .1));
			
			r = NumberUtils.randomInRange(1, 1);
			assertTrue("NumberUtilsTest testRandomInRange 1 1", (r == 1));
		}
		
		public function testRandomInRanges () : void {
			var a1:Array;
			var a2:Array;
			var r:Number;
			
			a1 = [1,1];
			a2 = [1,1];
			r = NumberUtils.randomInRanges(a1, a2);
			assertTrue("NumberUtilsTest testRandomInRange 1", (r == 1));
			
			a1 = [1,10];
			a2 = [1,10];
			r = NumberUtils.randomInRanges(a1, a2);
			assertTrue("NumberUtilsTest testRandomInRange 2", (r >= 1 && r <= 10));
			
			a1 = [10,1];
			a2 = [10,1];
			r = NumberUtils.randomInRanges(a1, a2);
			assertTrue("NumberUtilsTest testRandomInRange 3", (r >= 1 && r <= 10));
			
			a1 = [10,-10];
			a2 = [10,-10];
			r = NumberUtils.randomInRanges(a1, a2);
			assertTrue("NumberUtilsTest testRandomInRange 4", (r >= -10 && r <= 10));
			
			a1 = [0,10];
			a2 = [10,20];
			r = NumberUtils.randomInRanges(a1, a2);
			assertTrue("NumberUtilsTest testRandomInRange 5", (r >= 0 && r <= 20));
		}
		
		public function testRoundFloat () : void {
			var pi:Number = 3.14159265;
			var r:Number;
			
			r = NumberUtils.roundFloat(pi, 2);
			assertTrue("NumberUtilsTest pi", (r == 3.14));
			assertFalse("NumberUtilsTest pi", (r == 3.14159265));
			
			r = NumberUtils.roundFloat(pi, 2.1);
			assertTrue("NumberUtilsTest pi", (r == 3.14));
			assertFalse("NumberUtilsTest pi", (r == 3.14159265));
			
			r = NumberUtils.roundFloat(pi, 1);
			assertTrue("NumberUtilsTest pi", (r == 3.1));
			
			r = NumberUtils.roundFloat(pi, 0);
			assertTrue("NumberUtilsTest pi", (r == 3));
			
			r = NumberUtils.roundFloat(pi, 10);
			assertTrue("NumberUtilsTest pi", (r == pi));
			
			r = NumberUtils.roundFloat(pi, 5);
			assertFalse("NumberUtilsTest pi", (r == pi));
		}
		
		public function testXPosOnSinus () : void {
			var r:Number;
			
			r = NumberUtils.xPosOnSinus(0, -1, 1);
			assertTrue("testXPosOnSinus 1", (r == 0 * Math.PI));
			
			r = NumberUtils.xPosOnSinus(1, -1, 1);
			assertTrue("testXPosOnSinus 2", (r == 0.5 * Math.PI));
			
			r = NumberUtils.xPosOnSinus(-1, -1, 1);
			assertTrue("testXPosOnSinus 3", (r == -0.5 * Math.PI));
		}
		
		public function testNormalizedValue () : void {
			var r:Number;
			
			r = NumberUtils.normalizedValue(25, 0, 0);
			assertTrue("normalizedValue 1", (r == 0));
			
			r = NumberUtils.normalizedValue(25, 100, 100);
			assertTrue("normalizedValue 2", (r == 100));
			
			r = NumberUtils.normalizedValue(25, 0, 100);
			assertTrue("normalizedValue 3", (r == 0.25));

			r = NumberUtils.normalizedValue(0, -1, 1);
			assertTrue("normalizedValue 4", (r == 0.5));
			
			r = NumberUtils.normalizedValue(0, 0, 100);
			assertTrue("normalizedValue 5", (r == 0));
		}
		
		public function testAngle () : void {
			var r:Number;
			
			r = NumberUtils.angle(0, 0);
			assertTrue("angle 0 0", (r == 0));
			
			r = NumberUtils.angle(0, 1);
			assertTrue("angle 0 1", (r == 90));
			
			r = NumberUtils.angle(1, 1);
			assertTrue("angle 1 1", (r == 45));
			
			r = NumberUtils.angle(1, 0);
			assertTrue("angle 1 0", (r == 0));
			
			r = NumberUtils.angle(-1, 1);
			assertTrue("angle 1 0", (r == 135));
		}
		
	}
}
