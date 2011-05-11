package org.asaplibrary.util.validation.rules {
	import org.asaplibrary.util.validation.IValidatable;

	/**
	 * @author stephan.bezoen
	 */
	public class ValidationRuleBase {
		protected var mTarget : IValidatable;

		/**
		 *
		 */
		public function ValidationRuleBase(inTarget : IValidatable) : void {
			mTarget = inTarget;
		}

		/**
		 * @return the target for validation
		 */
		public function getTarget() : IValidatable {
			return mTarget;
		}
	}
}
