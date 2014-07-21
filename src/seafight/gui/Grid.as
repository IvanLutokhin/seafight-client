package seafight.gui
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import gui.AIM;
	
	import seafight.events.CombatEvent;
	import seafight.mechanics.Position;

	public class Grid extends Sprite
	{		
		private static const N:int = 10;
		
		private var cells:Array = new Array();
		private var ships:Array = new Array();
		private var readOnly:Boolean = true;
		
		private var aim:AIM = new AIM();
		
		public function Grid(readOnly:Boolean = false) {
			this.readOnly = readOnly;
			
			this.aim.buttonMode = true;
			this.aim.addEventListener(MouseEvent.MOUSE_DOWN, onAimMouseDownHandler);
			
			for(var i:int = 0; i < N; i++) {
				this.cells[i] = new Array();
				
				for(var j:int = 0; j < N; j++) {
					var cell:Cell = new Cell(new Position(j, i));
					cell.x = 30 * j;
					cell.y = 30 * i;					
					this.addChild(cell);
					
					if(!this.readOnly) {
						cell.addEventListener(MouseEvent.ROLL_OVER, onCellMouseOverHandler);
						cell.addEventListener(MouseEvent.ROLL_OUT, onCellMouseOutHandler);						
					}
					
					this.cells[i][j] = cell;
				}		
			}		
		}
		
		public function reset():void {
			this.ships = new Array();
			
			for(var i:int = 0; i < N; i++) {			
				for(var j:int = 0; j < N; j++) {					
					(this.cells[i][j] as Cell).Type = CellType.EMPTY;
				}		
			}	
		}
		
		public function addShip(ship:Ship):void {
			if(ship.Orientation == ShipOrientation.HORIZONTAL) {
				for(var i:int = ship.PositionX; i < ship.PositionX + ship.Size; i++)
					(this.cells[ship.PositionY][i] as Cell).Type = CellType.SHIP;
			}
			else if(ship.Orientation == ShipOrientation.VERTICAL) {
				for(var j:int = ship.PositionY; j < ship.PositionY + ship.Size; j++)
					(this.cells[j][ship.PositionX] as Cell).Type = CellType.SHIP;
			}
			
			this.ships.push(ship);
		}
		
		public function getShip(position:Position):Ship {
			for each(var ship:Ship in this.ships) {
				if(ship.isEquals(position))
					return ship;
			}
			
			return null;
		}
		
		public function getCell(position:Position):Cell { return this.cells[position.Y][position.X]; }
		
		public function deadShip(ship:Ship):void {
			var environment:Array = this.getShipEnvironment(ship);
			
			for each(var p:Position in environment)
				(this.cells[p.Y][p.X] as Cell).Type = CellType.HIT;		
		}
		
		private function onCellMouseOverHandler(event:MouseEvent):void {			
			var cell:Cell = Cell(event.currentTarget);
			if(cell.Type == CellType.EMPTY)
				cell.addChild(this.aim);
		}
		
		private function onCellMouseOutHandler(event:MouseEvent):void {
			var cell:Cell = Cell(event.currentTarget);
			if(cell.contains(this.aim))
				cell.removeChild(this.aim);
		}
		
		private function onAimMouseDownHandler(event:MouseEvent):void {
			this.dispatchEvent(new CombatEvent(CombatEvent.SHOT, (this.aim.parent as Cell).PositionX, (this.aim.parent as Cell).PositionY));
		}
		
		private function getShipEnvironment(ship:Ship):Array {
			var environment:Array = this.getPositionEnvironment(ship.getPosition(), ship.Size, ship.Orientation);
			
			for(var i:int = 0; i < environment.length; i++) {
				if(ship.isEquals(environment[i])) {
					environment.splice(i, 1);
					i--;
					continue;
				}
			}			
			
			return environment;
		}
						
		private function getPositionEnvironment(position:Position, size:int, orientation:int):Array {
			var x:int = (position.X == 0) ? 0 : position.X - 1;
			var y:int = (position.Y == 0) ? 0 : position.Y - 1;
			
			var w:int = 0; var h:int = 0;
			
			var environment:Array = new Array();
			
			if(orientation == ShipOrientation.HORIZONTAL && ((position.X + size) < N)) {						
				w = size + ((position.X == 0 || (position.X + size) == N) ? 1 : 2);
				h = (position.Y == 0 || position.Y == N - 1) ? 2 : 3;		
			}		
			else if(orientation == ShipOrientation.VERTICAL && (position.Y + size < N)) {			
				w = (position.X == 0 || position.X == N - 1) ? 2 : 3;
				h = size + ((position.Y == 0 || (position.Y + size) == N) ? 1 : 2);			
			}
			
			for(var i:int = x; i < x + w; i++) {
				for(var j:int = y; j < y + h; j++) {
					environment.push(new Position(i, j));
				}
			}
			
			return environment;
		}
	}
}