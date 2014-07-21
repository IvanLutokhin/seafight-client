package seafight.gui
{
	import flash.display.Sprite;
	
	import gui.ships.*;
	
	import seafight.mechanics.Position;

	public class Ship extends Sprite
	{
		private var position:Position;
		private var size:int;
		private var orientation:int;
				
		private var background:Sprite;
		
		public function Ship(position:Position, size:int, orientation:int = ShipOrientation.HORIZONTAL) {
			this.position = position;
			this.size = size;
			this.orientation = orientation;
			
			this.background = this.drawBackground();
			this.background.hitArea = this.createHitArea();
			this.addChild(this.background);
			
			this.buttonMode = true;
		}	
				
		public function setPosition(position:Position):void { this.position = position; }
		
		public function getPosition():Position { return this.position; }
		
		public function set PositionX(x:int):void { this.position.X = (x - 430) / 30; }		
				
		public function get PositionX():int { return this.position.X; }			
		
		public function set PositionY(y:int):void { this.position.Y = (y - 120) / 30; }
			
		public function get PositionY():int { return this.position.Y; }			
		
		public function get Size():int { return this.size; }
		
		public function get Orientation():int { return this.orientation; }
		
		public function move(position:Position):void {
			this.position = position;
			
			this.x = 430 + position.X * 30;
			this.y = 120 + position.Y * 30;
		}
		
		public function rotate(orientation:int):void {
			switch(orientation) {
				case ShipOrientation.HORIZONTAL: {
					this.orientation = orientation;
					this.background.rotation = 0;
					this.background.x = 0;
					
					break;
				}
				case  ShipOrientation.VERTICAL: {
					this.orientation = orientation;
					this.background.rotation = 90;
					this.background.x = 50;
					
					break;
				}
			}			
		}
		
		public function isEquals(position:Position):Boolean {
			if(this.orientation == ShipOrientation.HORIZONTAL) {
				if((this.PositionY == position.Y) && (this.PositionX <= position.X && this.PositionX + this.size > position.X))
					return true;			
			}
			else if(this.orientation == ShipOrientation.VERTICAL) {
				if((this.PositionX == position.X) && (this.PositionY <= position.Y && this.PositionY + this.size > position.Y))
					return true;
			}
			
			return false;
		}
		
		private function drawBackground():Sprite {
			switch(this.size) {
				case 1: { return new ShipI(); break; }
				case 2: { return new ShipII(); break; }
				case 3: { return new ShipIII(); break; }
				case 4: { return new ShipIV(); break; }
			}
			
			return null;
		}
		
		private function createHitArea():Sprite {
			var sprite:Sprite = new Sprite();
			sprite.x = 10;
			sprite.y = 10;
			sprite.height = 30;
			sprite.width = 30 * this.size;
			
			return sprite;
		}
	}
}