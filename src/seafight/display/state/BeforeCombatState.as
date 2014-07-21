package seafight.display.state
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import gui.components.BeforeCombatComponent;
	
	import seafight.communication.protocol.sendpackets.ShipsPacket;
	import seafight.gui.Ship;
	import seafight.gui.ShipOrientation;
	import seafight.mechanics.CombatMap;
	import seafight.mechanics.Position;
	
	public class BeforeCombatState extends AbstractState
	{
		private static const SHIP_IV:int = 1;
		private static const SHIP_III:int = 2;
		private static const SHIP_II:int = 3;
		private static const SHIP_I:int = 4;
		
		private var shipIVCount:int = SHIP_IV;
		private var shipIVPosition:Point = new Point(120, 120);
		
		private var shipIIICount:int = SHIP_III;
		private var shipIIIPosition:Point = new Point(120, 180);
		
		private var shipIICount:int = SHIP_II;
		private var shipIIPosition:Point = new Point(120, 240);
		
		private var shipICount:int = SHIP_I;
		private var shipIPosition:Point = new Point(120, 300);
		
		private var mvShip:Ship
		private var stPlace:Point = new Point();
		private var stOrientation:int = 0;
		
		private var grid:Sprite;
		private var inGrid:Boolean = false;
		
		private var ships:Array = new Array();	
		
		private var combatMap:CombatMap = new CombatMap();
		
		public function BeforeCombatState(component:Sprite)	{
			super(component);
			
			this.grid = (this.component as BeforeCombatComponent).map.grid;
						
			(component as BeforeCombatComponent).readyBtn.addEventListener(MouseEvent.CLICK, onReadyBtnMouseClickHandler);
			
			(component as BeforeCombatComponent).autoDotBtn.addEventListener(MouseEvent.CLICK, onAutoDotBtnMouseClickHandler);
			
			for(var i:int = 0; i < this.shipIVCount; i++) {
				var shipIV:Ship = new Ship(new Position(-1, -1), 4);
				shipIV.x = this.shipIVPosition.x;
				shipIV.y = this.shipIVPosition.y;
				shipIV.addEventListener(MouseEvent.MOUSE_DOWN, onShipMouseDownHandler);			
				component.addChild(shipIV);
				this.ships.push(shipIV);
			}
			
			for(i = 0; i < this.shipIIICount; i++) {
				var shipIII:Ship = new Ship(new Position(-1, -1), 3);
				shipIII.x = this.shipIIIPosition.x;
				shipIII.y = this.shipIIIPosition.y;
				shipIII.addEventListener(MouseEvent.MOUSE_DOWN, onShipMouseDownHandler);			
				component.addChild(shipIII);
				this.ships.push(shipIII);
			}
			
			for(i = 0; i < this.shipIICount; i++) {
				var shipII:Ship = new Ship(new Position(-1, -1), 2);
				shipII.x = this.shipIIPosition.x;
				shipII.y = this.shipIIPosition.y;
				shipII.addEventListener(MouseEvent.MOUSE_DOWN, onShipMouseDownHandler);			
				component.addChild(shipII);
				this.ships.push(shipII);
			}
			
			for(i = 0; i < this.shipICount; i++) {
				var shipI:Ship = new Ship(new Position(-1, -1), 1);
				shipI.x = this.shipIPosition.x;
				shipI.y = this.shipIPosition.y;
				shipI.addEventListener(MouseEvent.MOUSE_DOWN, onShipMouseDownHandler);			
				component.addChild(shipI);
				this.ships.push(shipI);
			}
			
			this.updateShipCount();
		}		
				
		public function get Ships():Array { return this.ships; }
		
		protected override function onAddToStageHandler(event:Event):void {
			this.resetShipPosition();
				
			(component as BeforeCombatComponent).readyBtn.visible = false;
		}
		
		private function isReady():Boolean { 
			return (this.shipICount + this.shipIICount + this.shipIIICount + this.shipIVCount) == 0;
		}
		
		private function updateShipCount():void {
			(component as BeforeCombatComponent).shipIVCountTxt.text = this.shipIVCount.toString();
			(component as BeforeCombatComponent).shipIIICountTxt.text = this.shipIIICount.toString();
			(component as BeforeCombatComponent).shipIICountTxt.text = this.shipIICount.toString();
			(component as BeforeCombatComponent).shipICountTxt.text = this.shipICount.toString();
		}
		
		private function onSetShip(ship:Ship):void {
			switch(ship.Size) {
				case 1: { this.shipICount--; break; }
				case 2: { this.shipIICount--; break; }
				case 3: { this.shipIIICount--; break; }
				case 4: { this.shipIVCount--; break; }
			}
			
			this.updateShipCount();
		}
		
		private function resetShipPosition():void {
			for each(var ship:Ship in this.ships) {
				switch(ship.Size) {
					case 1: {
						ship.x = this.shipIPosition.x;
						ship.y = this.shipIPosition.y;
						ship.rotate(ShipOrientation.HORIZONTAL);						
						break;
					}
					case 2: {
						ship.x = this.shipIIPosition.x;
						ship.y = this.shipIIPosition.y;
						ship.rotate(ShipOrientation.HORIZONTAL);						
						break;
					}
					case 3: {
						ship.x = this.shipIIIPosition.x;
						ship.y = this.shipIIIPosition.y;
						ship.rotate(ShipOrientation.HORIZONTAL);						
						break;
					}
					case 4: {
						ship.x = this.shipIVPosition.x;
						ship.y = this.shipIVPosition.y;
						ship.rotate(ShipOrientation.HORIZONTAL);						
						break;
					}
				}
			}
			
			this.shipICount = SHIP_I;
			this.shipIICount = SHIP_II;
			this.shipIIICount = SHIP_III;
			this.shipIVCount = SHIP_IV;
			
			this.updateShipCount();
		}
		
		private function hitTestObjects(obj:Sprite):Boolean {
			for each(var s:Sprite in this.ships) {
				if(s == obj) continue;
				
				if(obj.hitTestObject(s))
					return true;
			}
			
			return false;
		}
		
		private function floorX(x:Number):Number {
			return 30 * Math.round(x / 30) + 10;		
		}
		
		private function floorY(y:Number):Number {
			return 30 * Math.round(y / 30);		
		}
		
		private function onShipMouseDownHandler(event:MouseEvent):void {
			this.mvShip = Ship(event.currentTarget);
			this.stPlace.x = this.mvShip.x;
			this.stPlace.y = this.mvShip.y;
			this.stOrientation = this.mvShip.Orientation;
			
			this.inGrid = this.mvShip.hitTestObject(this.grid);
			
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMoveHandler);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDownHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUpHandler);
		}
		
		private function onStageMouseMoveHandler(event:MouseEvent):void {
			this.mvShip.x = this.stage.mouseX - 25;
			this.mvShip.y = this.stage.mouseY - 25;
		}
		
		private function onStageMouseUpHandler(event:MouseEvent):void {
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMoveHandler);
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDownHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUpHandler);
			
			var x1:Number = this.mvShip.x + 10;
			var y1:Number = this.mvShip.y + 10;
			var x2:Number = this.mvShip.x + this.mvShip.width - 10;
			var y2:Number = this.mvShip.y + this.mvShip.height - 10;
			
			if(!this.grid.hitTestPoint(x1, y1) || !this.grid.hitTestPoint(x2, y2) || this.hitTestObjects(this.mvShip)) {
				this.mvShip.x = this.stPlace.x;
				this.mvShip.y = this.stPlace.y;
				this.mvShip.rotate(this.stOrientation);				
			} else {				
				this.mvShip.PositionX = this.mvShip.x = this.floorX(this.mvShip.x);
				this.mvShip.PositionY = this.mvShip.y = this.floorY(this.mvShip.y);
						
				if(!this.inGrid)				
					this.onSetShip(this.mvShip);			
			}
			
			if(this.isReady())
				(component as BeforeCombatComponent).readyBtn.visible = true;
		}
		
		private function onStageKeyDownHandler(event:KeyboardEvent):void {			
			if(event.keyCode == 37) { this.mvShip.rotate(ShipOrientation.VERTICAL); }
			else if(event.keyCode == 39) { this.mvShip.rotate(ShipOrientation.HORIZONTAL); }
			
			this.onStageMouseMoveHandler(null);	
		}
		
		private function onAutoDotBtnMouseClickHandler(event:MouseEvent):void {
			this.resetShipPosition();
			this.combatMap.generate(this.ships);
						
			this.shipICount = 0;
			this.shipIICount = 0;
			this.shipIIICount = 0;
			this.shipIVCount = 0;
			
			this.updateShipCount();
			
			if(this.isReady())
				(component as BeforeCombatComponent).readyBtn.visible = true;
		}			
		
		private function onReadyBtnMouseClickHandler(event:MouseEvent):void {
			this.facade.getJsConnector().send(new ShipsPacket(this.ships));	
		}
	}
}