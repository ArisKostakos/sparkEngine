/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2014
 */

package tools.spark.sliced.interfaces;

/**
 * ...
 * @author Aris Kostakos
 */
interface IComms extends IService
{
	function connectTo(p_hostname:String, p_port:String, ?p_serverIdentifier:String):Void;
	function update():Void;
}