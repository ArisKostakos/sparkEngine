/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package org.gamepl.coreservices.services.std.logic.gde.core;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.IGameTrigger;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.IGameEntity;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.EEventPrefab;
import org.gamepl.coreservices.core.Game;

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
			//if (Game.logic.interpreter.run(hashId) == false)
				//Console.warn('Trigger $event:HashId $hashId returned false');
			Game.logic.interpreter.run(hashId, [ "me"=>userEntity ]);
		}
	}
}