/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.interpreter.interfaces;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameBase;

/**
 * ...
 * @author Aris Kostakos
 */
interface IInterpreter
{
	function hash(script:String):Int;
	function hashExpr(script:String):Int;
	function run(hashId:Int, parameters:Map<String,Dynamic>):Bool;
	function runExpr(hashId:Int, ?p_me:IGameBase, ?p_parent:IGameBase, ?p_it:IGameBase):Dynamic;
}