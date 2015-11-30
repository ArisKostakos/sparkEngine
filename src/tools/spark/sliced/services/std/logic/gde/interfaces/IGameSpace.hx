/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.gde.interfaces;

/**
 * ...
 * @author Aris Kostakos
 */
interface IGameSpace extends IGameBase
{
	var gameEntitySet( default, null ):Array<IGameEntity>;
	function clone(?p_parentEntity:IGameEntity):IGameSpace;
}