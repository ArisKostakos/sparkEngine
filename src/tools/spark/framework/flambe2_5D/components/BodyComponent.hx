package tools.spark.framework.flambe2_5D.components;

import nape.phys.Body;

import flambe.Component;
import flambe.display.Sprite;
import flambe.math.FMath;
import flambe.System;


/**
 * Tracks a body, and updates the placement of the entity's sprite.
 */
class BodyComponent extends Component
{
    public function new (p_body :Body)
    {
        body = p_body;
    }

    override public function onUpdate (dt :Float)
    {
        var pos = body.position;
        /*if (pos.y > System.stage.height+100) {
            owner.dispose();

        } else {*/
            var sprite = owner.get(Sprite);
            sprite.x._ = pos.x;
            sprite.y._ = pos.y;
            sprite.rotation._ = FMath.toDegrees(body.rotation);
        //}
    }

    override public function onRemoved ()
    {
        // Remove this body from the space
        body.space = null;
    }

    public var body :Body;
}