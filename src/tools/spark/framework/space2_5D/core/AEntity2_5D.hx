/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.core;

import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class AEntity2_5D extends AObjectContainer2_5D implements IEntity2_5D
{
	private function new(p_gameEntity:IGameEntity) 
	{
		super(p_gameEntity);
		
	}
	
	public function createInstance (p_view2_5D:IView2_5D):Dynamic
	{
		//override me!!
		return null;
	}
	
	public function update(?p_view2_5D:IView2_5D):Void
	{
		//override me!!
	}
}