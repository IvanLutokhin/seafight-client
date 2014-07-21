package seafight.communication.protocol.recvpackets
{
	import seafight.communication.protocol.ReceivablePacket;

	public class DisconnectPacket extends ReceivablePacket
	{
		private var reasonCode:int;
		
		public function get ReasonCode():int { return this.reasonCode; }
		
		public override function get PacketID():int { return 0x7F; }		
		
		public override function readImpl():void {
			this.reasonCode = this.readInt();
		}
	}
}