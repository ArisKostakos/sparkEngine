package tools.spark.framework.flambe2_5D.components;

import nape.phys.Body;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

import flambe.Component;
import flambe.display.Sprite;
import flambe.math.FMath;
import flambe.System;


/**
 * Tracks a body, and updates the placement of the entity's sprite.
 */
class PreBodyComponent extends Component
{
	private var _gameEntity:IGameEntity;
	
    public function new (p_gameEntity:IGameEntity)
    {
		_gameEntity = p_gameEntity;
    }

    override public function onUpdate (dt :Float)
    {
		Console.log("yoyoyo");
		_gameEntity.setState('physicsEntity', true);
    }

    override public function onRemoved ()
    {
        Console.log("yo REMOVED HEY");
    }
}