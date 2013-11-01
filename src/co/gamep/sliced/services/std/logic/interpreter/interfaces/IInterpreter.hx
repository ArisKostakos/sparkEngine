/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.services.std.logic.interpreter.interfaces;

/**
 * ...
 * @author Aris Kostakos
 */
interface IInterpreter
{
	public function hash(script:String):Int;
	public function run(hashId:Int, parameters:Map<String,Dynamic>):Bool;
}