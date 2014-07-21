package seafight.mechanics
{
	import seafight.gui.Cell;
	import seafight.gui.CellType;
	import seafight.gui.Ship;
	import seafight.gui.ShipOrientation;

	public class CombatMap
	{
		private static const N:int = 10;
		
		private static const MAX_ITERATION:int = 50;
		
		private static const SHIP_IV_COUNT:int = 1;
		private static const SHIP_III_COUNT:int = 2;
		private static const SHIP_II_COUNT:int = 3;
		private static const SHIP_I_COUNT:int = 4;
		
		private var cells:Array = new Array();		
		private var positions:Array = new Array();
		
		public function CombatMap() {			
			for(var i:int = 0; i < N; i++) {
				this.cells[i] = new Array();
				
				for(var j:int = 0; j < N; j++) {
					this.cells[i][j] = new Cell(new Position(j, i));
					this.positions.push(new Position(j, i));
				}
			}			
		}
		
		public function reset():void {			
			this.positions = new Array();
			
			for(var i:int = 0; i < N; i++) {
				for(var j:int = 0; j < N; j++) {
					(this.cells[i][j] as Cell).Type = CellType.EMPTY;
					this.positions.push(new Position(j, i));
				}
			}			
		}
		
		public function generate(ships:Array):void {
			this.reset();
			
			for(var i:int = 0; i < ships.length; i++) {
				if(!this.trySetShip(ships[i])) {					
					this.reset();
					i = -1;
					continue;
				}
			}	
		}
				
		private function trySetShip(ship:Ship):Boolean {			
			
			var complete:Boolean = false;
			var iteration:int = 0;
			
			while(!complete) {
				if(this.positions.length == 0)
					return false;
				
				var k:int = Math.random() * this.positions.length;
				
				var position:Position = this.positions[k];
											
				var orientation:int = Math.random() * 2;
				
				if(this.tryAddShip(position, ship.Size, orientation)) {
					ship.move(position);
					ship.rotate(orientation);		
					complete = true;					
				}
				
				iteration++;
				if(iteration == MAX_ITERATION) return false;
			}
			
			return true;
		}
		
		private function tryAddShip(position:Position, size:int, orientation:int):Boolean {			
			var x:int = (position.X == 0) ? 0 : position.X - 1;
			var y:int = (position.Y == 0) ? 0 : position.Y - 1;
									
			var w:int = 0; var h:int = 0;
			
			var i:int = 0; var j:int = 0;
			if(orientation == ShipOrientation.HORIZONTAL && ((position.X + size) < N)) {						
				w = size + ((position.X == 0 || (position.X + size) == N) ? 1 : 2);
				h = (position.Y == 0 || position.Y == N - 1) ? 2 : 3;				
			}		
			else if(orientation == ShipOrientation.VERTICAL && (position.Y + size < N)) {			
				w = (position.X == 0 || position.X == N - 1) ? 2 : 3;
				h = size + ((position.Y == 0 || (position.Y + size) == N) ? 1 : 2);				
			} else { return false; }
			
			if(this.validatePosition(x, y, w, h)) {
				if(orientation == ShipOrientation.HORIZONTAL) {
					for(i = position.X; i < position.X + size; i++)
						(this.cells[position.Y][i] as Cell).Type = CellType.SHIP;
				}
				else if(orientation == ShipOrientation.VERTICAL) {
					for(i = position.Y; i < position.Y + size; i++)
						(this.cells[i][position.X] as Cell).Type = CellType.SHIP;
				}
				
				this.clearUsePosition(x, y, w, h);
				
				return true;
			}
			
			return false;
		}
		
		private function validatePosition(x:int, y:int, w:int, h:int):Boolean {	
			for(var i:int = x; i < x + w; i++) {
				for(var j:int = y; j < y + h; j++) {
					if((this.cells[j][i] as Cell).Type != CellType.EMPTY)
						return false;				
				}
			}		
			
			return true;
		}
		
		private function clearUsePosition(x:int, y:int, w:int, h:int):void {
			for(var i:int = x; i < x + w; i++) {
				for(var j:int = y; j < y + h; j++) {
					var k:int = this.findPositionId(i, j);
					this.positions.splice(k, 1);
				}
			}
		}		
		
		private function findPositionId(x:int, y:int):int {
			for each(var p:Position in this.positions) {
				if(p.X == x && p.Y == y) return this.positions.indexOf(p);
			}
			
			return -1;
		}
	}
}