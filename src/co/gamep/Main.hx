/* Copyright © Game Plus Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, October 2013
 */

package co.gamep;


import co.gamep.sliced.core.Sliced;
import co.gamep.framework.Framework;
import co.gamep.framework.Assets;
import co.gamep.framework.Config;
import co.gamep.framework.Game;
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
		
		//[ARKANOID HACK]:
		setHandlerOnDOM();
		
		//Load config
		loadClientConfig();
    }

	private static function loadClientConfig():Void
	{
		Assets.successSignal.connect(_onClientMainLoaded).once(); //normally, this function (_onAssetsLoaded) should be _onMainGpcLoaded
		
		Assets.initiateBatch();
		Assets.addFile("main.gpc"); //normaly, just this is loaded, parse, and we subsequently will load every module required to run immediately.
		
		Assets.loadBatch();
	}
	
	private static function _onClientMainLoaded()
    {
		//Init Config
		Config.init(Assets.getFile("main.gpc").toString());
		
		//Init Sliced
		Sliced.init();
		
		//Create Display Renderers
		Framework.createDisplayRenderers();
		
		loadFuckingEverything();
    }

	
	
	//[ARKANOID HACK]: Load fucking everything. (these should be parsed from the main.gpc instead)
	private static function setHandlerOnDOM():Void
	{
		untyped
		{    
			var runButton = document.getElementById("runProjectButton");
			if ( runButton.addEventListener )
			{
				runButton.addEventListener( "click", clickHandlerFunction, false );
			} else {
				runButton.attachEvent( "onclick", clickHandlerFunction, false );
			}
		}
	}
	
	private static var clickHandlerFunction : Dynamic -> Void = function ( e : Dynamic )
	{
		untyped {   saveCurrentScript(); }
		
		loadFuckingEverything();
	}
	
	private static function loadFuckingEverything():Void
	{
		Assets.successSignal.connect(_onArkanoidLoaded).once(); //normally, this function (_onAssetsLoaded) should be _onMainGpcLoaded
		
		Assets.initiateBatch();
		
		//[ARKANOID HACK]: Load fucking everything. (these should be parsed from the main.gpc instead)
		Assets.addFile("assets/images/Background.png");
		Assets.addFile("assets/images/Paddle.png");
		Assets.addFile("assets/images/Brick.png");
		Assets.addFile("assets/images/Ball.png");
		
		Assets.addFile("assets/lionscript/Arkanoid/Arkanoid.egc");
		Assets.addFile("assets/lionscript/Arkanoid/Space.egc");
		Assets.addFile("assets/lionscript/Arkanoid/Stage.egc");
		Assets.addFile("assets/lionscript/Arkanoid/View.egc");
		Assets.addFile("assets/lionscript/Arkanoid/Scene.egc");
		Assets.addFile("assets/lionscript/Arkanoid/Camera.egc");
		
		Assets.addFile("assets/lionscript/std/core/Base.egc");
		Assets.addFile("assets/lionscript/std/core/Project.egc");
		
		Assets.addFile("assets/lionscript/std/display/Base.egc");
		Assets.addFile("assets/lionscript/std/display/Space.egc");
		Assets.addFile("assets/lionscript/std/display/Stage.egc");
		Assets.addFile("assets/lionscript/std/display/View.egc");
		Assets.addFile("assets/lionscript/std/display/Scene.egc");
		Assets.addFile("assets/lionscript/std/display/Camera.egc");
		
		Assets.addFile("assets/lionscript/std/behaviors/core/Constructor.egc");
		
		/*
		Assets.addFile("assets/lionscript/Arkanoid/gameobjects/Paddle.fgc");
		Assets.addFile("assets/lionscript/Arkanoid/gameobjects/Paddle.egc");
		Assets.addFile("assets/lionscript/Arkanoid/gameobjects/Background.fgc");
		Assets.addFile("assets/lionscript/Arkanoid/gameobjects/Background.egc");
		Assets.addFile("assets/lionscript/Arkanoid/gameobjects/Brick.fgc");
		Assets.addFile("assets/lionscript/Arkanoid/gameobjects/Brick.egc");
		Assets.addFile("assets/lionscript/Arkanoid/gameobjects/Ball.fgc");
		Assets.addFile("assets/lionscript/Arkanoid/gameobjects/Ball.egc");
		
		Assets.addFile("assets/lionscript/Arkanoid/Stage.egc");
		Assets.addFile("assets/lionscript/Arkanoid/Scene.egc");
		Assets.addFile("assets/lionscript/Arkanoid/Space.egc");
		Assets.addFile("assets/lionscript/Arkanoid/Game.egc");
		Assets.addFile("assets/lionscript/Arkanoid/Camera3D.egc");
		Assets.addFile("assets/lionscript/Arkanoid/View2D.egc");
		
		Assets.addFile("assets/lionscript/std/entities/Mesh.egc");
		Assets.addFile("assets/lionscript/std/entities/Space.egc");
		Assets.addFile("assets/lionscript/std/entities/Camera.egc");
		Assets.addFile("assets/lionscript/std/entities/View.egc");
		Assets.addFile("assets/lionscript/std/entities/Scene.egc");
		Assets.addFile("assets/lionscript/std/entities/Stage.egc");
		Assets.addFile("assets/lionscript/std/entities/Game.egc");
		
		Assets.addFile("assets/lionscript/std/entities/components/InputMove.egc");
		Assets.addFile("assets/lionscript/std/entities/components/PhysicsMove.egc");
		Assets.addFile("assets/lionscript/std/entities/components/InputRotate.egc");
		Assets.addFile("assets/lionscript/std/entities/components/LogicalComponent.egc");
		Assets.addFile("assets/lionscript/std/entities/components/Constructor.egc");
		Assets.addFile("assets/lionscript/std/entities/components/Positionable.egc");
		Assets.addFile("assets/lionscript/std/entities/components/KeyboardInput.egc");
		
		Assets.addFile("assets/lionscript/std/forms/Mesh.fgc");
		
		Assets.addFile("assets/lionscript/std/triggers/AnnounceMe.tgc");
		*/
		
		Assets.loadBatch();
	}
	
	private static function _onArkanoidLoaded()
    {
		//Serious memory leaks must be going on here!!!!
		System.root.disposeChildren();
		
		//Create Game
		System.root.add(new Game());
	}
}
