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
interface IGameTrigger extends IGameBase
{
	var eventPrefab( default, default ):EEventPrefab;
	var scriptSet( default, null ):Array<Int>;

	
	
	//uses ????????
	
	function doPass():Void;
}