/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.flambe2_5D;

import flambe.Entity;
import tools.spark.framework.space2_5D.core.AScene2_5D;
import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

//IF DEF THIS SHIT ONLY IF SPARK RUNTIME SUPPORTS NAPE
import tools.spark.framework.flambe2_5D.components.BodyComponent;
import tools.spark.framework.flambe2_5D.components.SpaceComponent;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;

/**
 * ...
 * @author Aris Kostakos
 */
class FlambeScene2_5D extends AScene2_5D
{
	public function new(p_gameEntity:IGameEntity)
	{
		super(p_gameEntity);
		_initFlambeScene2_5D();
	}
	
	private function _initFlambeScene2_5D()
	{
		_updateStateFunctions['physicsScene'] = _updatePhysics;
	}
	
	override public function createInstance (p_view2_5D:IView2_5D):Dynamic
	{
		_instances[p_view2_5D] = new Entity();

		return super.createInstance(p_view2_5D);
	}
	
	override public function update(?p_view2_5D:IView2_5D):Void
	{
		//_updateState('2DmeshType', p_view2_5D);
		//_updateState('spaceX',p_view2_5D);
		//_updateState('spaceY',p_view2_5D);
		//_updateState('spaceZ', p_view2_5D);
		
		_updateState('physicsScene', p_view2_5D);
		
		//Update Children
		for (f_childEntity in children)
			f_childEntity.update(p_view2_5D);
	}
	
	private function _updatePhysics(p_physicsFlag:Bool, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_instance:Entity = _instances[p_view2_5D];
		
		if (p_physicsFlag)
		{
			Console.error("UPDATING PHYSICS SCENE: " + gameEntity.getState('name'));
			//BodyComponent
			var spaceComponent:SpaceComponent = new SpaceComponent(gameEntity.getState('gravityX'),gameEntity.getState('gravityY'));
			l_instance.add(spaceComponent);
		}
	}
	
	override private function _createChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D):Void
	{
		//This is an 'instance' addChild... a flambe addChild..
		_instances[p_view2_5D].addChild(cast(p_childEntity.createInstance(p_view2_5D), Entity));
		
		super._createChildOfInstance(p_childEntity, p_view2_5D);
	}
	
	override private function _removeChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D):Void
	{
		//This is an 'instance' removeChild... a flambe removeChild..
		_instances[p_view2_5D].removeChild(cast(p_childEntity.getInstance(p_view2_5D), Entity));
		
		super._removeChildOfInstance(p_childEntity, p_view2_5D);
	}
}