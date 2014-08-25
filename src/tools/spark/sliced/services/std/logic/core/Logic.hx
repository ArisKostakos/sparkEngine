/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.core;

import tools.spark.sliced.interfaces.ILogic;
import tools.spark.sliced.core.AService;
import tools.spark.sliced.services.std.logic.gde.core.GameFactory;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameFactory;
import tools.spark.sliced.services.std.logic.interpreter.core.GmlInterpreter;
import tools.spark.sliced.services.std.logic.interpreter.core.HaxeInterpreter;
import tools.spark.sliced.services.std.logic.interpreter.interfaces.IInterpreter;

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