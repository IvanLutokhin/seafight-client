package seafight.communication.protocol.recvpackets
{
	import seafight.communication.protocol.ReceivablePacket;

	public class ShipDeadPacket extends ReceivablePacket
	{	
		private var positionX:int;
		private var positionY:int;
		private var size:int;
		private var orientation:int;
		
		public function get PositionX():int { return this.positionX; }
		
		public function get PositionY():int { return this.positionY; }
		
		public function get Size():int { return this.size; }
		
		public function get Orientation():int { return this.orientation; }
		
		public override function get PacketID():int { return 0x03; }
		
		public override function readImpl():void {			
			this.positionX = this.readByte();
			this.positionY = this.readByte();
			this.size = this.readByte();	
			this.orientation = this.readByte();
		}
	}
}