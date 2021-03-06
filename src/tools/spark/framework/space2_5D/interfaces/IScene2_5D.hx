/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.interfaces;

/**
 * @author Aris Kostakos
 */

interface IScene2_5D extends IInstantiable2_5D
{
	function updateCamera(p_view:IView2_5D, p_camera:ICamera2_5D):Void;
}