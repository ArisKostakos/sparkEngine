/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.gde.core;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameSpace;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class GameSpace extends AGameBase implements IGameSpace
{
	//Properties
	
	public var gameEntitySet( default, null ):Array<IGameEntity>;
	
	
	//Constructor
	
	public function new() 
	{
		super();
		//Console.info ("Game Space Created");
		
		_init();
	}
	
	
	//Methods
	
	private function _init():Void
	{
		gameEntitySet = new Array<IGameEntity>();
	}
	
	public function clone(?p_parentEntity:IGameEntity):IGameSpace
	{
		var l_clonedSpace:IGameSpace =  new GameSpace();
		
		//Parent
		l_clonedSpace.parentEntity = p_parentEntity;
		
		//Clone Entities
		for (entity in gameEntitySet)
			l_clonedSpace.gameEntitySet.push(entity.clone(p_parentEntity));
		
		return l_clonedSpace;
	}
}