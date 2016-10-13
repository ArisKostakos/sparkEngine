package tools.spark.framework.flambe2_5D.components;

import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

import flambe.asset.AssetPack;
import flambe.Component;
import flambe.display.ImageSprite;
import flambe.Entity;
import flambe.math.FMath;

/**
 * Component that wraps a Nape physics simulation.
 */
class SpaceComponent extends Component
{
	public var space :Space;
	private var _gameEntity:IGameEntity;
	
    public function new (p_gravityX:Float, p_gravityY:Float, p_gameEntity:IGameEntity)
    {
		_gameEntity = p_gameEntity;
        space = new Space(new Vec2(p_gravityX, p_gravityY));
    }

    override public function onUpdate (dt :Float)
    {
		if (!_gameEntity.get('physicsPaused'))
			space.step(Math.min(dt, 0.06));
    }
}
