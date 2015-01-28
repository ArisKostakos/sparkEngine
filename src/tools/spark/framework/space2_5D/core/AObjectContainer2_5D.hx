/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.core;

import tools.spark.framework.space2_5D.interfaces.IObjectContainer2_5D;
import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * An object container can also have multiple instances. Used for Scenes and Entities
 * @author Aris Kostakos
 */
class AObjectContainer2_5D extends AObject2_5D implements IObjectContainer2_5D
{
	public var children( default, null ):Array<IEntity2_5D>;
	
	private function new(p_gameEntity:IGameEntity) 
	{
		super(p_gameEntity);
		children = new Array<IEntity2_5D>();
	}
	
	public function addChild( p_entity2_5D:IEntity2_5D):Void
	{
		children.push(p_entity2_5D);
	}
}