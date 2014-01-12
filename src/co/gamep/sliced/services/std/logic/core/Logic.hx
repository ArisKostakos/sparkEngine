/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.services.std.logic.core;

import co.gamep.sliced.interfaces.ILogic;
import co.gamep.sliced.core.AService;
import co.gamep.sliced.services.std.logic.gde.core.GameFactory;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameEntity;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameFactory;
import co.gamep.sliced.services.std.logic.interpreter.core.GmlInterpreter;
import co.gamep.sliced.services.std.logic.interpreter.core.HaxeInterpreter;
import co.gamep.sliced.services.std.logic.interpreter.interfaces.IInterpreter;

/**
 * ...
 * @author Aris Kostakos
 */
class Logic extends AService implements ILogic
{
	public var rootGameEntity( default, default ):IGameEntity;
	public var scriptInterpreter( default, null ):IInterpreter;
	public var gmlInterpreter( default, null ):IInterpreter;
	public var gameFactory( default, null ):IGameFactory;
	
	public function new() 
	{
		super();
		
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init Logic std Service...");
		
		//Create Script Interpreter
		scriptInterpreter = new HaxeInterpreter();
		
		//Create Gml Interpreter
		gmlInterpreter = new GmlInterpreter();
		
		//Create GameFactory
		gameFactory = new GameFactory();
	}
	
	public function update():Void
	{
		if (rootGameEntity != null) rootGameEntity.doActions();
	}
	
	public function startAction(entity:IGameEntity, actionId:String):Bool
	{
		return entity.startAction(actionId);
	}
	
}