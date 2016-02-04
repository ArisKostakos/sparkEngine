package tools.spark.framework.flambe2_5D.components;

import nape.phys.Body;
import nape.shape.Circle;
import nape.space.Space;

import flambe.Component;
import flambe.display.Sprite;
import flambe.math.FMath;
import flambe.System;
import nape.geom.Vec2;
import nape.geom.Geom;
import tools.spark.sliced.core.Sliced;

/**
 * Tracks a body, and updates the placement of the entity's sprite.
 */
class PlanetComponent extends Component
{
	public var body :Body;
	public var space :Space;
	
	var samplePoint:Body;
    public function new (p_body :Body)
    {
        body = p_body;
		space = body.space;
		
		samplePoint = new Body();
        samplePoint.shapes.add(new Circle(0.001));
    }

    override public function onUpdate (dt :Float)
    {
		/*
        var pos = body.position;
        
		var sprite = owner.get(Sprite);
		sprite.x._ = pos.x;
		sprite.y._ = pos.y;
		sprite.rotation._ = FMath.toDegrees(body.rotation);
*/
		
		planetaryGravity(body, dt);
    }

	
	function planetaryGravity(planet:Body, deltaTime:Float) {
        // Apply a gravitational impulse to all bodies
        // pulling them to the closest point of a planetary body.
        //
        // Because this is a constantly applied impulse, whose value depends
        // only on the positions of the objects, we can set the 'sleepable'
        // of applyImpulse to be true and permit these bodies to still go to
        // sleep.
        //
        // Applying a 'sleepable' impulse to a sleeping Body has no effect
        // so we may as well simply iterate over the non-sleeping bodies.
        var closestA = Vec2.get();
        var closestB = Vec2.get();
 
        for (body in space.liveBodies) {
            // Find closest points between bodies.
            samplePoint.position.set(body.position);
            var distance = Geom.distanceBody(planet, samplePoint, closestA, closestB);
 
            // Cut gravity off, well before distance threshold.
			/*
            if (distance > 1000) {
                continue;
            }*/
 
            // Gravitational force.
            var force = closestA.sub(body.position, true);
			
			//Sliced.display.error("yoyoyoy: " + body.userData.gameEntity.s('name'));
			
			if (body.userData.gameEntity.s('name') == "Player")
			{
				// We don't use a true description of gravity, as it doesn't 'play' as nice.
				force.length = body.mass * 1e6 / (distance*5);
			}
			else
			{
				// We don't use a true description of gravity, as it doesn't 'play' as nice.
				force.length = Math.min(4000,body.mass * 1e6 / (distance*2));
			}
			
            
			/*
			if (body.userData.gameEntity.s('name') == "Player")
			{
				Sliced.display.error("distance: " + distance + ", force.length: " + force.length);
			}*/
			
            // Impulse to be applied = force * deltaTime
            body.applyImpulse(
                /*impulse*/ force.muleq(deltaTime),
                /*position*/ null, // implies body.position
                /*sleepable*/ true
            );
        }
 
        closestA.dispose();
        closestB.dispose();
    }
}