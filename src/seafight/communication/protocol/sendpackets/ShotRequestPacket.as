package seafight.communication.protocol.sendpackets
{
	import seafight.communication.protocol.SendablePacket;

	public class ShotRequestPacket extends SendablePacket
	{
		private var positionX:int;
		private var positionY:int;
		
		public function ShotRequestPacket(positionX:int, positionY:int) {
			this.positionX = positionX;
			this.positionY = positionY;
		}
		
		public override function get PacketID():int { return 0x03; }
		
		public override function writeImpl():void {
			this.writeByte(this.positionX);
			this.writeByte(this.positionY);
		}
	}
}