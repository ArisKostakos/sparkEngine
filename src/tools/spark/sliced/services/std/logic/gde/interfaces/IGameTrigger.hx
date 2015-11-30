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
	var eventType( default, default ):EEventType;
	var parameter( default, default ):Dynamic; //Could be Key, or String, or..
	var target( default, default ):String; //Could be gameEntity UId(String), or name(String), or group(String), or..
	var targetType( default, default ):String; //Describes what the target is, depending on the event, etc..
	var scriptSet( default, null ):Array<Int>;
	var pickedObject( default, default ):IGameEntity;
	
	
	//uses ????????
	
	function doPass():Void;
	function clone(?p_parentEntity:IGameEntity):IGameTrigger;
}