/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2016
 */

package tools.spark.framework.assets.interfaces;
import flambe.util.Signal0;
import flambe.util.Signal1;
import flambe.util.Signal2;

/**
 * @author Aris Kostakos
 */

interface IBatchLoader
{
	var successSignal:Signal0;
	var errorSignal:Signal1<String>;
	var progressSignal:Signal2<Float,Float>;
	
	function addFile(p_url:String, ?p_name:String, p_forceLoadAsData:Bool = false):Void;
	function start():Void;
}