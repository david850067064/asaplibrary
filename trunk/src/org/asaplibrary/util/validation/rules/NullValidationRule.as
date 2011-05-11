package org.asaplibrary.util.validation.rules {
	import org.asaplibrary.util.validation.IValidatable;
	import org.asaplibrary.util.validation.IValidationRule;

	/**
	 * Validation rule that considers the return value for mTarget.getValue() invalid if null. 
	 */
	public class NullValidationRule extends ValidationRuleBase implements IValidationRule {
		/**
		 * Constructor;
		 * @param inTarget: Ivalidatable object
		 */
		public function NullValidationRule(inTarget : IValidatable) : void {
			super(inTarget);
		}

		/**
		 * @return true if target.getValue() != null
		 */
		public function isValid() : Boolean {
			return mTarget.getValue() != null;
		}
	}
}
