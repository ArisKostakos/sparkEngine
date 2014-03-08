/* Copyright © Game Plus Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, October 2013
 */

package co.gamep.framework;

import co.gamep.framework.assets.FlambeLoader;

/**
 * Client Version of the Assets System
 * The Server Version will be almost similar
 * But will use mloader for the loader, and will not support many features
 * just statically loading a lot of XML files at once
 * then delivering them upon request
 * Also, instead of Flambe Signals it uses msignal
 * @author Aris Kostakos
 */
class AssetsNew //[PROTOTYPE HACK: rename]
{ 
	private static var _loader:FlambeLoader;
	
	public static function init():Void
	{
		_loader = new FlambeLoader();
		_loader.successSignal.connect(_onLoaderSuccess);
		_loader.errorSignal.connect(_onLoaderError);
		_loader.progressSignal.connect(_onLoaderProgress);
	}
	
	private static function _onLoaderSuccess():Void
	{
		trace("Assets: SUCCESS!");
	}
	
	private static function _onLoaderError(p_error:String):Void
	{
		trace("Assets: ERROR: " + p_error);
	}
	
	private static function _onLoaderProgress(p_progress:Float, p_total:Float):Void
	{
		trace("Assets: Progress: Loaded " + p_progress + " Bytes out of " + p_total + " total Bytes...");
	}
	
	public static function testLoadFile(p_name:String, p_url:String, p_forceLoadAsData:Bool):Void
	{
		_loader.startNewBatchLoad();
		_loader.addFile(p_name, p_url, p_forceLoadAsData);
		_loader.initiateLoad();
	}
}