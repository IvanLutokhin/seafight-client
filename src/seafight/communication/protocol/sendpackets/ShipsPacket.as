package seafight.communication.protocol.sendpackets
{
	import seafight.communication.protocol.SendablePacket;
	import seafight.gui.Ship;

	public class ShipsPacket extends SendablePacket
	{
		private var ships:Array;
		
		public function ShipsPacket(ships:Array) {
			this.ships = ships;
		}
		
		public override function get PacketID():int { return 0x02; }
		
		public override function writeImpl():void {
			this.writeByte(this.ships.length);
			for each(var ship:Ship in this.ships) {				
				this.writeByte(ship.PositionX);
				this.writeByte(ship.PositionY);
				this.writeByte(ship.Orientation);
				this.writeByte(ship.Size);
			}
		}
	}
}