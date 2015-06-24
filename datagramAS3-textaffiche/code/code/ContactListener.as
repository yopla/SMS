package code
{
	
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Back;
	import org.libspark.betweenas3.easing.Elastic;
	import org.libspark.betweenas3.events.TweenEvent;
	import org.libspark.betweenas3.tweens.ITween;
	
	import flash.events.*;
	import flash.display.*;
	import flash.geom.*;
	
	/*import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	*/
	
	public class ContactListener extends b2ContactListener {
		
		//private var _root:Sprite;
		
		public function ContactListener( /*root:Sprite */) {
			//_root = root;
		}
		var bb:b2Body;
		public override function Add(point:b2ContactPoint):void {
			
			var f:Number = point.shape1.GetBody().m_linearVelocity.Length() + point.shape2.GetBody().m_linearVelocity.Length();
			if ( f > 2 ) {		
				if (point.shape1.GetBody().GetUserData().name == "oiel") {
					var S : Number = point.shape1.GetBody().m_userData.S;
					var S0 : Number = point.shape1.GetBody().m_userData.scaleX+Math.random()*1.5+.5;
					point.shape1.GetBody().m_userData.scaleX= point.shape1.GetBody().m_userData.scaleY= S0;
					BetweenAS3.tween(point.shape1.GetBody().m_userData, {scaleX: S , scaleY: S }, S0, .5, Back.easeOut).play();
				}else if (point.shape2.GetBody().GetUserData().name == "oiel"){
					S = point.shape2.GetBody().m_userData.S;
					S0 = point.shape2.GetBody().m_userData.scaleX+Math.random()*1.5+.5;
					point.shape2.GetBody().m_userData.scaleX = point.shape2.GetBody().m_userData.scaleY=S0;
					BetweenAS3.tween(point.shape2.GetBody().m_userData, {scaleX: S , scaleY: S }, S0, .5, Back.easeOut).play();	
				}
			}
			
			
			if ( (point.shape1.GetBody().GetUserData().name != "dutexte") || (point.shape2.GetBody().GetUserData().name != "dutexte")){
				//return
			} else {
				var bb1:b2Body=point.shape1.GetBody();
				var bb2:b2Body=point.shape2.GetBody();
				
				if (bb1.GetUserData().age > bb2.GetUserData().age) bb=bb1;
				else bb=bb2;		
				bb.GetUserData().glowing = true;
				if ( f > 1 ) bb.GetUserData().sender();
				if ( f > 5 ) {
					//var bt:ITween=BetweenAS3.tween(bb.m_userData, {scaleX: 1. , scaleY: 1. }, 2, .5, Elastic.easeInOut);
					var tmpScale:Number=f/11;
					tmpScale = Math.max(1, Math.min(tmpScale, 1.5));
					bb.m_userData.scaleX=tmpScale;
					bb.m_userData.scaleY=tmpScale;
					
					BetweenAS3.tween(bb.m_userData, {scaleX: 1 , scaleY: 1 }, tmpScale, .5, Back.easeOut).play();
					
					//if(this.parent.parent != null){
					//var parentObj:Object = this.parent.parent as Object;
					
					//}	
					//bt.addEventListener( TweenEvent.COMPLETE, _complete );
					//bt.play();
					//trace (f);
					
					//		trace (f);
					/*	var myTween:Tween = new Tween(bb.m_userData, "scaleX", Strong.easeOut, 1, 1.3 , .3, true);
					new Tween(bb.m_userData, "scaleY", Strong.easeOut, 1, 1.3 , .3, true).start();
					myTween.addEventListener(TweenEvent.MOTION_FINISH, _complete);
					myTween.start();	*/
				}
				
				
				
				//trace("ガン！", f/*, point.position.x, point.position.y*/ );
				//if (bb.GetUserData().name == "dutexte") 
				/*if (bb.m_userData is Sprite){
				if (bb.GetUserData().name == "dutexte") {
				if (bb.m_userData.state==1){	*/	
				
				//_root.addChild( new CreateEffect( point.position.x * Onomatopoeia.DRAW_SCALE, point.position.y * Onomatopoeia.DRAW_SCALE, f ) );
			}
			
		}
		
		private function _complete(e:TweenEvent){
			//trace (e.currentTarget.obj);
			//var tween : ITween = e.target  as ITween;
			//var target : Object = tween.obj;
			//trace (target);
			//BetweenAS3.tween(e.target.m_userData, {scaleX: 1 , scaleY: 1 }, 1.5, .5, Back.easeOut).play();
			//	new Tween(e.currentTarget.obj, "scaleX", Strong.easeOut, 1.5, 1, .8, true).start();
			//	new Tween(e.currentTarget.obj, "scaleY", Strong.easeOut, 1.5, 1, .8, true).start();
			
		}
		
		
		
		public override function Persist( point:b2ContactPoint ):void {
			
			var shape:b2Shape;
			
			if ( point.shape1.m_density == 0 && point.shape2.m_density == 1 ) shape = point.shape2;
			else if ( point.shape1.m_density == 1 && point.shape2.m_density == 0 ) shape = point.shape1;
			else return;
			
			/*shape.GetBody().GetUserData().count += Math.ceil( shape.GetBody().m_linearVelocity.Length() );
			
			if ( shape.GetBody().GetUserData().count > 0 ) {
			_root.addChild( new CreateEffect( point.position.x * Onomatopoeia.DRAW_SCALE, point.position.y * Onomatopoeia.DRAW_SCALE, -1 ) );
			shape.GetBody().GetUserData().count = -20;
			}
			*/
		}
		
		public override function Remove(point:b2ContactPoint):void {
			
			//point.shape1.GetBody().m_userData.count = -5;
			//point.shape2.GetBody().m_userData.count = -5;
			
		}
}
}