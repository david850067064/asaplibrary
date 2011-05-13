/*
Copyright 2008-2011 by the authors of asaplibrary, http://asaplibrary.org
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
	 * IValidationRule implementation that checks whether or not a string matches a regular expression. Use this with the Validator class and IValidatable implementations that return a String.
	 * @example
	 * <code>
	mValidator = new Validator();
	mValidator.addValidationRule(new RegExpValidationRule(tName, ".+"));
	</code>
	 * Be aware that if backslashes are used ("\"), they have to be put in double. P.e.the regexp for email validation becomes: "(\\w|[_.\\-])+@((\\w|-)+\\.)+\\w{2,4}+".
	 */
	public class RegExpValidationRule extends ValidationRuleBase implements IValidationRule {
		protected var mRegExp : RegExp;
		private var mIsValidIfMatch : Boolean;

		/**
		 * Constructor
		 * @param inTarget: IValidatable object
		 * @param inExpression: regular expression to validate with.
		 * @param inValidIfMatch: if true, value of IValidatable is considered valid if it matches the regular expression; otherwise it is considered invalid
		 */
		public function RegExpValidationRule(inTarget : IValidatable, inExpression : RegExp = null, inValidIfMatch : Boolean = true) : void {
			super(inTarget);

			mRegExp = inExpression;
			mIsValidIfMatch = inValidIfMatch;
		}

		/**
		 * @return true if value of IValidatable is considered valid 
		 */
		public function isValid() : Boolean {
			var value : String = mTarget.getValue() as String;
			var testResult : Boolean = mRegExp.test(value);
			return mIsValidIfMatch ? testResult : !testResult;
		}
	}
}
