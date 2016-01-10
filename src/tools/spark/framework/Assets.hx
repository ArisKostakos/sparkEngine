/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2013
 */

package tools.spark.framework;

import flambe.asset.AssetPack;
import tools.spark.framework.assets.FlambeLoader;
import flambe.asset.File;
import flambe.display.Texture;
import flambe.sound.Sound;
import flambe.util.Signal0;
import flambe.util.Signal1;
import flambe.util.Signal2;
import tools.spark.framework.assets.interfaces.IBatchLoader;

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
	//These are signals that we pass by from Platform Specific Loader (e.g. flambe loader) to inform us of OVERALL progress of ALL Batch Loaders
	public static var successSignal:Signal0;
	public static var errorSignal:Signal1<String>;
	public static var progressSignal:Signal2<Float,Float>;
	
	private static var _loader:FlambeLoader; //When more loaders are supported, ifdef this..
	
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
	
	//Start new Batch Load Job (returns IBatchLoader, and user uses that one to complete job)
	public static function initiateBatch():IBatchLoader
	{
		return _loader.startNewBatchLoad();
	}
	
	//Right now, these will never trigger because flambe Loader never emits anything itself
	private static function _onLoaderSuccess():Void
	{
		Console.log("Assets: SUCCESS!");
		successSignal.emit();
	}
	
	private static function _onLoaderError(p_error:String):Void
	{
		Console.log("Assets: ERROR: " + p_error);
		errorSignal.emit(p_error);
	}
	
	private static function _onLoaderProgress(p_progress:Float, p_total:Float):Void
	{
		//trace("Assets: Progress: Loaded " + p_progress + " Bytes out of " + p_total + " total Bytes...");
		progressSignal.emit(p_progress, p_total);
	}
	
	//Wrappers, passing information from Platform Specific Loader
	public static function getAssetPackOf(p_name:String):AssetPack
	{
		try 
		{
			return _loader.getAssetPackOf(p_name);
		}
		catch (e:Dynamic)
		{
			Console.error("ERROR: Could not find assetPack of: " + p_name);
			return null;
		}
	}
	
	public static function getFile(p_name:String):File
	{
		try 
		{
			return _loader.getFile(p_name);
		}
		catch (e:Dynamic)
		{
			Console.error("ERROR: Could not find file: " + p_name);
			return null;
		}
	}
	
	public static function getTexture(p_name:String):Texture
	{
		try 
		{
			return _loader.getTexture(p_name);
		}
		catch (e:Dynamic)
		{
			Console.error("ERROR: Could not find texture: " + p_name);
			return null;
		}
	}
	
	public static function getSound(p_name:String):Sound
	{
		try 
		{
			return _loader.getSound(p_name);
		}
		catch (e:Dynamic)
		{
			Console.error("ERROR: Could not find sound: " + p_name);
			return null;
		}
	}
	/*
	public static function testLoadFile(p_name:String, p_url:String, p_forceLoadAsData:Bool):Void
	{
		_loader.startNewBatchLoad();
		_loader.addFile(p_name, p_url, p_forceLoadAsData);
		_loader.initiateLoad();
	}*/
}