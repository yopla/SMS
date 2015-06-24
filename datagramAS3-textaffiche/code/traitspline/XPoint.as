package  traitspline
{
	import flash.display.CapsStyle;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * Corner point
	 * @author Philippe / http://philippe.elsass.me
	 */
	public class XPoint extends Sprite
	{
		private var _highlight:Boolean;
		private var coord:Point;
		public var index:int;
		public function XPoint(pt:Point) 
		{
			coord = pt;
			x = pt.x;
			y = pt.y;
			paint(0.2);
			
			setListeners();
		}
		
		/* DRAWING */
		
		public function paint(alpha:Number):void
		{
			graphics.clear();
			
			if (alpha){
			if (index==0) graphics.beginFill(0xffff00,alpha);
				else graphics.beginFill(0xffffff,alpha);
			if (index==0) graphics.drawCircle(0, 0, 8);
				else graphics.drawCircle(0, 0, 5);
			graphics.endFill();
			}
			
			/*graphics.lineStyle(2, 0, alpha, false, "normal", CapsStyle.SQUARE);
			graphics.moveTo( -2, -2);
			graphics.lineTo(2, 2);
			graphics.moveTo( -2, 2);
			graphics.lineTo(2, -2);
			*/
		}
		
		/* DRAG */
		
		private function setListeners():void
		{
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);	
		}
		
		
		
		private function mouseDown(e:MouseEvent):void 
		{
			dispatchEvent(new Event(Event.SELECT, true));
			
			if (e.ctrlKey)
			{
				parent.removeChild(this);
				return;
			}
			
			startDrag(false);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		
		
		private function mouseMove(e:MouseEvent):void 
		{
			coord.x = x;
			coord.y = y;
		}
		
		private function enterFrame(e:Event):void 
		{
			dispatchEvent(new Event(Event.CHANGE, true));
		}
		
		private function mouseUp(e:MouseEvent):void 
		{
			stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		/* STATE */
		
		public function get highlight():Boolean { return _highlight; }
		
		public function set highlight(value:Boolean):void 
		{
			_highlight = value;
			paint(value ? 1 : 0.8);
		}
		
		override public function toString():String 
		{
			return "[XPoint " + this.name + "]";
		}
	}
	
}