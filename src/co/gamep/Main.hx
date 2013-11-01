/* Copyright © Game Plus Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, October 2013
 */

package co.gamep;

import co.gamep.sliced.core.Sliced;
import flambe.asset.AssetPack;
import flambe.System;

/**
 * ...
 * @author Aris Kostakos
 */
class Main
{
	private static function main()
    {
        // Wind up all platform-specific stuff
        System.init();
		
		//Load all Assets
		Assets.assetsLoaded.connect(_onAssetsLoaded).once();
		Assets.init();
    }

	private static function _onAssetsLoaded()
    {
		//Init Config
		Config.init(Assets.config.getFile("config.xml").toString());
		
		//Init Sliced
		Sliced.init();
		
		//Create Game
		System.root.add(new Game());
    }

}
