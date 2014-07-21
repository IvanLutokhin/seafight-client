package seafight.gui
{
	import flash.display.Sprite;
	
	import gui.cells.*;
	import seafight.mechanics.Position;

	public class Cell extends Sprite
	{	
		private var position:Position;		
		private var type:int;
		
		private var background:Sprite;
		
		public function Cell(position:Position, type:int = CellType.EMPTY) {
			this.position = position;
			this.Type = type;			
		}
		
		public function getPosition():Position { return this.position; }
		
		public function get PositionX():int { return this.position.X; }
		
		public function get PositionY():int { return this.position.Y; }
		
		public function get Type():int { return this.type; }
		
		public function set Type(type:int):void {
			if(this.background != null)
				this.removeChild(this.background);
			
			this.type = type;			
			this.background = this.drawBackground();
			this.addChild(this.background);
		}	
		
		private function drawBackground():Sprite {
			switch(this.type) {
				case CellType.EMPTY: { return new EmptyCell(); }
				case CellType.HIT: { return new HitCell(); }
				case CellType.DEAD: { return new DeadCell(); }
				case CellType.SHIP: { return new ShipCell(); }				
			}
			
			return null;
		}
	}
}