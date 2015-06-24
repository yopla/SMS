
// http://rengelbert.com/blog/line-path-games-part-ii/
package code
{
	import com.greensock.motionPaths.LinePath2D;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	[SWF (width="600", height="450", frameRate="30", backgroundColor="0x222222")]
	public class LineDrawing extends Sprite
	{
		
		private var _points:Array = [];
		private var _collect:Boolean = false;
		//don't add point to path, unless distance to last point is greater than the value here
		private var _maxDistance:int = 20;
		
		private var _linePath:LinePath2D;
		
		//space between dashes or dots
		private var _gap:Number = 20;
		private var _dash:int = 5;
		
		private var _plane:Sprite;
		//the plane speed
		private var _speed:int = 1;
		private var _speedOnPath:Number = 0;
		
		private var _progress:Number = 0;
		private var _oldLength:Number = 0;
		private var _oldProgress:Number = 0;
		
		//rotation easing
		private var _dr:Number = 0;
		private var _ar:Number = 0;
		private var _vr:Number = 0;
		private var _targetRotation:Number = 0;
		private var _rotationSpring:Number = 0.1;
		private var _rotationDamping:Number = 0.6;
		
		public function LineDrawing()
		{
			super();
			
			_linePath = new LinePath2D();
			_plane = new plane();
			_plane.x = 50;
			_plane.y = 225;
			
			_plane.addEventListener(MouseEvent.MOUSE_DOWN, onMouse_down, false, 0, true);
			addChild(_plane);
			
			addEventListener(Event.ENTER_FRAME, onLoop, false, 0, true);
		}
		
		/* 
		this will draw the dashed/dotted line
		*/
		private function drawLine ():void {
			
			var points:Number = _linePath.totalLength/_gap;
			var num:Number = 1/points;
			
			//spread the points evenly
			var p:Number = 0;
			var point:Point;
			
			this.graphics.clear();
			
			//if you want dots, use this line and comment the next one out
			//this.graphics.beginFill(0xFFFFFF);
			this.graphics.lineStyle(4, 0xFFFFFF);
			
			var angle:Number;
			while (p < 1 ) {
				//in order to draw the path, traverse it with a fixed progress and grab the points from that
				point = _linePath.getPointAtProgress(p);
				
				//check p against progress so we don't draw the dashes/dots the plane has moved past already
				if (point && p > _progress) {
					angle = _linePath.angle * Math.PI / 180;
					
					//if you want dots, use this line and comment the next one out
					//this.graphics.drawCircle(point.x, point.y, 2);
					this.graphics.moveTo(point.x, point.y);
					
					/*if dash is longer than 6 pixels, add logic to draw it centered on the point,
					and preferrably draw it as a curve, calculating curve control point based on the previous point and the next one...
					or stick with a shorter dash and simplify things! like I do here. 
					*/
					this.graphics.lineTo(point.x - _dash*Math.cos(angle), point.y - _dash*Math.sin(angle));
				}
				p += num;
			}
			
		}
		
		/*
		progress is not actually speed because it is based on percentage of path length. 
		but when you increase path length you automatically increase "speed" if you keep the same progress increment in every iteration. 
		This method recalculates the progress increment of every iteration as well
		as the new progress based on the new length, so when the path increases, the plane
		is repositioned at the same spot it was on the previous shorter path...
		*/
		private function updateSpeedAndProgress ():void {
			
			//calculate speedOnPath 
			//first grab the number of iterations necessary to move the total length of the path
			var iterations:int = _linePath.totalLength/_speed;
			//then calculate the percentage increment for each iteration to emulate the plane's speed
			_speedOnPath = 1/iterations;
			
			//now reposition the plane on the new path length so that the plane is actually on the same spot 
			//as it was on the previous path length
			if (_oldLength != 0 && _linePath.totalLength - _oldLength > 10) {
				//rule of three!!!!! yay!!!!
				_progress = (_oldLength * _oldProgress)/_linePath.totalLength;
				_linePath.renderObjectAt(_plane, _progress);
			}
			_oldLength = _linePath.totalLength;
			_oldProgress = _progress;
		}
		
		
		private function onLoop (event:Event):void {
			//if we are collecting points
			if (_collect) {
				var point:Point = new Point(mouseX, mouseY);
				//reset data for new line
				if (_points.length == 0) {
					_linePath.points.length = 0;
					_progress = 0;
					_points.push(new Point(_plane.x, _plane.y));
					_linePath.points = _points;
					return;
					
				} else {
					var lastPoint:Point = _points[_points.length-1];
					//only add a point if the distance to the previous point is long enough 
					//(you don't want to add the same point over and over again!) 
					if (Point.distance(point, lastPoint) > _maxDistance) {
						_points.push(point);
						_linePath.appendPoint(point);
						updateSpeedAndProgress();
						drawLine();
						
					}
				}
			} 
			
			//is path has not been set, or plane has reached the end of the path, keep moving plane 
			if (_linePath.points.length <= 1 || _progress + _speedOnPath >= 1 || _linePath.totalLength < 5) {
				
				var angle:Number = _plane.rotation * Math.PI / 180;
				_plane.x += _speed * Math.cos(angle);
				_plane.y += _speed * Math.sin(angle);
				return;
			} else {
				//increment progress with our calculated speedOnPath
				//this ensures the plane keeps moving at the speed set in _speed variable
				_progress += _speedOnPath;
				if (_linePath.points.length > 1) _linePath.renderObjectAt(_plane, _progress);
				//set target rotation for ease/spring logic bellow
				_targetRotation = _linePath.angle;
				if (_targetRotation > _plane.rotation + 180) _targetRotation -= 360;
				if (_targetRotation < _plane.rotation - 180) _targetRotation += 360;
				
				//redraw the line so dashes/dots already transposed by plane are not redrawn. meaning, they are erased.
				drawLine();
				_oldProgress = _progress;
			}
			//ease and spring the rotation a bit so it looks nicer!
			_dr = _targetRotation - _plane.rotation;
			_ar = _dr * _rotationSpring;
			_vr += _ar;
			_vr *= _rotationDamping;
			_plane.rotation += _vr;
			
		}
		
		private function onMouse_down (event:MouseEvent):void {
			
			_points.length = 0;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouse_move, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouse_up, false, 0, true);
			
		}
		
		private function onMouse_move (event:MouseEvent):void {
			_collect = true;
		}
		
		private function onMouse_up (event:MouseEvent):void {
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouse_move);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouse_up);
			_collect = false;
			
			drawLine();
		}
	}
}