/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.core;

import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IScene2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.framework.space2_5D.layout.core.GroupSpace2_5D;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

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
		//if (gameEntity.getState('layoutable') == true)
			groupInstances[p_view2_5D] = new GroupSpace2_5D("scene", p_view2_5D, this);

		return super.createInstance(p_view2_5D);
	}
	

}