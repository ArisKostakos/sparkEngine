/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.interfaces;
import tools.spark.framework.layout.containers.Group;

/**
 * @author Aris Kostakos
 */

interface IView2_5D extends IBase2_5D
{
	var scene( default, set ):IScene2_5D;
	var camera( default, set ):ICamera2_5D;
	var group( default, null ):Group;
	function render():Void;
}