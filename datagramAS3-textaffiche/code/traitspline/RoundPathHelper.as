package  traitspline
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	/**
	 * Helper class for rounding path corners
	 * @author Philippe / http://philippe.elsass.me
	 */
	public class RoundPathHelper
	{
		
		static public function computeRoundedPath(points:Vector.<Point>, radius:Number = 30, closePath:Boolean = false):Vector.<Segment>
		{
			var result:Vector.<Segment> = new Vector.<Segment>();
			var count:int = points.length;
			if (count < 2) return result;
			if (closePath && count < 3) return result;
			
			var p0:Point = points[0];
			var p1:Point = points[1];
			var p2:Point;
			var pp0:Point;
			var pp2:Point;
			
			var pos:Point;
			var last:Point;
			if (!closePath) 
			{
				pos = p0;
				last = points[count - 1];
			}
			
			var n:int = (closePath) ? count + 1 : count - 1;
			
			for (var i:int = 1; i < n; i++) 
			{
				p2 = points[(i + 1) % count];
				
				var v0:Point = p0.subtract(p1);
				var v2:Point = p2.subtract(p1);
				var r:Number = Math.max(1, Math.min(radius, Math.min(v0.length / 2, v2.length / 2)));
				v0.normalize(r);
				v2.normalize(r);
				pp0 = p1.add(v0);
				pp2 = p1.add(v2);
				
				if (i == 1 && closePath) last = pp0;
				else result.push(new Segment(pos, pp0));
				pos = pp0;
				
				result.push(new Segment(pos, pp2, p1));
				pos = pp2;
				p0 = p1;
				p1 = p2;
			}
			
			if (closePath) result.unshift(new Segment(pos, last));
			else result.push(new Segment(pos, last));
			return result;
		}
		
		
		
		static public function getPathLength(path:Vector.<Segment>):Number
		{
			var len:Number = 0;
			for each(var seg:Segment in path) len += seg.length;
			return len;
		}
		
		
		
		static public function drawPath(g:Graphics, path:Vector.<Segment>):void
		{
			if (!path.length) return;
			var seg:Segment = path[0];
			g.moveTo(seg.start.x, seg.start.y);
			for each(seg in path)
			{
				if (seg.control) g.curveTo(seg.control.x, seg.control.y, seg.end.x, seg.end.y);
				else g.lineTo(seg.end.x, seg.end.y);
			}
		}
		
		
		
		static public function drawPartialPath(g:Graphics, path:Vector.<Segment>, k:Number = 1, pathLength:Number = NaN, l:Number=0):void
		{
			if (!path.length) return;
			//if (k == 1) return drawPath(g, path);
			if (isNaN(pathLength)) pathLength = getPathLength(path); // length not provided
			
			var pathmem = pathLength;
			var pathLength2 = pathmem*l;
			
			var seg:Segment = path[0];	
			var seg2:Segment = path[0];
		
			
			for each(seg2 in path)
			{
				var len2:Number = seg2.length;
				if (len2 < pathLength2) pathLength2 -= len2;
				else 
				{
					seg2 = seg2.subdivide(pathLength2 / len2);
					//g.drawCircle(seg2.end.x, seg2.end.y, 4);
					break;
				}
			}
			
			//g.moveTo(seg.start.x, seg.start.y);
			g.moveTo(seg2.end.x, seg2.end.y);
				
			pathLength = pathmem*k;
			pathLength2 = pathmem*l;
			
			
		
				
			for each(seg in path)
			{	
				var len:Number = seg.length;
				//trace (path);
				
				if (len < pathLength) 
				{
					
					pathLength -= len;
					pathLength2 -= len;
					
					
					if (pathLength2<=-10) {			
					if (seg.control) g.curveTo(seg.control.x, seg.control.y, seg.end.x, seg.end.y);
					else g.lineTo(seg.end.x, seg.end.y);
					}
					
					
				}
				else 
				{
					seg = seg.subdivide(pathLength / len);
					if (seg.control) g.curveTo(seg.control.x, seg.control.y, seg.end.x, seg.end.y);
					else g.lineTo(seg.end.x, seg.end.y);
					break;
				}
			}
		
		
		
		
		
		}
		
	}
	
}