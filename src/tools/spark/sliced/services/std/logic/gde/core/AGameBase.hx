/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.gde.core;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameBase;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
@:keepSub class AGameBase implements IGameBase
{
	public var parentEntity( default, default ):IGameEntity;
	public var parent( get, null ):IGameEntity; //Alias for parentEntity
	
	
	private function get_parent()  //Still doesn't work inside spark script. I think because it can't handle a getter calling another getter
	{
		return parentEntity;
	}
  
	private function new() 
	{

	}
}