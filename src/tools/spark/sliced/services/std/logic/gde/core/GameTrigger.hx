/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.gde.core;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameTrigger;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventType;
import tools.spark.sliced.core.Sliced;

/**
 * ...
 * @author Aris Kostakos
 */
class GameTrigger extends AGameBase implements IGameTrigger
{
	//Properties
	public var eventType( default, default ):EEventType;
	public var parameter( default, default ):Dynamic; //Could be Key, or String, or..
	public var target( default, default ):String; //Could be gameEntity uid(String), or name(String), or group(String), or..
	public var targetType( default, default ):String; //Describes what the target is, depending on the event, etc..
	public var scriptSet( default, null ):Array<Int>;
	public var pickedObject( default, default ):IGameEntity;
	
	//Constructor
	
	public function new() 
	{
		super();
		//Console.log ("Game Trigger Created");
		
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
			//This would only work if we return what execute returns.. no it returns false if it failed to run..
			//if (Sliced.logic.interpreter.run(hashId) == false)
				//Console.warn('Trigger $event:HashId $hashId returned false');
			if (hashId == -1)
			{
				Sliced.logic.gmlInterpreter.run(hashId, ["this" => this, "me" => parentEntity, "parent" => parentEntity.parentEntity ]);
			}
			else
			{
				if (Sliced.logic.scriptInterpreter.run(hashId, ["this" => this, "me" => parentEntity, "parent" => parentEntity.parentEntity ]) == false)
				{
					Console.error('Error: Failed to run Trigger [$eventType].');
				}
			}
		}
	}
}