package seafight.display.state
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import gui.components.MenuComponent;
	
	import seafight.communication.protocol.sendpackets.FindEnemyPacket;

	public class MenuState extends AbstractState
	{
		public function MenuState(component:Sprite)	{
			super(component);
			
			(this.component as MenuComponent).startBtn.addEventListener(MouseEvent.CLICK, startBtnClickHandler);
			(this.component as MenuComponent).aboutBtn.addEventListener(MouseEvent.CLICK, aboutBtnClickHandler);
		}
		
		private function startBtnClickHandler(event:MouseEvent):void {
			this.facade.getJsConnector().send(new FindEnemyPacket());
		}
		
		private function aboutBtnClickHandler(event:MouseEvent):void {
			this.facade.getDisplayManager().selectState(AboutState);
		}
	}
}