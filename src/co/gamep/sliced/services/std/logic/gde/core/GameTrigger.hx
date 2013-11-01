/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.services.std.logic.gde.core;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameTrigger;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameEntity;
import co.gamep.sliced.services.std.logic.gde.interfaces.EEventPrefab;
import co.gamep.sliced.core.Sliced;

/**
 * ...
 * @author Aris Kostakos
 */
class GameTrigger extends AGameBase implements IGameTrigger
{
	//Properties
	public var eventPrefab( default, default ):EEventPrefab;
	public var scriptSet( default, null ):Array<Int>;
	public var userEntity( default, default ):IGameEntity;
	
	
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
			Sliced.logic.interpreter.run(hashId, [ "me"=>userEntity ]);
		}
	}
}