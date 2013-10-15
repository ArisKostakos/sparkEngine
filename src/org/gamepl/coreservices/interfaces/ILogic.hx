/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package org.gamepl.coreservices.interfaces;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.IGameEntity;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.IGameFactory;
import org.gamepl.coreservices.services.std.logic.interpreter.interfaces.IInterpreter;
/**
 * ...
 * @author Aris Kostakos
 */
interface ILogic extends IService
{
	var rootGameEntity( default, default ):IGameEntity;
	
	var interpreter( default, null ):IInterpreter;
	var gameFactory( default, null ):IGameFactory;
	function startAction(entity:IGameEntity, actionId:String):Bool;
	function update():Void;
}