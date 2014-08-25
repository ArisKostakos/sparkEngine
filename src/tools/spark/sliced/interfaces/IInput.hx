/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.interfaces;
import flambe.input.Key;

/**
 * ...
 * @author Aris Kostakos
 */
interface IInput extends IService
{
	function update():Void;
	function isKeyPressed( type:Key ):Bool;
	function isKeyReleased( type:Key ):Bool;
	function isKeyDown( type:Key ):Bool;
}