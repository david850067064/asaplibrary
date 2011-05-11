package org.asaplibrary.util.validation.rules {
	import org.asaplibrary.util.validation.IValidatable;
	import org.asaplibrary.util.validation.IValidationRule;

	/**
	 * Validation rule that returns the value of target.getValue() as Boolean, so the value is valid if true
	 */
	public class BooleanValidationRule extends ValidationRuleBase implements IValidationRule {
		/**
		 * Constructor;
		 * @param inTarget: Ivalidatable object
		 */
		public function BooleanValidationRule(inTarget : IValidatable) : void {
			super(inTarget);
		}

		/**
		 * @return true if target.getValue() != null
		 */
		public function isValid() : Boolean {
			return mTarget.getValue() as Boolean;
		}
	}
}
