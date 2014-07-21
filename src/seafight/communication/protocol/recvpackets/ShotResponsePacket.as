package seafight.communication.protocol.recvpackets
{
	import seafight.communication.protocol.ReceivablePacket;

	public class ShotResponsePacket extends ReceivablePacket
	{		
		private var positionX:int;
		private var positionY:int;
		private var cellType:int;
			
		public function get PositionX():int { return this.positionX; }
		
		public function get PositionY():int { return this.positionY; }
		
		public function get CellType():int { return this.cellType; }
				
		public override function get PacketID():int { return 0x02; }
		
		public override function readImpl():void {			
			this.positionX = this.readByte();
			this.positionY = this.readByte();
			this.cellType = this.readByte();			
		}
	}
}