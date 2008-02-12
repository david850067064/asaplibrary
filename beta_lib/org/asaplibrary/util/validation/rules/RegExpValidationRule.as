/*
Copyright 2008 by the authors of asaplibrary, http://asaplibrary.org
Copyright 2005-2007 by the authors of asapframework, http://asapframework.org

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package org.asaplibrary.util.validation.rules {
	import org.asaplibrary.util.validation.IValidatable;
	import org.asaplibrary.util.validation.IValidationRule;	

	/**
	 * @author stephan.bezoen
	 */
	public class RegExpValidationRule implements IValidationRule {
		private var mTarget : IValidatable;
		private var mRegExp : RegExp;
		private var mIsValidIfMatch : Boolean;

		/**
		 * Constructor
		 * @param inTarget: IValidatable object
		 * @param inExpression: regular expression string to validate with
		 * @param inValidIfMatch: if true, value of IValidatable is considered valid if it matches the regular expression; otherwise it is considered invalid
		 */
		public function RegExpValidationRule (inTarget : IValidatable, inExpression: String, inValidIfMatch:Boolean = true) : void {
			mTarget = inTarget;
			mRegExp = new RegExp(inExpression, "");
			mIsValidIfMatch = inValidIfMatch;
		}

		/**
		 * @return true if value of IValidatable is considered valid 
		 */
		public function isValid() : Boolean {
			var value:String = mTarget.getValue() as String;
			var testResult:Boolean = mRegExp.test(value);
			return mIsValidIfMatch ? testResult : !testResult;
		}
		
		public function getTarget() : IValidatable {
			return mTarget;
		}
		
		public function toString():String {
			return "; com.lostboys.util.validation.RegExpValidationRule ";
		}
	}
}
