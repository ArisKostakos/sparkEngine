/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.services.std.logic.gde.core;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameSpace;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameEntity;

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
		Console.log ("Game Space Created");
		
		_init();
	}
	
	
	//Methods
	
	private function _init():Void
	{
		gameEntitySet = new Array<IGameEntity>();
	}
}