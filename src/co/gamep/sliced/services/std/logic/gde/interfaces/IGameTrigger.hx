/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.services.std.logic.gde.interfaces;

/**
 * ...
 * @author Aris Kostakos
 */
interface IGameTrigger extends IGameBase
{
	var eventPrefab( default, default ):EEventPrefab;
	var scriptSet( default, null ):Array<Int>;
	var userEntity( default, default ):IGameEntity;

	
	
	//uses ????????
	
	function doPass():Void;
}