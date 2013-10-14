/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package org.gamepl.coreservices.services.std.logic.core;

import awe6.interfaces.IEntity;
import awe6.interfaces.IKernel;
import org.gamepl.coreservices.interfaces.ILogic;
import org.gamepl.coreservices.core.AService;
import org.gamepl.coreservices.services.std.logic.gde.core.GameFactory;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.IGameEntity;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.IGameFactory;
import org.gamepl.coreservices.services.std.logic.interpreter.core.HaxeInterpreter;
import org.gamepl.coreservices.services.std.logic.interpreter.interfaces.IInterpreter;

/**
 * ...
 * @author Aris Kostakos
 */
class Logic extends AService implements ILogic
{
	public var interpreter( default, null ):IInterpreter;
	public var gameFactory( default, null ):IGameFactory;
	
	public function new(p_kernel:IKernel) 
	{
		super(p_kernel);
		
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init Logic std Service...");
		
		//Create Interpreter
		interpreter = new HaxeInterpreter();
		
		//Create GameFactory
		gameFactory = new GameFactory(_kernel.getConfig( "settings.gameClassPackage" ));
	}
	
	public function startAction(entity:IGameEntity, actionId:String):Bool
	{
		return entity.startAction(actionId);
	}
	
}