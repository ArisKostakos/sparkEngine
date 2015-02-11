/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.core;
import tools.spark.framework.space2_5D.interfaces.IObject2_5D;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class AObject2_5D extends ABase2_5D implements IObject2_5D
{
  
	private function new(p_gameEntity:IGameEntity)
	{
		super(p_gameEntity);
	}
}