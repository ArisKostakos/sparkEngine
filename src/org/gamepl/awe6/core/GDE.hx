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
	//private var _context:Context;
	public var rootGameEntity( default, null ):IGameEntity;
	
	public function new( p_kernel:IKernel ) 
	{
		//_context = new Context();
		super( p_kernel);// , _context );
	}
	
	override private function _init():Void 
	{
		super._init();
		// extend here
		
		
		//Create Root GameEntity
		rootGameEntity = Game.logic.gameFactory.createGameEntity(_kernel.getConfig( "settings.rootGameEntity" ));
		
		if (rootGameEntity == null)
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
		
		//Input Update
		Game.input.update();
		
		//Event Update
		Game.event.update();
		
		//Logic Update
		if (rootGameEntity != null) rootGameEntity.doActions();
		
		//Display Update
		Game.display.update();
	}
	
	override private function _disposer():Void 
	{
		// extend here
		super._disposer();		
	}
	
}