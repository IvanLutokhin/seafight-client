package seafight.display.context
{
	public class MessageContext implements IStateContext
	{
		protected var message:String;
		
		public function MessageContext(message:String = null) {
			this.message = message;
		}
		
		public function get Message():String { return this.message; }
		
		public function set Message(message:String):void { this.message = message; }
	}
}