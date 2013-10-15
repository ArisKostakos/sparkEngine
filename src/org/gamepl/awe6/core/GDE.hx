/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, July 2013
 */

 package org.gamepl.awe6.core;
import awe6.core.Context;
import awe6.core.Entity;
import awe6.interfaces.IKernel;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.IGDE;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.IGameFactory;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.IGameEntity;
import org.gamepl.coreservices.core.Game;
/**
 * ...
 * @author Aris Kostakos
 */
	
class GDE extends Entity implements IGDE
{	
	public function new( p_kernel:IKernel ) 
	{
		super( p_kernel);
	}
	
	override private function _init():Void 
	{
		super._init();
		// extend here
		
		
		//Create Root GameEntity
		Game.logic.rootGameEntity = Game.logic.gameFactory.createGameEntity(_kernel.getConfig( "settings.rootGameEntity" ));
		
		if (Game.logic.rootGameEntity == null)
		{
			Console.error("Root Game Entity could not be created!");
		}
		else
		{
			Console.info("Root Game Entity was created successfully!");
		}
		
		//Test Draw
		//Game.display.test();
	}
	
	override private function _updater( p_deltaTime:Int = 0 ):Void 
	{
		super._updater( p_deltaTime );
		// extend here
		
		//S.L.I.C.E.D. Update
		Game.update();
	}
	
	override private function _disposer():Void 
	{
		// extend here
		super._disposer();		
	}
	
}