package seafight.communication.protocol.sendpackets
{
	import seafight.communication.protocol.SendablePacket;

	public class FindEnemyPacket extends SendablePacket
	{
		public function FindEnemyPacket() { }
		
		public override function get PacketID():int { return 0x01; }
		
		public override function writeImpl():void {	}
	}
}