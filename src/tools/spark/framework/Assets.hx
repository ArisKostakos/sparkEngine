/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2013
 */

package tools.spark.framework;

import flambe.asset.AssetPack;
import flambe.platform.BasicFile;
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
@:keepSub class Assets
{ 
	//These are signals that we pass by from Platform Specific Loader (e.g. flambe loader) to inform us of OVERALL progress of ALL Batch Loaders
	public static var successSignal:Signal0;
	public static var errorSignal:Signal1<String>;
	public static var progressSignal:Signal2<Float,Float>;
	
	private static var _loader:FlambeLoader; //When more loaders are supported, ifdef this..
	
	private static var _cache:Map<String,File>;
	
	public static function init():Void
	{
		_loader = new FlambeLoader();
		_loader.successSignal.connect(_onLoaderSuccess);
		_loader.errorSignal.connect(_onLoaderError);
		_loader.progressSignal.connect(_onLoaderProgress);
		
		successSignal = new Signal0();
		errorSignal = new Signal1<String>();
		progressSignal = new Signal2<Float,Float>();
		
		//Cache (mainly used for scripts that are modified in memory from the editor)
		_cache = new Map<String,File>();
	}
	
	//Start new Batch Load Job (returns IBatchLoader, and user uses that one to complete job)
	public static function initiateBatch():IBatchLoader
	{
		return _loader.startNewBatchLoad();
	}
	
	//I load an orphan DBA (orphan meaning it's not meant to be loaded in a module)
	//If Asset already loaded, return null instead
	//This function loads thing from Spark Servers "/assets/user/type" structure...
	//p_owner is either a user DBO or a team DBO
	public static function loadOrphanAsset(p_asset:Dynamic, p_owner:Dynamic, p_callBack:Dynamic=null):Bool //in scripts, i always get return==false (dont know why) so we treat this function as :Void
	{
		//Flambe Asset Id
		var p_assetId:String = p_asset.type + ':' + p_asset.name;
		
		//Is File already loaded?
		if (!Assets.fileLoaded(p_assetId))
		{
			//Create Batck Loader
			var p_batchLoader:IBatchLoader = initiateBatch();
			
			//Get Asset Url
			var p_assetUrl:String = '/assets/' + p_owner.name + '/' + p_asset.type + '/' + p_asset.dir + '/' + p_asset.fileName + '.' + p_asset.fileExtension;
			
			//Add File
			Console.log("Adding Orphan File ["+p_assetId+"]...");
			p_batchLoader.addFile(p_assetUrl, p_assetId);
			
			//Add CallBack
			if (p_callBack!=null)
				p_batchLoader.successSignal.connect(p_callBack).once();
			
			//Start Loading
			p_batchLoader.start();
			
			//Started Loading (expect news from your callback)
			return true; //doesn't work?
		}
		else
		{
			//Nothing will Load. File exists
			Console.warn("File [" + p_assetId + "] is already loaded. Ignoring...");
			
			//Callback
			if (p_callBack != null)
				p_callBack();
				
			return false;
		}
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
	
	public static function assetLoaded(p_name:String):Bool
	{
		if (_cache.exists(p_name))
			return true;
		else
			return _loader.assetLoaded(p_name);
	}
	
	public static function fileLoaded(p_name:String):Bool
	{
		if (_cache.exists(p_name))
			return true;
		else
			return _loader.assetLoaded(p_name);
	}
	
	//This should consider cache as well.. but I haven't done it cause I use it below, cause I was too lazy to do the try catch thing inside the other function
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
	
	
	public static function scriptLoaded(p_name:String):Bool
	{
		var l_fullName:String = 'script:' + p_name;
		
		if (_cache.exists(l_fullName))
			return true;
		else
			return _loader.assetLoaded('script:'+p_name);
	}
	
	public static function getScript(p_name:String):File
	{
		var l_fullName:String = 'script:' + p_name;
		
		if (_cache.exists(l_fullName))
		{
			return _cache.get(l_fullName);
		}
		else
		{
			try 
			{
				return _loader.getFile(l_fullName);
			}
			catch (e:Dynamic)
			{
				Console.error("ERROR: Could not find script: " + p_name);
				return null;
			}
		}
	}
	
	public static function cacheScript(p_name:String, p_scriptContent:String):File
	{
		var l_fullName:String = 'script:' + p_name;
		
		//If it already exists in cache, dispose that
		if (_cache.exists(l_fullName))
		{
			removeCachedScript(p_name);
			
			Console.log("Cache Script: File existed in cache and disposed");
		}
		//Else if it already exists in flambe, dispose that
		else if (_loader.assetLoaded(l_fullName))
		{
			//TODO: Properly dispose file from the batchloaders here...
			
			getFile(l_fullName).dispose();
			
			Console.log("Cache Script: File existed in flambe and disposed");
		}
		else
		{
			Console.log("Cache Script: File did not exist");
		}
		
		//Create new File
		var l_file:File = new BasicFile(p_scriptContent);
		
		//Store
		_cache.set(l_fullName, l_file);
		
		//Return it
		return l_file;
	}
	
	public static function removeCachedScript(p_name:String):Bool
	{
		var l_fullName:String = 'script:' + p_name;
		
		if (_cache.exists(l_fullName))
		{
			//Dispose File
			_cache.get(l_fullName).dispose();
			
			//Remove from Cache
			_cache.remove(l_fullName);
			
			//File found
			return true;
		}
		else
		{
			//File not found
			return false;
		}
	}
	
	public static function textureLoaded(p_name:String):Bool
	{
		return _loader.assetLoaded(p_name);
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
	
	public static function soundLoaded(p_name:String):Bool
	{
		return _loader.assetLoaded(p_name);
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