/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.interfaces;
import tools.spark.framework.space2_5D.layout.core.GroupSpace2_5D;

/**
 * @author Aris Kostakos
 */

interface IInstantiable2_5D extends IObjectContainer2_5D
{
	//instantiable 
	//function createAllInstances ():Void;
	function createInstance (p_view2_5D:IView2_5D):Dynamic;
	function update(?p_view2_5D:IView2_5D):Void;
	function updateState(p_state:String, ?p_view2_5D:IView2_5D):Void;
	var groupInstances( default, null ):Map<IView2_5D, GroupSpace2_5D>;
	//addChild
	//removeChild
	//bluh bluh bluh bluh
}