package seafight.display.state
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import gui.components.CombatComponent;
	
	import seafight.communication.protocol.sendpackets.ShotRequestPacket;
	import seafight.events.CombatEvent;
	import seafight.gui.Grid;
	import seafight.gui.Ship;

	public class CombatState extends AbstractState
	{
		private static const SHIP_IV:int = 1;
		private static const SHIP_III:int = 2;
		private static const SHIP_II:int = 3;
		private static const SHIP_I:int = 4;
		
		private var ownerGrid:Grid;
		private var enemyGrid:Grid;
		
		private var ownerShipIVCount:int = 1;			
		private var ownerShipIIICount:int = 2;		
		private var ownerShipIICount:int = 3;
		private var ownerShipICount:int = 4;
		
		private var enemyShipIVCount:int = 1;			
		private var enemyShipIIICount:int = 2;		
		private var enemyShipIICount:int = 3;
		private var enemyShipICount:int = 4;
		
		private var shotResponse:Boolean = false;
		private var shipDead:Boolean = false;
		
		public function CombatState(component:Sprite) {
			super(component);
			
			this.ownerGrid = new Grid(true);
			this.ownerGrid.x = 50;
			this.ownerGrid.y = 100;
			(component as CombatComponent).addChild(this.ownerGrid);
			
			this.enemyGrid = new Grid();
			this.enemyGrid.x = 470;
			this.enemyGrid.y = 100;
			(component as CombatComponent).addChild(this.enemyGrid);
			this.enemyGrid.addEventListener(CombatEvent.SHOT, onCombatMapShotHandler);
			
		}
		
		protected override function onAddToStageHandler(event:Event):void {			
			this.enemyGrid.reset();
			
			this.ownerShipIVCount = CombatState.SHIP_IV;			
			this.ownerShipIIICount = CombatState.SHIP_III;	
			this.ownerShipIICount = CombatState.SHIP_II;
			this.ownerShipICount = CombatState.SHIP_I;
			
			this.enemyShipIVCount = CombatState.SHIP_IV;			
			this.enemyShipIIICount = CombatState.SHIP_III;
			this.enemyShipIICount = CombatState.SHIP_II;
			this.enemyShipICount =  CombatState.SHIP_I;
			
			this.shipCountUpdate();
			
			shotResponse = false;
			shipDead = false;
									
			this.disable();
		}
		
		public function get isShotResponse():Boolean { return this.shotResponse; }
		
		public function set ShotResponse(shotResponse:Boolean):void { this.shotResponse = shotResponse; }		
		
		public function get isShipDead():Boolean { return this.shipDead; }
		
		public function set ShipDead(shipDead:Boolean):void { this.shipDead = shipDead; }
		
		public function get OwnerGrid():Grid { return this.ownerGrid; }
		
		public function get EnemyGrid():Grid { return this.enemyGrid; }
		
		public function enable():void {		
			(component as CombatComponent).enabled = true;
			(component as CombatComponent).mouseEnabled = true;
			(component as CombatComponent).mouseChildren = true;
			(component as CombatComponent).waitMc.visible = false;			
		}
		
		public function disable():void {			
			(component as CombatComponent).enabled = false;	
			(component as CombatComponent).mouseEnabled = false;
			(component as CombatComponent).mouseChildren = false;
			(component as CombatComponent).waitMc.visible = true;			
		}
		
		public function dotShips(ships:Array):void {
			this.ownerGrid.reset();
			
			for each(var ship:Ship in ships)
				this.ownerGrid.addShip(ship);
		}
		
		public function deadShip(owner:Boolean, size:int):void {
			if(owner) {
				switch(size) {
					case 1: { this.ownerShipICount--; break; }
					case 2: { this.ownerShipIICount--; break; }
					case 3: { this.ownerShipIIICount--; break; }
					case 4: { this.ownerShipIVCount--; break; }
				}
			}			
			else {
				switch(size) {
					case 1: { this.enemyShipICount--; break; }
					case 2: { this.enemyShipIICount--; break; }
					case 3: { this.enemyShipIIICount--; break; }
					case 4: { this.enemyShipIVCount--; break; }
				}
			}
			
			this.shipCountUpdate();
		}
		
		private function shipCountUpdate():void {
			(component as CombatComponent).oShipIVCountTxt.text = this.ownerShipIVCount.toString();
			(component as CombatComponent).oShipIIICountTxt.text = this.ownerShipIIICount.toString();
			(component as CombatComponent).oShipIICountTxt.text = this.ownerShipIICount.toString();
			(component as CombatComponent).oShipICountTxt.text = this.ownerShipICount.toString();
			
			(component as CombatComponent).eShipIVCountTxt.text = this.enemyShipIVCount.toString();
			(component as CombatComponent).eShipIIICountTxt.text = this.enemyShipIIICount.toString();
			(component as CombatComponent).eShipIICountTxt.text = this.enemyShipIICount.toString();
			(component as CombatComponent).eShipICountTxt.text = this.enemyShipICount.toString();
		}
		
		private function onCombatMapShotHandler(event:CombatEvent):void {
			this.disable();
			
			this.shotResponse = true;
			this.shipDead = true;			
			
			this.facade.getJsConnector().send(new ShotRequestPacket(event.PositionX, event.PositionY));
		}			
	}
}