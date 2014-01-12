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
		
		//Load Minimal Assets (e.g. config files)
		//Assets.assetsLoaded.connect(_onAssetsLoaded).once();  //Loads all Assets temporarily
		Assets.testLoadFile("test file", "image.png", true);
    }

	private static function _onAssetsLoaded()
    {
		//Init Config
		//Config.init(Assets.config.getFile("config.xml").toString()); //FIXMENOW
		
		//Init Sliced
		Sliced.init();
		
		//Create Display Renderers
		Framework.createDisplayRenderers();
		
		//Create Game
		System.root.add(new Game());
    }

}
