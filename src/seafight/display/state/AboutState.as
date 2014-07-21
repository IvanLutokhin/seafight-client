package seafight.display.state
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import gui.components.AboutComponent;

	public class AboutState extends AbstractState
	{
		public function AboutState(component:Sprite) {
			super(component);
			
			(this.component as AboutComponent).menuBtn.addEventListener(MouseEvent.CLICK, menuBtnClickHandler);
		}
		
		private function menuBtnClickHandler(event:MouseEvent):void {
			this.facade.getDisplayManager().selectState(MenuState);
		}
	}
}