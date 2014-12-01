/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.interfaces;

/**
 * @author Aris Kostakos
 */

interface IView2_5D
{
	var name( default, default ):String;
	var scene( default, set ):IScene2_5D;
	var camera( default, set ):ICamera2_5D;
	function render():Void;
}