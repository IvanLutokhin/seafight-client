package seafight.communication
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import seafight.communication.protocol.AbstractPacket;
	import seafight.communication.protocol.ReceivablePacket;
	import seafight.communication.protocol.SendablePacket;
	import seafight.communication.protocol.recvpackets.*;
	import seafight.events.JsEvent;
		
	public class JsConnector extends EventDispatcher
	{	
		private var socket:Socket = null;
		
		private var host:String = null;
		private var port:int = 0;
		private var connected:Boolean = false;
		
		private var packetLength:int = 0;
		
		public function JsConnector() {					
			this.socket = new Socket();
			
			this.socket.addEventListener(Event.CONNECT, onSocketConnectHandler);
			this.socket.addEventListener(Event.CLOSE, onSocketCloseHandler);
			this.socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketErrorHandler);
			this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketErrorHandler);
			this.socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketDataHandler);
		}
		
		public function get Host():String { return this.host; }
		
		public function get Port():int { return this.port; }
		
		public function get isConnected():Boolean { return this.connected; }
		
		public function connect(host:String, port:int):void {
			this.host = host;
			this.port = port;
			
			try { this.socket.connect(host, port); }
			catch (error:Error) { this.dispatchEvent(new JsEvent(JsEvent.SOCKET_ERROR)); }			
		}
		
		public function disconnect(reason:String = JsMessage.MANUAL_DISCONNECT):void {
			if(this.socket != null) {
				try { this.socket.close(); }
				catch (error:Error) { this.dispatchEvent(new JsEvent(JsEvent.SOCKET_ERROR)); }
				
				this.dispatchDisconnectionEvent(reason);
			}
		}
		
		public function send(packet:SendablePacket):void {
			if(this.isConnected) {
				if(!packet.write()) {
					trace("Cannot write packet ID: " + packet.PacketID);
					return;
				}		
				
				this.socket.writeBytes(packet.Bytes, 0, packet.Bytes.length);
				this.socket.flush();
			}
		}
		
		private function dispatchDisconnectionEvent(reason:String):void {
			this.connected = false;
			this.dispatchEvent(new JsEvent(JsEvent.DISCONNECT, reason));
		}
		
		private function onSocketConnectHandler(event:Event):void {
			this.connected = true;
			this.dispatchEvent(new JsEvent(JsEvent.CONNECT));
		}
		
		private function onSocketCloseHandler(event:Event):void {
			this.dispatchDisconnectionEvent(JsMessage.SOCKET_CLOSE);
		}
		
		private function onSocketErrorHandler(event:ErrorEvent):void {
			this.dispatchEvent(new JsEvent(JsEvent.SOCKET_ERROR, event));
		}
		
		private function onSocketDataHandler(event:ProgressEvent):void {
			while((this.packetLength == 0 && this.socket.bytesAvailable >= AbstractPacket.PACKET_LENGTH_SIZE) ||
				(this.packetLength != 0 && this.socket.bytesAvailable >= this.packetLength)) {
				
				if(this.packetLength == 0) {
					this.packetLength = this.socket.readShort() - AbstractPacket.PACKET_LENGTH_SIZE;
				} else {
					var bytes:ByteArray = new ByteArray();
					this.socket.readBytes(bytes, 0, this.packetLength);
					bytes.position = 0;
					
					var packet:ReceivablePacket;
					
					var packetID:int = bytes.readByte() & 0xFF;
					
					switch(packetID) {						
						case 0x01: { packet = new TurnStepPacket(); break; }
						case 0x02: { packet = new ShotResponsePacket(); break; }
						case 0x03: { packet = new ShipDeadPacket(); break; }
						case 0x7D: { packet = new SystemMessagePacket(); break; }
						case 0x7E: { packet = new ClientStatePacket(); break; }
						case 0x7F: { packet = new DisconnectPacket(); break; }
						default: { trace("Unknown packet ID: " + packetID); }
					}
					
					if(packet != null) {						
						packet.Data = bytes;
						
						if(!packet.read())					
							trace("Cannot read packet ID: " + packetID);			
						
						this.dispatchEvent(new JsEvent(JsEvent.RECEIVE_DATA, packet));
					}
					
					this.packetLength = 0;
				}
			}
		}
	}
}