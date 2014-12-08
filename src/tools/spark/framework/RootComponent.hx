/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2013
 */

package tools.spark.framework;

import tools.spark.sliced.core.Sliced;
import flambe.Component;

/**
 * ...
 * @author Aris Kostakos
 */
class RootComponent extends Component
{
	public function new()
	{
		//Create Root GameEntity
		Sliced.logic.rootGameEntity = Sliced.logic.gameFactory.createGameEntity(Config.getConfig( "game.rootGameEntity" ));
		
		if (Sliced.logic.rootGameEntity == null)
		{
			Console.error("Root Game Entity could not be created!");
		}
		else
		{
			Console.info("Root Game Entity was created successfully!");
		}
	}

	override public function onUpdate (dt :Float)
	{
		Sliced.update();
	}
}
