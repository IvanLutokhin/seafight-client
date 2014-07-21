package seafight.communication.protocol
{
	import flash.utils.ByteArray;
	
	public class ReceivablePacket extends AbstractPacket implements IReceivablePacket
	{		
		protected var data:ByteArray = new ByteArray();
		
		public function get Length():int {
			return PACKET_LENGTH_SIZE + PACKET_ID_SIZE + data.length;
		}
		
		public function get PacketID():int {
			return -1;
		}
		
		public function get Data():ByteArray {
			return this.data;
		}
		
		public function set Data(data:ByteArray):void {
			this.data = data;
		}
		
		public function get Bytes():ByteArray {
			var bytes:ByteArray = new ByteArray();
			bytes.writeShort(this.Length);
			bytes.writeByte(this.PacketID);
			bytes.writeBytes(this.data, 0, this.data.length);
			
			return bytes;
		}
		
		public function read():Boolean {
			try { this.readImpl(); }
			catch (e:Error) { trace(e); return false; }
			
			return true;
		}		
		
		protected function readByte():int {
			return this.data.readByte() & 0xFF;
		}
		
		protected function readBytes(bytes:ByteArray, offset:int, length:int):void {
			this.data.readBytes(bytes, offset, length);
		}
		
		protected function readShort():int {
			return this.data.readShort() & 0xFFFF;
		}
		
		protected function readInt():int {
			return this.data.readInt();
		}
		
		protected function readDouble():Number {
			return this.data.readDouble();
		}
		
		protected function readString():String {
			var length:int = this.data.readShort() & 0xFFFF;
			var string:String = this.data.readUTFBytes(length);
			
			return string;
		}
		
		protected function readBoolean():Boolean {
			var value:int = this.readByte();
			return (value == 0) ? false : true;
		}
		
		public function readImpl():void { }
	}
}