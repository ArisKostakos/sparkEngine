/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2016
 */

package tools.spark.framework.assets;

import flambe.asset.AssetEntry.AssetFormat;
import flambe.util.Signal0;
import flambe.util.Signal1;
import flambe.util.Signal2;
import tools.spark.framework.assets.interfaces.IBatchLoader;

/**
 * @author Aris Kostakos
 */
class ABatchLoader implements IBatchLoader
{	
	//These are the connections for when the batch is ready
	//primarily used from script or anywhere to see when batch is loaded
	//later, may also be used from Assets/FlambeLoader to figure out if all simutaneous batch loaders are done
	//and throw another signal, if they did.. also show Total progress for ALL simutaneous batches loading..
	public var successSignal:Signal0;
	public var errorSignal:Signal1<String>;
	public var progressSignal:Signal2<Float,Float>;
	
	
	public function new()
	{
		successSignal = new Signal0();
		errorSignal = new Signal1<String>();
		progressSignal = new Signal2<Float,Float>();
	}
	
	public function addFile(p_url:String, ?p_name:String, ?p_fileFormat:AssetFormat, p_bytes:Int = 50000/*assume 50k*/):Void
	{
		if (p_name == null) p_name = p_url;
		
		//Temp thing for Cross Domain requests during TESTING //REMOVE ME ON RELEASE
		#if debug
			if (p_url.indexOf('/assets') != -1)
				p_url = "http://130.211.172.86" + p_url;
		#end
		//END OF Temp thing for Cross Domain requests during TESTING //REMOVE ME ON RELEASE
		
		Console.log("BatchLoader: Requesting file " + p_url);
		
		//Add The file
		_addFile(p_name, p_url, p_fileFormat, p_bytes);
	}
	
	public function start():Void
	{
		//override me
		
	}
	
	private function _addFile(p_name:String, p_url:String, p_fileFormat:AssetFormat, p_bytes:Int):Void
	{
		//override me
		
	}
}