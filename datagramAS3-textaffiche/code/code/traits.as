package code
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Sine;
	
	import traitspline.*;
	
	//import fl.transitions.Tween;
	//import fl.transitions.easing.None;
	
	
	public class traits extends Sprite 
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

		
		private var path:Vector.<Segment>;
		public var DrawHelp:Boolean = true;
		private var allowDraw:Boolean = true;
		
		public var round:int = 30;
		
		public function traits(x:Number, y:Number):void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			var pt:Point = new Point(x, y);
			var xpt:XPoint = new XPoint(pt);
			points.splice(lastIndex + 1, 0, pt);
			xpoints.splice(lastIndex + 1, 0, xpt);
			setLastPoint(xpt);
			pointChanged();
			
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			setListeners();
		}
		
	
		
		/* MANIPULATION */
		
		private function setListeners():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN,KeyPressed);
			stage.addEventListener(MouseEvent.CLICK, addPoint);
			
			addEventListener(Event.CHANGE, pointChanged);
			addEventListener(Event.REMOVED, removePoint);
			addEventListener(Event.SELECT, selectPoint);
			addEventListener(Event.ENTER_FRAME, draw);	
			
		}
	
		private function addPoint(e:MouseEvent):void 
		{
			DrawHelp=true; // tout le monde
			if (e.target is XPoint) {
				for (var i:int=0; i<xpoints.length;i++){
					if ((e.target.x==xpoints[i].x)&&(e.target.y==xpoints[i].y)) allowDraw=true
					//else allowDraw=false;
				}
			
				return; 
			}
			
			if (allowDraw){
			var pt:Point = new Point(e.stageX, e.stageY);
			var xpt:XPoint = new XPoint(pt);
			points.splice(lastIndex + 1, 0, pt);
			xpoints.splice(lastIndex + 1, 0, xpt);
			setLastPoint(xpt);
			pointChanged();
			for ( i=0; i<xpoints.length;i++){
				//xpoints[i].highlight = false;
				xpoints[i].index=i;
			}
			}
		}
		
		
		
		private function draw(e:Event):void {
			if (pathLength)	paint();	
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
				//if (lastIndex = 0)
				if (lastIndex>0) setLastPoint(lastIndex >= 0 ? xpoints[lastIndex - 1] : null);
				pointChanged();
				for (var i:int=0; i<xpoints.length;i++){
					//xpoints[i].highlight = false;
					xpoints[i].index=i;
				}
			}
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
				path = RoundPathHelper.computeRoundedPath(points, round, false);
				pathLength = RoundPathHelper.getPathLength(path);
			}
			graphics.clear();
			graphics.lineStyle(Main.epaitrait, 0xffffff);
			RoundPathHelper.drawPartialPath(graphics, path, k, pathLength, l);
			graphics.lineStyle();
		}
		
		public function tweenAvant(tim:Number){
			k=0;
			l=0;	
			BetweenAS3.tween(this, {k:1}, 0, tim, Sine.easeInOut).play();		
		}
		public function tweenArriere(tim:Number){
			BetweenAS3.tween(this, {l:1}, 0, tim, Sine.easeInOut).play();
		}	
			
		
		public function changeHelp(){
			DrawHelp = !DrawHelp		
			
			if (DrawHelp) stage.addEventListener(MouseEvent.CLICK, addPoint);
			else stage.removeEventListener(MouseEvent.CLICK, addPoint);
			
			for (var i:int=0; i<xpoints.length;i++){
				//xpoints[i].highlight = false;
				xpoints[i].paint(int(DrawHelp)*.8);
			}
			
			allowDraw = false;	
		}
		
		
		function KeyPressed(e:KeyboardEvent)
		{
			/*
			if(e.keyCode == 38){ //38 is keycode for up arrow
				k += .03;
				k = Math.max(0, Math.min(k, 1));
				paint();
			}
		
			if(e.keyCode == 40){ //40 is keycode for down arrow
				k -= .03;
				k = Math.max(0, Math.min(k, 1));
				paint();	
			}
			*/
			
			if (e.keyCode == 87){//W
				//tweenAvant();
			}
			
			if (e.keyCode == 88) { //X
			//	BetweenAS3.tween(this, {l:1}, 0, .7, Sine.easeInOut).play();
				//distanceTween = new Tween(this, "l", None.easeNone, 0, 1, .5, true);
			}
			
			if (e.keyCode == 186) { //M diplay help
				changeHelp();
				
			}
			
			
			
			
			
		}
		
		
		
		
	}
}