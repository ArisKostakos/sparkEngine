/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

package tools.spark.sliced.services.std.display.logicalspace.core;

import tools.spark.sliced.services.std.display.logicalspace.interfaces.ILogicalEntity;
import tools.spark.sliced.services.std.display.logicalspace.interfaces.ILogicalScene;

/**
 * ...
 * @author Aris Kostakos
 */
class LogicalScene extends ALogicalComponent implements ILogicalScene
{
	public var logicalEntitySet( default, null ):Array<ILogicalEntity>;
	
	public function new() 
	{
		super();
		
		_init();
	}
	
	inline private function _init():Void
	{
		logicalEntitySet = new Array<ILogicalEntity>();
	}
	
	public function addEntity( p_entity:ILogicalEntity ):Void
	{
		p_entity.parent = this;
		logicalEntitySet.push(p_entity);
	}
	
	public function removeEntity( p_entity:ILogicalEntity ):Void
	{
		logicalEntitySet.remove(p_entity);
	}
}