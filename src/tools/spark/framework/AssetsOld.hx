/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2013
 */
 
package tools.spark.framework;

import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.util.Promise;
import flambe.util.Signal0;

/**
 * Load the config folder statically...
 * Load the lionscript\std folder statically...
 * Load the lionscript\workingProject folder dynamically
 * should also load all other asset folders (data, images, models, sounds)
 * dynamically as well. BUT should load the std pards in those folders
 * statically here. For example a font that I should always have
 * available for ALL projects.. Should be very limited.
 * FOR NOW, load lionscript\workingProject folder statically as well...
 * FOR NOW, load all assets statically...
 * @author Aris Kostakos
 */
class AssetsOld
{
	public static var config( default, null ):AssetPack;
	public static var lionscript( default, null ):AssetPack;
	public static var images( default, null ):AssetPack;
	public static var assetsLoaded( default, null ):Signal0 = new Signal0(); 
	
	public static function init():Void
	{
		_loadConfig();
	}
	
	private static function _loadConfig()
    {
        var l_manifest:Manifest = Manifest.build("config");
        var l_loader:Promise<AssetPack> = System.loadAssetPack(l_manifest);
        l_loader.get(_onConfigLoaded);
    }
	
	private static function _onConfigLoaded(pack:AssetPack)
    {
		config = pack;
		
        var l_manifest:Manifest = Manifest.build("lionscript");
        var l_loader:Promise<AssetPack> = System.loadAssetPack(l_manifest);
        l_loader.get(_onLionscriptLoaded);
    }
	
	private static function _onLionscriptLoaded(pack:AssetPack)
    {
		lionscript = pack;
		
        var l_manifest:Manifest = Manifest.build("images");
        var l_loader:Promise<AssetPack> = System.loadAssetPack(l_manifest);
        l_loader.get(_onImagesLoaded);
    }
	
	private static function _onImagesLoaded(pack:AssetPack)
    {
		images = pack;
		
		assetsLoaded.emit();
    }
}