/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.flambe2_5D;

import flambe.Entity;
import tools.spark.framework.space2_5D.core.AScene2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class FlambeScene2_5D extends AScene2_5D
{
	private var _instances:Map<IView2_5D,Entity>;
	
	public function new(p_gameEntity:IGameEntity)
	{
		super(p_gameEntity);
		_initFlambeScene2_5D();
	}
	
	private function _initFlambeScene2_5D()
	{
		_instances = new Map<IView2_5D,Entity>();
	}
	
	override public function createInstance (p_view2_5D:IView2_5D):Dynamic
	{
		var l_entity:Entity = new Entity();
		
		_instances[p_view2_5D] = l_entity;
		
		return l_entity;
	}
}