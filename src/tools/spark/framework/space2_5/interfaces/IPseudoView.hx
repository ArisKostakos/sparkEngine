/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2013
 */

package tools.spark.framework.pseudo3d.interfaces;

/**
 * ...
 * @author Aris Kostakos
 */
interface IPseudoView
{
	var camera( default, default ):IPseudoCamera;
	var scene( default, default ):IPseudoScene;
	var x( default, default ):Int;
	var y( default, default ):Int;
	var width( default, default ):Int;
	var height( default, default ):Int;
	
	function validate():Void;
	function render():Void;
}