package seafight.mechanics
{
	public class Position
	{
		private var x:int;
		private var y:int;
		
		public function Position(x:int, y:int) {
			this.x = x;
			this.y = y;
		}
		
		public function get X():int { return this.x; }	
		
		public function set X(x:int):void { this.x = x; }
		
		public function get Y():int { return this.y; }
		
		public function set Y(y:int):void { this.y = y; }
	}
}