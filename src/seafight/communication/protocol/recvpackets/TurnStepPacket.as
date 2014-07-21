package seafight.communication.protocol.recvpackets
{
	import seafight.communication.protocol.ReceivablePacket;

	public class TurnStepPacket extends ReceivablePacket
	{	
		public override function get PacketID():int { return 0x01; }		
		
		public override function readImpl():void { }	
	}
}