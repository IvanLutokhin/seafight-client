package seafight.events
{
	import flash.events.Event;
	
	public class CombatEvent extends Event
	{
		public static const SHOT:String = "shot";
		
		private var positionX:int;
		private var positionY:int;
		
		public function CombatEvent(type:String, positionX:int, positionY:int) {
			super(type, bubbles, cancelable);
			
			this.positionX = positionX;
			this.positionY = positionY;
		}
		
		public function get PositionX():int { return this.positionX; }
		
		public function get PositionY():int { return this.positionY; }
	}
}