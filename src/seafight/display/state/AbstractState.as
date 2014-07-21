package seafight.display.state
{
	import fl.events.ComponentEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import gui.MessageBox;
	
	import seafight.ApplicationFacade;
	import seafight.display.context.IStateContext;
	
	public class AbstractState extends Sprite
	{
		public static const WIDTH:int = 800;
		public static const HEIGHT:int = 600;
		
		protected var component:Sprite;
		protected var stateContext:IStateContext;
		
		protected var facade:ApplicationFacade = ApplicationFacade.getInstance();
		
		private var messageBox:MessageBox = new MessageBox();
		private var okState:Class;
		
		public function AbstractState(component:Sprite) {
			this.component = component;
						
			this.addChild(this.component);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStageHandler);
			
			this.messageBox.okBtn.addEventListener(ComponentEvent.BUTTON_DOWN, onMessageBoxButtonDownHandler);
		}
		
		public function get Component():Sprite { return this.component; }
		
		public function set Component(component:Sprite):void { this.component = component; }
		
		public function get StateContext():IStateContext { return this.stateContext; }
		
		public function set StateContext(stateContext:IStateContext):void { this.stateContext = stateContext; }
		
		public function alert(message:String, okState:Class):void {
			this.messageBox.messageTxt.text = message;
			this.okState = okState;
			this.addChild(this.messageBox);
		}
		
		protected function onAddToStageHandler(event:Event):void { }
		
		private function onMessageBoxButtonDownHandler(event:ComponentEvent):void {
			this.removeChild(this.messageBox);
			this.facade.getDisplayManager().selectState(this.okState);
		}
	}
}