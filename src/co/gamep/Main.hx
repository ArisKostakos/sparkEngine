package co.gamep;

import co.gamep.sliced.core.Sliced;
import flambe.asset.AssetPack;
import flambe.System;

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
    }

}
