package 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.*;
	
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Back;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.None;
	
	/**
	 * Line corners smoothing demo
	 * @author Philippe / http://philippe.elsass.me
	 */
	public class Main extends Sprite 
	{
		private var cpt:int = 0;
		private var xpoints:Vector.<XPoint> = new Vector.<XPoint>();
		private var points:Vector.<Point> = new Vector.<Point>();
		private var lastPoint:XPoint;
		private var lastIndex:int;
		
		private var isDirty:Boolean = false;
		private var pathLength:Number = 0;
		public var k:Number = 1;
		public var l:Number = 0;
		private var distanceTween:Tween
		private var path:Vector.<Segment>;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			setListeners();
			showWelcome();
		}
		
		private function showWelcome():void
		{
			var t:TextField = new TextField();
			t.defaultTextFormat = new TextFormat("_sans");
			t.autoSize = "left";
			t.text = "Click on stage to add point  -  Click on a point to select and drag  -  Ctrl+Click on a point to remove";
			t.appendText("\nMouse wheel to change the drawing percentage");
			t.x = t.y = 10;
			addChild(t);
		}
		
		/* MANIPULATION */
		
		private function setListeners():void
		{
			stage.addEventListener(MouseEvent.CLICK, addPoint);
			addEventListener(Event.CHANGE, pointChanged);
			addEventListener(Event.REMOVED, removePoint);
			addEventListener(Event.SELECT, selectPoint);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			
			addEventListener(Event.ENTER_FRAME, draw);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,KeyPressed);
		}
		
		private function mouseWheel(e:MouseEvent):void 
		{
			trace("rds");
			k += e.delta / 100;
			k = Math.max(0, Math.min(k, 1));
			paint();
		}
		
		private function draw(e:Event):void {
			paint();	
		}
		
		private function selectPoint(e:Event):void 
		{
			if (e.target is XPoint)
			{
				setLastPoint(e.target as XPoint);
			}
		}
		
		private function setLastPoint(pt:XPoint):void
		{
			if (lastPoint) lastPoint.highlight = false;
			
			lastPoint = pt;
			if (lastPoint) 
			{
				addChild(lastPoint);
				lastPoint.highlight = true;
				lastIndex = xpoints.indexOf(lastPoint);
			}
			else lastIndex = -1;
		}
		
		private function removePoint(e:Event):void 
		{
			if (e.target is XPoint)
			{
				var index:int = xpoints.indexOf(e.target);
				points.splice(index, 1);
				xpoints.splice(index, 1);
				setLastPoint(lastIndex >= 0 ? xpoints[lastIndex - 1] : null);
				
				pointChanged();
			}
		}
		
		private function addPoint(e:MouseEvent):void 
		{
			if (e.target is XPoint) return;
			
			var pt:Point = new Point(e.stageX, e.stageY);
			var xpt:XPoint = new XPoint(pt);
			points.splice(lastIndex + 1, 0, pt);
			xpoints.splice(lastIndex + 1, 0, xpt);
			setLastPoint(xpt);
			
			pointChanged();
		}
		
		private function pointChanged(e:Event = null):void 
		{
			isDirty = true;
			paint();
		}
		
		/* DRAWING */
		
		private function paint(e:Event = null):void
		{
			if (isDirty) 
			{
				path = RoundPathHelper.computeRoundedPath(points, 130, false);
				pathLength = RoundPathHelper.getPathLength(path);
			}
			
			graphics.clear();
			graphics.lineStyle(2, 0xff9900);
			//graphics.beginFill(0xffeecc);
			RoundPathHelper.drawPartialPath(graphics, path, k, pathLength, l);
			graphics.lineStyle();
			//graphics.endFill();
			
			/*graphics.lineStyle(4, 0xffffff);
			//graphics.beginFill(0xffeecc);
			RoundPathHelper.drawPartialPath(graphics, path, l, pathLength);
			graphics.lineStyle();
			*/
			
		}
		
		function KeyPressed(e:KeyboardEvent)
		{
			if(e.keyCode == 37){ //37 is keycode for left arrow
				l -= .03;
				l = Math.max(0, Math.min(l, 1));
				paint();
			}
			if(e.keyCode == 38){ //38 is keycode for up arrow
				k += .03;
				k = Math.max(0, Math.min(k, 1));
				paint();
			}
			if(e.keyCode == 39){ //39 is keycode for right arrow
				l += .03;
				l = Math.max(0, Math.min(l, 1));
				paint();
			}
			if(e.keyCode == 40){ //40 is keycode for down arrow
				k -= .03;
				k = Math.max(0, Math.min(k, 1));
				paint();	
			}
			
			if (e.keyCode == 65){//A
				//var distanceTween:Tween;
				//trace ("t "+l);
				l=0;
				distanceTween = new Tween(this, "k", None.easeNone, 0,1, .5, true);
				
				//BetweenAS3.tween(this, {l:1}, null, 0.5, Back.easeOut).play();	
			}
			if (e.keyCode == 68) { //D
				distanceTween = new Tween(this, "l", None.easeNone, 0, 1, .5, true);
			}
			
			
		}
		
		
		
		
	}
	
}