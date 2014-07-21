package seafight.display
{	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import seafight.display.context.IStateContext;
	import seafight.display.state.AbstractState;
	
	public class DisplayManager extends Sprite
	{
		private var states:Dictionary = new Dictionary();
		
		private var currentState:AbstractState = null;
		
		public function DisplayManager() { }
		
		public function registerState(state:AbstractState):void {			
			this.states[(state as Object).constructor] = state;			
		}
		
		public function getCurrentState():AbstractState {
			return this.currentState;
		}
		
		public function getState(stateClass:Class):AbstractState {
			return this.states[stateClass];
		}
		
		public function getStates():Dictionary {
			return this.states;		
		}
		
		public function selectState(stateClass:Class, stateContext:IStateContext = null):void {
			if(stateClass == null) return;
			
			if(this.currentState != null)
				this.removeChild(this.currentState);
			
			this.currentState = this.getState(stateClass);
			this.currentState.StateContext = stateContext;
						
			this.addChild(this.currentState);
		}		
	}
}