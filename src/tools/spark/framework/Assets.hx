/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2013
 */

package tools.spark.framework;

import tools.spark.framework.assets.FlambeLoader;
import flambe.asset.File;
import flambe.display.Texture;
import flambe.sound.Sound;
import flambe.util.Signal0;
import flambe.util.Signal1;
import flambe.util.Signal2;

/**
 * Client Version of the Assets System
 * The Server Version will be almost similar
 * But will use mloader for the loader, and will not support many features
 * just statically loading a lot of XML files at once
 * then delivering them upon request
 * Also, instead of Flambe Signals it uses msignal
 * @author Aris Kostakos
 */
class Assets
{ 
	public static var successSignal:Signal0;
	public static var errorSignal:Signal1<String>;
	public static var progressSignal:Signal2<Float,Float>;
	
	private static var _loader:FlambeLoader;
	
	public static function init():Void
	{
		_loader = new FlambeLoader();
		_loader.successSignal.connect(_onLoaderSuccess);
		_loader.errorSignal.connect(_onLoaderError);
		_loader.progressSignal.connect(_onLoaderProgress);
		
		successSignal = new Signal0();
		errorSignal = new Signal1<String>();
		progressSignal = new Signal2<Float,Float>();
	}
	
	private static function _onLoaderSuccess():Void
	{
		trace("Assets: SUCCESS!");
		successSignal.emit();
	}
	
	private static function _onLoaderError(p_error:String):Void
	{
		trace("Assets: ERROR: " + p_error);
		errorSignal.emit(p_error);
	}
	
	private static function _onLoaderProgress(p_progress:Float, p_total:Float):Void
	{
		trace("Assets: Progress: Loaded " + p_progress + " Bytes out of " + p_total + " total Bytes...");
		progressSignal.emit(p_progress, p_total);
	}
	
	public static function initiateBatch():Void
	{
		_loader.startNewBatchLoad();
	}
	
	public static function addFile(p_url:String, ?p_name:String, p_forceLoadAsData:Bool=false):Void
	{
		if (p_name == null) p_name = p_url;
		
		_loader.addFile(p_name, p_url, p_forceLoadAsData);
	}
	
	public static function loadBatch():Void
	{
		_loader.initiateLoad();
	}
	
	public static function getFile(p_name:String):File
	{
		return _loader.getFile(p_name);
	}
	
	public static function getTexture(p_name:String):Texture
	{
		return _loader.getTexture(p_name);
	}
	
	public static function getSound(p_name:String):Sound
	{
		return _loader.getSound(p_name);
	}
	
	public static function testLoadFile(p_name:String, p_url:String, p_forceLoadAsData:Bool):Void
	{
		_loader.startNewBatchLoad();
		_loader.addFile(p_name, p_url, p_forceLoadAsData);
		_loader.initiateLoad();
	}
}