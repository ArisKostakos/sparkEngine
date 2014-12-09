/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.gde.core;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameTrigger;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventPrefab;
import tools.spark.sliced.core.Sliced;

/**
 * ...
 * @author Aris Kostakos
 */
class GameTrigger extends AGameBase implements IGameTrigger
{
	//Properties
	public var eventPrefab( default, default ):EEventPrefab;
	public var scriptSet( default, null ):Array<Int>;
	
	
	//Constructor
	
	public function new() 
	{
		super();
		Console.log ("Game Trigger Created");
		
		_init();
	}
	
	private function _init():Void
	{
		scriptSet = new Array<Int>();
	}

	
	//Methods

	public function doPass():Void
	{
		for (hashId in scriptSet)
		{
			//if (Sliced.logic.interpreter.run(hashId) == false)
				//Console.warn('Trigger $event:HashId $hashId returned false');
			if (hashId == -1)
			{
				Sliced.logic.gmlInterpreter.run(hashId, [ "me" => parentEntity, "parent" => parentEntity.parentEntity ]);
			}
			else
			{
				Sliced.logic.scriptInterpreter.run(hashId, [ "me"=>parentEntity, "parent"=>parentEntity.parentEntity ]);
			}
		}
	}
}