package ui {
	import org.asaplibrary.management.flow.*;
	
	import ui.*;
	import ui.accordion.*;	

	public class DemoAccordion extends Accordion {

		private static const RANDOM_WORDS:String = "From fairest creatures we desire increase, That thereby beauty's rose might never die, But as the riper should by time decease, His tender heir might bear his memory: But thou contracted to thine own bright eyes, Feed'st thy light's flame with self-substantial fuel, Making a famine where abundance lies, Thy self thy foe, to thy sweet self too cruel: Thou that art now the world's fresh ornament, And only herald to the gaudy spring, Within thine own bud buriest thy content, And, tender churl, mak'st waste in niggarding: Pity the world, or else this glutton be, To eat the world's due, by the grave and thee. When forty winters shall besiege thy brow, And dig deep trenches in thy beauty's field, Thy youth's proud livery so gazed on now, Will be a totter'd weed of small worth held: Then being asked, where all thy beauty lies, Where all the treasure of thy lusty days; To say, within thine own deep sunken eyes, Were an all-eating shame, and thriftless praise. How much more praise deserv'd thy beauty's use, If thou couldst answer 'This fair child of mine Shall sum my count, and make my old excuse,' Proving his beauty by succession thine! This were to be new made when thou art old, And see thy blood warm when thou feel'st it cold.";
		
		private var mWords:Array;
		private static const WORDS_PER_PANE:uint = 20;
		
		function DemoAccordion (inName:String, inFlowManager:FlowManager) {
			super(inName, inFlowManager);
			mWords = RANDOM_WORDS.split(" ");			
		}

		public function setupPanes (inCount:uint, inParentPane:Pane) : void {

			var i:uint;
			var height:Number = 0;
			for (i=0; i<inCount; ++i) {

				var pane:Pane = new Pane(this, i, inParentPane, getLastPane(), mFlowManager);
				
				pane.x = 0;
				pane.y = height;
				
				var textContent:DemoPaneTextContent = new DemoPaneTextContent();
				textContent.text = getTextBlurb();
				// add to pane
				pane.setContent(textContent);
				height += pane.height;

				DemoBar(pane.bar).setTitle(pane.getName());
			
				addPane(pane);
			}
		}
		
		private function getTextBlurb () : String {
			var words:Array = new Array();
			var i:uint;
			for (i=0; i<WORDS_PER_PANE; ++i) {
				words.push(mWords.shift());
			}
			return words.join(" ");
		}
		
		

	}
}