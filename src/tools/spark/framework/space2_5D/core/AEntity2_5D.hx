/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.core;

import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IScene2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.framework.layout.containers.Group;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class AEntity2_5D extends AInstantiable2_5D implements IEntity2_5D
{
	public var parentScene( default, default ):IScene2_5D;
	
	private function new(p_gameEntity:IGameEntity) 
	{
		super(p_gameEntity);
		
	}
	
	override public function createInstance (p_view2_5D:IView2_5D):Dynamic
	{
		if (gameEntity.getState('layoutable') == true) {
			
			groupInstances[p_view2_5D] = new Group(gameEntity, "Entity", this);
		}
			
		return super.createInstance(p_view2_5D);
	}
	
	override private function _createChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D, p_index:Int=-1):Void
	{
		if (p_childEntity.gameEntity.getState('layoutable') == true)
		{
			if (p_index==-1)
				groupInstances[p_view2_5D].children.push(p_childEntity.groupInstances[p_view2_5D]);
			else
				groupInstances[p_view2_5D].children.insert(p_index,p_childEntity.groupInstances[p_view2_5D]);
		}
			
		// wanted to set parentScene here but it would have no effect for children inside children
		//p_childEntity.parentScene = parentScene;  (i think will be null :(, becayse of the way instantiating goes)
	}
	
	override private function _removeChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D):Void
	{
		if (p_childEntity.gameEntity.getState('layoutable') == true)
			groupInstances[p_view2_5D].children.remove(p_childEntity.groupInstances[p_view2_5D]);
	}
}