package seafight.display.state
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import gui.components.ErrorComponent;
	import seafight.display.context.MessageContext;
	
	public class ErrorState extends AbstractState
	{
		public function ErrorState(component:Sprite) {
			super(component);
		}
		
		protected override function onAddToStageHandler(event:Event):void {			
			if(this.stateContext && (this.stateContext as MessageContext).Message && (this.stateContext as MessageContext).Message.length) {
				(this.component as ErrorComponent).messageTxt.text = (this.stateContext as MessageContext).Message;
			}
		}
	}
}