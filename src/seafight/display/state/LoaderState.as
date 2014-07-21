package seafight.display.state
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import gui.components.LoaderComponent;
	
	import seafight.display.context.MessageContext;

	public class LoaderState extends AbstractState
	{
		public function LoaderState(component:Sprite) {
			super(component);
		}
		
		protected override function onAddToStageHandler(event:Event):void {			
			if(this.stateContext && (this.stateContext as MessageContext).Message && (this.stateContext as MessageContext).Message.length) {
				(this.component as LoaderComponent).messageTxt.text = (this.stateContext as MessageContext).Message;
			}
		}
	}
}