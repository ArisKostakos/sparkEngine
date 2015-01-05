/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.interfaces;

/**
 * @author Aris Kostakos
 */

interface ICamera2_5D extends IObject2_5D
{
	function createInstance (p_view2_5D:IView2_5D):Dynamic;
}