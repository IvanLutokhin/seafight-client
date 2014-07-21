package seafight
{
	import flash.display.Sprite;
	
	import gui.components.*;
	
	import seafight.communication.ClientState;
	import seafight.communication.JsConnector;
	import seafight.communication.JsMessage;
	import seafight.communication.SystemMessage;
	import seafight.communication.protocol.ReceivablePacket;
	import seafight.communication.protocol.recvpackets.*;
	import seafight.display.DisplayManager;
	import seafight.display.context.MessageContext;
	import seafight.display.state.*;
	import seafight.events.JsEvent;
	import seafight.gui.Cell;
	import seafight.gui.CellType;
	import seafight.gui.Grid;
	import seafight.gui.Ship;
	import seafight.mechanics.Position;

	public class ApplicationFacade
	{
		private static var instance:ApplicationFacade = null;
		
		public static function getInstance():ApplicationFacade {
			if(instance == null)
				instance = new ApplicationFacade();
			
			return instance;
		}
		
		protected var wrapper:Sprite = null;
		
		protected var displayManager:DisplayManager = null;
		
		protected var jsConnector:JsConnector = null;
		
		public function ApplicationFacade() {
			if(instance != null)
				throw Error("ApplicationFacade singleton already constructed!");
			
			instance = this;
		}
		
		public function getDisplayManager():DisplayManager { return this.displayManager; }
		
		public function getJsConnector():JsConnector { return this.jsConnector; }
		
		public function init(wrapper:Sprite):void {
			this.wrapper = wrapper;
			
			this.displayManager = new DisplayManager();
			this.displayManager.registerState(new LoaderState(new LoaderComponent()));
			this.displayManager.registerState(new ErrorState(new ErrorComponent()));
			this.displayManager.registerState(new AboutState(new AboutComponent()));
			this.displayManager.registerState(new MenuState(new MenuComponent()));
			this.displayManager.registerState(new BeforeCombatState(new BeforeCombatComponent()));
			this.displayManager.registerState(new CombatState(new CombatComponent()));
			this.displayManager.selectState(LoaderState, new MessageContext("Подключение к серверу"));
						
			this.wrapper.addChild(this.displayManager);
						
			this.jsConnector = new JsConnector();	
			this.jsConnector.addEventListener(JsEvent.CONNECT, onJsConnectHandler);
			this.jsConnector.addEventListener(JsEvent.DISCONNECT, onJsDisconnectHandler);
			this.jsConnector.addEventListener(JsEvent.SOCKET_ERROR, onJsErrorHandler);
			this.jsConnector.addEventListener(JsEvent.RECEIVE_DATA, onJsReceiveDataHandler);
			
			this.jsConnector.connect("46.8.16.126", 20000);
		}
		
		// js connector handler
		
		private function onJsConnectHandler(event:JsEvent):void {
			this.displayManager.selectState(MenuState);
		}
		
		private function onJsDisconnectHandler(event:JsEvent):void {
			this.displayManager.selectState(ErrorState, new MessageContext(event.DataObject.toString()));
		}
		
		private function onJsErrorHandler(event:JsEvent):void {
			this.displayManager.selectState(ErrorState, new MessageContext(event.DataObject.text));
		}
		
		private function onJsReceiveDataHandler(event:JsEvent):void {			
			var packet:ReceivablePacket = (event.DataObject as ReceivablePacket);
					
			switch(packet.PacketID) {
				case 0x01: { this.onTurnStepPacketHandler(packet); break; }
				case 0x02: { this.onShotResponsePacketHandler(packet); break; }
				case 0x03: { this.onShipDeadPacketHandler(packet); break; }
				case 0x7D: { this.onSystemMessagePacketHandler(packet); break; }
				case 0x7E: { this.onClientStatePacketHandler(packet); break; }
				case 0x7F: { this.onDisconnectPacketHandler(packet); break; }
			}
		}
		
		// logic methods
		private function onTurnStepPacketHandler(packet:ReceivablePacket):void {
			(this.displayManager.getState(CombatState) as CombatState).enable();			
		}
		
		private function onShotResponsePacketHandler(packet:ReceivablePacket):void {
			var p:ShotResponsePacket = (packet as ShotResponsePacket);
			var state:CombatState = (this.displayManager.getState(CombatState) as CombatState);			
			var grid:Grid = (state.isShotResponse) ? state.EnemyGrid : state.OwnerGrid;
			
			switch(p.CellType) {
				case CellType.HIT: {
					grid.getCell(new Position(p.PositionX, p.PositionY)).Type = CellType.HIT;
					break;
				}
				case CellType.DEAD: {
					grid.getCell(new Position(p.PositionX, p.PositionY)).Type = CellType.DEAD;				
					break;
				}				
			}
					
			if(!state.isShotResponse)
				state.ShipDead = false;
			
			state.ShotResponse = false;
		}
		
		private function onShipDeadPacketHandler(packet:ReceivablePacket):void {
			var p:ShipDeadPacket = (packet as ShipDeadPacket);
			var state:CombatState = (this.displayManager.getState(CombatState) as CombatState);
			var grid:Grid = (state.isShipDead) ? state.EnemyGrid : state.OwnerGrid;
			state.deadShip(!state.isShipDead, p.Size);
			grid.deadShip(new Ship(new Position(p.PositionX, p.PositionY), p.Size, p.Orientation));
		}
		
		private function onSystemMessagePacketHandler(packet:ReceivablePacket):void {		
			switch((packet as SystemMessagePacket).MessageId) {
				case SystemMessage.ERROR_DOT_SHIP: {
					this.displayManager.getCurrentState().alert("Некорректно расставлены корабли!", MenuState);
					break;
				}
				case SystemMessage.COMBAT_WIN: {
					this.displayManager.getCurrentState().alert("Поздравляем! Вы победили!", MenuState);
					break;
				}
				case SystemMessage.COMBAT_LOSS: {
					this.displayManager.getCurrentState().alert("Вы проиграли :(", MenuState);
					break;
				}
				case SystemMessage.ENEMY_DESTROY: {		
					this.displayManager.getCurrentState().alert("Противник сбежал!", MenuState);
					break;
				}					
				case SystemMessage.WAIT_ENEMY_EXPIRE: {		
					this.displayManager.getCurrentState().alert("Время ожидания истекло!", MenuState);
					break;
				}
			}
		}
		
		private function onClientStatePacketHandler(packet:ReceivablePacket):void {
			switch((packet as ClientStatePacket).StateCode) {
				case ClientState.CONNECTED: {
					this.displayManager.selectState(MenuState);
					break;
				}
				case ClientState.FIND_ENEMY: {
					this.displayManager.selectState(LoaderState, new MessageContext("Поиск противника"));
					break;
				}
				case ClientState.BEFORE_COMBAT: {
					this.displayManager.selectState(BeforeCombatState);
					break;
				}
				case ClientState.WAIT_ENEMY: {
					this.displayManager.selectState(LoaderState, new MessageContext("Ожидание противника"));
					break;
				}
				case ClientState.COMBAT: {
					var ships:Array = (this.displayManager.getState(BeforeCombatState) as BeforeCombatState).Ships;
					(this.displayManager.getState(CombatState) as CombatState).dotShips(ships);
					this.displayManager.selectState(CombatState);
					break;
				}				
			}
		}
		
		private function onDisconnectPacketHandler(packet:ReceivablePacket):void {
			var reason:String;
			switch((packet as DisconnectPacket).ReasonCode) {
				case 0: { reason = JsMessage.SOCKET_CLOSE; break; }
				case 1: { reason = JsMessage.MANUAL_DISCONNECT; break; }
			}
			
			this.jsConnector.disconnect(reason);
		}
	}
}