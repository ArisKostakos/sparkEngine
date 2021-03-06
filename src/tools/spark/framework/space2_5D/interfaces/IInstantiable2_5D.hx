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

interface IInstantiable2_5D extends IObjectContainer2_5D
{
	//instantiable 
	//function createAllInstances ():Void;
	function createInstance (p_view2_5D:IView2_5D):Dynamic;
	function update(?p_view2_5D:IView2_5D):Void;
	function updateState(p_state:String, ?p_view2_5D:IView2_5D):Void;
	function getInstance(p_view2_5D:IView2_5D):Dynamic;
	var groupInstances( default, null ):Map<IView2_5D, Group>;
	//addChild
	//removeChild
	//bluh bluh bluh bluh
}