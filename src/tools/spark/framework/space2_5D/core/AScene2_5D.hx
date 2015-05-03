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
import tools.spark.sliced.core.Sliced;

/**
 * ...
 * @author Aris Kostakos
 */
class AScene2_5D extends AInstantiable2_5D implements IScene2_5D
{
	private function new(p_gameEntity:IGameEntity) 
	{
		super(p_gameEntity);
	}
	
	override public function createInstance (p_view2_5D:IView2_5D):Dynamic
	{
		return super.createInstance(p_view2_5D);
	}
	
	override private function _createChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D):Void
	{
		if (p_childEntity.gameEntity.getState('layoutable') == true)
			p_view2_5D.group.children.push(p_childEntity.groupInstances[p_view2_5D]);
			
		p_childEntity.parentScene = this;
	}
	
	override private function _removeChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D):Void
	{
		if (p_childEntity.gameEntity.getState('layoutable') == true)
			p_view2_5D.group.children.remove(p_childEntity.groupInstances[p_view2_5D]);
	}
}