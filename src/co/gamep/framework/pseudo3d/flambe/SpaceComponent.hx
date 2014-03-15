package co.gamep.framework.pseudo3d.flambe;

import co.gamep.framework.pseudo3d.interfaces.IPseudoEntity;
import nape.callbacks.CbType;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Interactor;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;
import nape.phys.BodyType;
import flambe.Component;
import flambe.display.ImageSprite;
import flambe.Entity;
import flambe.math.FMath;
import flambe.System;

/**
 * Component that wraps a Nape physics simulation.
 */
class SpaceComponent extends Component
{
	private var BRICK:CbType;
	private var BALL:CbType;
	private var PADDLE:CbType;
	
	private var BodiesToEntities:Map<Body,Entity>;
	private var _spaceEntity:Entity;
	

    public function new (spaceEntity:Entity)
    {
        _space = new Space(new Vec2(0, 0));
		_spaceEntity = spaceEntity;
		
		BRICK  = new CbType();
		BALL   = new CbType();
		PADDLE   = new CbType();
		
		BodiesToEntities = new Map<Body,Entity>();
		
		//Interactions
		var listener:InteractionListener = new InteractionListener(CbEvent.END, InteractionType.COLLISION, BALL, BRICK, brickAndBallEndHandler);
		listener.space = _space;
    }
	
	private function brickAndBallEndHandler(cb:InteractionCallback):Void 
	{
		var firstObject:Interactor = cb.int1;
		var secondObject:Interactor = cb.int2;
		
		secondObject.castBody.space = null;
		
		BodiesToEntities[secondObject.castBody].dispose();
	}

    override public function onUpdate (dt :Float)
    {
        _space.step(dt);
		if (_ball != null)
		{
			if (_ball.velocity.x<-500 || _ball.velocity.x>500 || _ball.velocity.y<-500 || _ball.velocity.y>500)
			{
				//_ball.velocity = _ball.velocity.mul(1 - dt * 0.01);
				//trace("Decreasing: " + _ball.velocity);
				//trace("Stable: " + _ball.velocity);
			}
			else
			{
				_ball.velocity = _ball.velocity.mul(1 + dt * 0.02);
				//trace("Increasing: " + _ball.velocity);
			}
		}
    }

    public function addBody (body :Body) :Entity
    {
        body.space = _space;
        return new Entity().add(new BodyComponent(body));
    }

    public function addBox (x :Float, y :Float, p_pseudoEntity:IPseudoEntity) :Entity
    {
        var body = new Body(BodyType.STATIC);
        body.shapes.add(new Polygon(Polygon.box(34, 33), Material.wood()));
        body.position = new Vec2(x, y);
       // body.rotation = Math.random() * 2*FMath.PI;
	   body.cbTypes.add(BRICK);
		p_pseudoEntity.napeBody = body;
        var entity = addBody(body);
        entity.add(new ImageSprite(Assets.getTexture("assets/images/" + p_pseudoEntity.spriteUrl)).centerAnchor());
		
		BodiesToEntities[body] = entity;
        return entity;
    }

	private var _paddle:Body;
	
    public function addBoxKinetic (x :Float, y :Float, p_pseudoEntity:IPseudoEntity) :Entity
    {
        var body = new Body(BodyType.KINEMATIC);
        body.shapes.add(new Polygon(Polygon.box(98, 29), Material.wood()));
        body.position = new Vec2(x, y);
		body.cbTypes.add(PADDLE);
       // body.rotation = Math.random() * 2*FMath.PI;
		p_pseudoEntity.napeBody = body;
		_paddle = body;
        var entity = addBody(body);
        entity.add(new ImageSprite(Assets.getTexture("assets/images/" + p_pseudoEntity.spriteUrl)).centerAnchor());
		
		BodiesToEntities[body] = entity;
        return entity;
    }
	
    public function addBall (x :Float, y :Float, p_pseudoEntity:IPseudoEntity) :Entity
    {
        var body = new Body();
        body.shapes.add(new Circle(11, new Material(100,0,0,0.6,0.0001)));
        body.position = new Vec2(x, y);
        body.rotation = Math.random() * 2*FMath.PI;
		body.applyImpulse(new Vec2(0, 75));
		body.cbTypes.add(BALL);
		p_pseudoEntity.napeBody = body;
		
		_ball = body;
        var entity = addBody(body);
        entity.add(new ImageSprite(Assets.getTexture("assets/images/" + p_pseudoEntity.spriteUrl)).centerAnchor());
		
		BodiesToEntities[body] = entity;
        return entity;
    }

    private var _space :Space;
	
	private var _ball :Body;
}

