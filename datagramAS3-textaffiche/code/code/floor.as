package code
{ 
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.b2AABB;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;
	
	public class floor
	{
		public function floor(DRAW_SCALE:int, _world:b2World)
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set( 500 / DRAW_SCALE, 600 / DRAW_SCALE);
			var boxDef:b2PolygonDef = new b2PolygonDef();
			boxDef.SetAsBox(300 / DRAW_SCALE, 20 / DRAW_SCALE);
			boxDef.friction = 0.3;
			boxDef.density = 0;
			var body:b2Body = _world.CreateBody(bodyDef);
			body.CreateShape(boxDef);
			body.SetMassFromShapes();
		}
	}
}