/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2013
 */

package tools.spark;


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
		loadClientConfig();
    }

	private static function loadClientConfig():Void
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
		l_configurator.parseClient();
		
		return;
		//Init Sliced
		Sliced.init();
		
		//Create Display Renderers
		Framework.createDisplayRenderers();
		
		loadFuckingEverything();
    }

	
	private static function loadFuckingEverything():Void
	{
		Assets.successSignal.connect(_onFuckingEverythingLoaded).once();
		
		Assets.initiateBatch();
		
		//[ARKANOID HACK]: Load fucking everything. (these should be parsed from the main.gpc instead)
		Assets.addFile("assets/images/Ball.png");
		
		Assets.addFile("assets/lionscript/Arkanoid/Arkanoid.egc");
		Assets.addFile("assets/lionscript/Arkanoid/Space.egc");
		Assets.addFile("assets/lionscript/Arkanoid/Stage.egc");
		Assets.addFile("assets/lionscript/Arkanoid/GameView.egc");
		Assets.addFile("assets/lionscript/Arkanoid/GUIView.egc");
		Assets.addFile("assets/lionscript/Arkanoid/Scene.egc");
		Assets.addFile("assets/lionscript/Arkanoid/Camera.egc");
		Assets.addFile("assets/lionscript/Arkanoid/Object.egc");
		
		Assets.addFile("assets/lionscript/std/core/Base.egc");
		Assets.addFile("assets/lionscript/std/core/Project.egc");
		
		Assets.addFile("assets/lionscript/std/display/Base.egc");
		Assets.addFile("assets/lionscript/std/display/Space.egc");
		Assets.addFile("assets/lionscript/std/display/Stage.egc");
		Assets.addFile("assets/lionscript/std/display/View.egc");
		Assets.addFile("assets/lionscript/std/display/Scene.egc");
		Assets.addFile("assets/lionscript/std/display/Camera.egc");
		Assets.addFile("assets/lionscript/std/display/Object.egc");
		
		Assets.addFile("assets/lionscript/std/behaviors/core/Constructor.egc");
		Assets.addFile("assets/lionscript/std/behaviors/core/KeyboardInput.egc");
		Assets.addFile("assets/lionscript/std/behaviors/core/InputMove.egc");
		
		Assets.loadBatch();
	}
	
	private static function _onFuckingEverythingLoaded()
    {
		//Create Spark's Flambe Root Component
		System.root.add(new RootComponent());
	}
}
