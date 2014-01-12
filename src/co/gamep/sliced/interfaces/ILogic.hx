/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.interfaces;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameEntity;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameFactory;
import co.gamep.sliced.services.std.logic.interpreter.interfaces.IInterpreter;
/**
 * ...
 * @author Aris Kostakos
 */
interface ILogic extends IService
{
	var rootGameEntity( default, default ):IGameEntity;
	
	var scriptInterpreter( default, null ):IInterpreter;
	var gmlInterpreter( default, null ):IInterpreter;
	var gameFactory( default, null ):IGameFactory;
	function startAction(entity:IGameEntity, actionId:String):Bool;
	function update():Void;
}