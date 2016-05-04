/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2014
 */

package tools.spark.framework;
import flambe.asset.AssetEntry.AssetFormat;
import flambe.util.SignalConnection;
import flambe.util.Signal0;
import flambe.util.Signal1;
import flambe.util.Signal2;
import tools.spark.framework.assets.Asset;
import tools.spark.framework.assets.interfaces.IBatchLoader;
import tools.spark.framework.assets.Module;
import tools.spark.framework.assets.EModuleState;
import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
@:keep class ModuleManager
{
	private static var _moduleStates:Map<String,EModuleState>;
	private static var _modulesLoadQueue:Array<String>;
	private static var _modulesLoadQueueBytes:Array<Int>;
	private static var _loadingBatch:Bool;
	
	//Signals for ModuleManager<-BatchLoader
	private static var _loaderSignalSuccess:SignalConnection;
	private static var _loaderSignalError:SignalConnection;
	private static var _loaderSignalProgress:SignalConnection;
	
	//Signals for ExternalCaller<-ModuleManager
	public static var successSignal:Signal0; //we might need one more.. one for module loaded, one for all required modules loaded (finished)
	public static var errorSignal:Signal1<String>;
	public static var progressSignal:Signal2<Float,Float>;
	
	public static function init():Void
	{
		_moduleStates = new Map<String,EModuleState>();
		_modulesLoadQueue = new Array<String>();
		_modulesLoadQueueBytes = new Array<Int>();
		_loadingBatch = false;
		
		successSignal = new Signal0();
		errorSignal = new Signal1<String>();
		progressSignal = new Signal2<Float,Float>();
	}
	
	public static function getBytesOnQueue():Int
	{
		var l_totalBytes:Int = 0;
		
		for (bytes in _modulesLoadQueueBytes)
			l_totalBytes += bytes;
			
		return l_totalBytes;
	}
	
	//WARNING! This handler will immediately try to execute the module it just loaded.. If I want the public loadModule function to work properly
	//I should specify a static var that tells this function what the desired action is to proceed (execute, just load, throw Comms request, etc..)
	private static function _onLoaderSuccess():Void
	{
		_disposeBatchLoaderSignals();
		
		if (_loadingBatch == false)
		{
			//Got signal but it wasn't initiated from Module Manager. Ignoring (this solution sucks, see warning at the end)
			//Jan-2016: I fixed this, so maybe i can remove this check now...
			return;
		}
		
		//Loader not busy anymore
		_loadingBatch = false;
		
		//Get loaded module
		var l_moduleName:String = _modulesLoadQueue[0];
		
		Console.log("Module Loader: Success Loading Module: " + l_moduleName);
		
		//Mark it as loaded
		_moduleStates[l_moduleName] = LOADED;
		
		//Store Bytes Loaded
		_bytesLoaded += _modulesLoadQueueBytes[0];
		
		//Remove module from Queues
		_modulesLoadQueue.shift();
		_modulesLoadQueueBytes.shift();
		
		//Attempt to execute it if possible
		_executeModule(l_moduleName);
		
		//Load Next item in Queue (if any)
		_startLoadBatch();
	}
	
	private static function _onLoaderError(p_error:String):Void
	{
		_disposeBatchLoaderSignals();
		
		Console.error("Module Loader: ERROR: " + p_error);
		errorSignal.emit(p_error);
	}
	
	private static function _onLoaderProgress(p_progress:Float, p_total:Float):Void
	{
		//Console.warn("Module Loader: Progress: Loaded " + p_progress + " Bytes out of " + p_total + " total Bytes...");
		
		//Console.warn("TOTAL: " + _totalBytes + ", LOADED: " + _bytesLoaded + ", module size: " + p_total + ",module loaded: " + p_progress);
		_percDone = Std.int((_bytesLoaded+p_progress) * 100 / _totalBytes);
		
		//Console.warn("Percent Loaded: " + _percDone);
		progressSignal.emit(_percDone, _totalBytes); //So this is not great.. i changed the parameters a little bit to total percentage.. should reflect this everywhere
	}
	
	private static var _percDone:Int;
	private static var _totalBytes:Int;
	private static var _bytesLoaded:Int;
	
	public static function execute(p_moduleName:String):Void
	{
		if (isModuleLoaded(p_moduleName)) _executeModule(p_moduleName);
		else
		{
			_percDone = 0;
			_totalBytes = 0;
			_bytesLoaded = 0;
			_loadModule(p_moduleName);
		}
	}
	
	//add a public static load function that does not try to execute?? hmmm or not
	
	public static function getModuleState(p_ModuleName:String):EModuleState
	{
		if (_moduleStates[p_ModuleName] == null) _moduleStates[p_ModuleName] = NOT_LOADED;
		
		return _moduleStates[p_ModuleName];
	}
	
	public static function isModuleLoaded(p_ModuleName:String):Bool
	{
		switch (getModuleState(p_ModuleName))
		{
			case NOT_LOADED, LOADING:
				return false;
			case LOADED, RUNNING, PAUSED:
				return true;
		}
	}
	
	public static function isModuleExecuted(p_ModuleName:String):Bool
	{
		switch (getModuleState(p_ModuleName))
		{
			case NOT_LOADED, LOADING, LOADED:
				return false;
			case RUNNING, PAUSED:
				return true;
		}
	}

	public static function createAllPaths(p_location:String, p_url:String):Void
	{
		Project.main.setPath(p_location, "script", p_url + 'script');
		Project.main.setPath(p_location, "image", p_url + 'image');
		Project.main.setPath(p_location, "model", p_url + 'model');
		Project.main.setPath(p_location, "sound", p_url + 'sound');
		Project.main.setPath(p_location, "data", p_url + 'data');
	}
	
	public static function createNewModule(p_id:String, ?p_requiresModules:Array<String>, ?p_executeEntity:String, ?p_assets:Map< String, Asset>):Module
	{
		if (Project.main.modules.exists(p_id) == false)
		{
			var l_module:Module = new Module(p_id);
			
			if (p_requiresModules != null)
				l_module.requiresModules = p_requiresModules;
			
			if (p_executeEntity != null)
				l_module.executeEntity = p_executeEntity;
			else
				l_module.executeEntity = "none";
				
			if (p_assets != null)
				l_module.assets = p_assets;
			
			//Add it to Project
			Project.main.modules.set(p_id, l_module);
			
			return l_module;
		}
		else
		{
			Console.warn("Project " + p_id + " already exists! Ignoring...");
			return null;
		}
	}
	
	public static function createNewAsset(?p_id:String, ?p_url:String, ?p_type:String, ?p_subtype:String, ?p_location:String, ?p_bytes:String, ?p_condition:String, ?p_forceLoadAsData:String):Asset
	{
		var l_asset:Asset = new Asset(p_id);
			
		if (p_url != null)
			l_asset.url = p_url;
		
		if (p_type != null)
			l_asset.type = p_type;
			
		if (p_subtype != null)
			l_asset.subtype = p_subtype;
			
		if (p_location != null)
			l_asset.location = p_location;
			
		if (p_bytes != null)
			l_asset.bytes = p_bytes;
			
		if (p_condition != null)
			l_asset.condition = p_condition;
			
		if (p_forceLoadAsData != null)
			l_asset.forceLoadAsData = p_forceLoadAsData;
		
		return l_asset;
	}
	
	public static function addAssetToModule(p_asset:Asset, p_module:Module):Bool
	{
		if (p_module.assets.exists(p_asset.id) == false)
		{
			p_module.assets.set(p_asset.id, p_asset);
			return true;
		}
		else
		{
			Console.warn("Asset " + p_asset.id + " already exists in module " + p_module.id +". Ignoring...");
			return false;
		}
	}
	
	public static function loadModule(p_moduleName:String, ?p_callbackEntity:IGameEntity):Void  //We don't use p_callbackEntity yet.. we do it with flambe signals for now, not Comms
	{
		if (Project.main.modules.exists(p_moduleName))
		{
			if (getModuleState(p_moduleName) == NOT_LOADED)
			{
				_loadModule(p_moduleName);
			}
			else
			{
				Console.de("Over here, we send a comm reply that the module is loaded, same as in _loadModule");
			}
		}
		else
		{
			Console.error("Module Manager: Error Loading Module! Module [" + p_moduleName+"] not found!");
		}
	}
	
	private static function _executeModule(p_moduleName:String):Void
	{
		if (isModuleExecuted(p_moduleName))
		{
			Console.warn("Warning while trying to execute Module [" + p_moduleName + "]. Module already executed. Ignoring..");
			return;
		}
		else
		{
			if (isModuleExecutable(p_moduleName))
			{
				Sliced.logic.createAndRun(Project.main.modules[p_moduleName].executeEntity);
				_moduleStates[p_moduleName] = RUNNING;
			}
			else
			{
				//Console.warn("Warning while trying to execute Module [" + p_moduleName + "]. Module is not executable. Ignoring..");
				return;
			}
		}
	}
	
	public static function isModuleExecutable(p_moduleName:String):Bool
	{
		if (Project.main.modules[p_moduleName].executeEntity == "none")
			return false;
		else
			return true;
	}
	
	private static function _loadModule(p_moduleName:String):Void
	{
		Console.log("Module Manager: Loading module " + p_moduleName);
		
		if (Project.main.modules.exists(p_moduleName))
		{
			if (getModuleState(p_moduleName) == NOT_LOADED)
			{
				//@todo Watch for Recursion for two modules both requiring one another!
				for (f_requiredModuleName in Project.main.modules[p_moduleName].requiresModules)
				{
					Console.log("Module Manager: Loading required module " + f_requiredModuleName);
					if (getModuleState(f_requiredModuleName) == NOT_LOADED)
						_loadModule(f_requiredModuleName);
				}
				
				_loadAssetsOfModule(p_moduleName);
			}
		}
		else
		{
			Console.error("Module Manager: Error Loading Module! Module [" + p_moduleName+"] not found!");
		}
	}
	
	//@donow: one things plz. the Asset loaded, so we can check here if asset already loaded.
	private static function _loadAssetsOfModule(p_moduleName:String):Void
	{
		var l_bytes:Int = 0;
		
		for (asset in Project.main.modules[p_moduleName].assets)
			l_bytes += Std.parseInt(asset.bytes);
		
		_moduleStates[p_moduleName] = LOADING;
		_modulesLoadQueue.push(p_moduleName);
		_modulesLoadQueueBytes.push(l_bytes);
		_totalBytes += l_bytes;
		
		if (_loadingBatch==false) _startLoadBatch();
	}
	
	private static function _startLoadBatch():Void
	{
		//do a check here if _loadingBatch is false? don't have to currently due to logic, but maybe just 
		//do be safe? performance vs safety, hmmmm
		
		
		if (_modulesLoadQueue.length > 0)
		{
			var l_moduleName:String = _modulesLoadQueue[0];
			
			var l_loader:IBatchLoader = Assets.initiateBatch();
			
			//Set up signals..
			_loaderSignalSuccess = l_loader.successSignal.connect(_onLoaderSuccess);
			_loaderSignalError = l_loader.errorSignal.connect(_onLoaderError);
			_loaderSignalProgress = l_loader.progressSignal.connect(_onLoaderProgress);
			
			//Add Assets
			for (asset in Project.main.modules[l_moduleName].assets)
			{
				//Console.log("adding file: " + asset.id);
				l_loader.addFile(Project.main.getPath(asset.location,asset.type)+'/'+asset.url, asset.id, (asset.forceLoadAsData=="true")?AssetFormat.Data:null, Std.parseInt(asset.bytes));
			}
			
			//Start Loading
			l_loader.start();
			
			_loadingBatch = true;
		}
		else
		{
			//All done!
			successSignal.emit();
		}
	}
	
	private static function _disposeBatchLoaderSignals():Void
	{
		_loaderSignalSuccess.dispose();
		_loaderSignalError.dispose();
		_loaderSignalProgress.dispose();
	}
}