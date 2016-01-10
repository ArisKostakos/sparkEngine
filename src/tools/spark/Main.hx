/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2013
 */

package tools.spark;

import tools.spark.framework.assets.interfaces.IBatchLoader;
import tools.spark.framework.Project;
import tools.spark.framework.ModuleManager;
import tools.spark.sliced.core.Sliced;
import tools.spark.framework.Framework;
import tools.spark.framework.Assets;
import tools.spark.framework.config.Config;
import tools.spark.framework.RootComponent;
import flambe.System;

/**
 * ...
 * @author Aris Kostakos
 */
class Main
{
	private static function main()
    {
		//Init Framework (flambe, graphics, etc..)
		Framework.init();
		
		//Load config
		_loadClientConfig();
    }

	private static function _loadClientConfig():Void
	{
		var l_loader:IBatchLoader = Assets.initiateBatch();
		l_loader.addFile(_getSkcUrl(), "config");
		l_loader.successSignal.connect(_onClientConfigLoaded).once();
		l_loader.start();
	}
	
	private static function _onClientConfigLoaded()
    {
		//Init Config
		var l_configurator:Config = new Config(Assets.getFile("config"));
		
		if (l_configurator.parseClient() == false)
		{
			Console.error("Failed to parse configuration file. Aborting...");
			return;
		}

		//Init Sliced (For Client)
		Sliced.init();
		
		//Create Display Renderers
		Framework.createDisplayRenderers();
		
		//Execute Modules
		for (moduleName in Project.main.executeModules)
			ModuleManager.execute(moduleName);
			
		//Create Spark's Flambe Root Component
		System.root.add(new RootComponent());
    }
	
	//Get External skc url if provided
	private static function _getSkcUrl():String
	{
		try
		{
			var l_urlPars:Dynamic = System.external.call("getMainSparkClientUrl");
			if (l_urlPars.user != null && l_urlPars.project != null)
				return "/assets/" + l_urlPars.user + "/project/" + l_urlPars.project + "/main.skc";
			else
				return "main.skc";
		}
		catch (e : Dynamic)
			return "main.skc";
	}
}
