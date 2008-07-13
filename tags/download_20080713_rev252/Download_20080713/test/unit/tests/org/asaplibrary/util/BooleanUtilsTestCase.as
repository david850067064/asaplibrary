package org.asaplibrary.util {
	
	import asunit.framework.TestCase;
	import org.asaplibrary.util.BooleanUtils;
		
	public class BooleanUtilsTestCase extends TestCase {
		
		public function testGetBoolean () : void {
			assertFalse("BooleanUtilsTest getBoolean null", BooleanUtils.getBoolean(null));
			assertFalse("BooleanUtilsTest getBoolean 0", BooleanUtils.getBoolean(0));
			assertFalse("BooleanUtilsTest getBoolean \"0\"", BooleanUtils.getBoolean("0"));
			assertFalse("BooleanUtilsTest getBoolean false", BooleanUtils.getBoolean(false));
			assertFalse("BooleanUtilsTest getBoolean \"false\"", BooleanUtils.getBoolean("false"));
			assertFalse("BooleanUtilsTest getBoolean \"off\"", BooleanUtils.getBoolean("off"));
			assertFalse("BooleanUtilsTest getBoolean \"no\"", BooleanUtils.getBoolean("no"));
			assertTrue("BooleanUtilsTest getBoolean 1", BooleanUtils.getBoolean(1));
			assertTrue("BooleanUtilsTest getBoolean \"1\"", BooleanUtils.getBoolean("1"));
			assertTrue("BooleanUtilsTest getBoolean true", BooleanUtils.getBoolean(true));
			assertTrue("BooleanUtilsTest getBoolean \"true\"", BooleanUtils.getBoolean("true"));
			assertTrue("BooleanUtilsTest getBoolean \"on\"", BooleanUtils.getBoolean("on"));
			assertTrue("BooleanUtilsTest getBoolean \"yes\"", BooleanUtils.getBoolean("yes"));
		}
	}
}
