/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.interpreter.interfaces;

/**
 * ...
 * @author Aris Kostakos
 */
interface IInterpreter
{
	public function hash(script:String):Int;
	public function run(hashId:Int, parameters:Map<String,Dynamic>):Bool;
}