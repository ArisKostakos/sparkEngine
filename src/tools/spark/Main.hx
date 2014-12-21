/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2013
 */

package tools.spark;

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
		Assets.successSignal.connect(_onClientConfigLoaded).once();
		
		Assets.initiateBatch();
		Assets.addFile("main.skc", "config");
		Assets.loadBatch();
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
		for (moduleName in Project.executeModules)
			ModuleManager.execute(moduleName);
			
		//Create Spark's Flambe Root Component
		System.root.add(new RootComponent());
    }
}
