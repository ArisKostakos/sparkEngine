/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2014
 */

package tools.spark.framework;
import tools.spark.framework.assets.Module;
import tools.spark.framework.assets.EModuleState;
import tools.spark.sliced.core.Sliced;

/**
 * ...
 * @author Aris Kostakos
 */
class ModuleManager
{
	private static var _moduleStates:Map<String,EModuleState>;
	private static var _modulesLoadQueue:Array<String>;
	private static var _modulesLoadQueueBytes:Array<Int>;
	private static var _loadingBatch:Bool;
	
	public static function init():Void
	{
		_moduleStates = new Map<String,EModuleState>();
		_modulesLoadQueue = new Array<String>();
		_modulesLoadQueueBytes = new Array<Int>();
		_loadingBatch = false;
		
		Assets.successSignal.connect(_onLoaderSuccess);
		Assets.errorSignal.connect(_onLoaderError);
		Assets.progressSignal.connect(_onLoaderProgress);
	}
	
	private static function _onLoaderSuccess():Void
	{
		if (_loadingBatch == false)
		{
			//Got signal but it wasn't initiated from Module Manager. Ignoring (this solution sucks, see warning at the end)
			return;
		}
		
		//Loader not busy anymore
		_loadingBatch = false;
		
		//Get loaded module
		var l_moduleName:String = _modulesLoadQueue[0];
		
		Console.log("Module Loader: SUCCESS LOADING: " + l_moduleName);
		
		//Mark it as loaded
		_moduleStates[l_moduleName] = LOADED;
		
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
		trace("Module Loader: ERROR: " + p_error);
		//errorSignal.emit(p_error);
	}
	
	private static function _onLoaderProgress(p_progress:Float, p_total:Float):Void
	{
		//trace("Module Loader: Progress: Loaded " + p_progress + " Bytes out of " + p_total + " total Bytes...");
		//progressSignal.emit(p_progress, p_total);
	}
	
	public static function execute(p_moduleName:String):Void
	{
		if (isModuleLoaded(p_moduleName)) _executeModule(p_moduleName);
		else
		{
			_loadModule(p_moduleName);
		}
	}
	
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
	
	private static function _executeModule(p_moduleName:String):Void
	{
		if (isModuleExecuted(p_moduleName))
		{
			Console.warn("Error while trying to execute Module [" + p_moduleName + "]. Module already executed. Ignoring..");
			return;
		}
		else
		{
			if (isModuleExecutable(p_moduleName))
			{
				Sliced.logic.createAndRun(Project.modules[p_moduleName].executeEntity);
				_moduleStates[p_moduleName] = RUNNING;
			}
			else
			{
				Console.warn("Warning while trying to execute Module [" + p_moduleName + "]. Module is not executable. Ignoring..");
				return;
			}
		}
	}
	
	public static function isModuleExecutable(p_moduleName:String):Bool
	{
		if (Project.modules[p_moduleName].executeEntity == "none")
			return false;
		else
			return true;
	}
	
	private static function _loadModule(p_moduleName:String):Void
	{
		Console.log("LOADING MODULE: " + p_moduleName);
		if (getModuleState(p_moduleName) == NOT_LOADED)
		{
			//@todo Watch for Recursion for two modules both requiring one another!
			for (f_requiredModuleName in Project.modules[p_moduleName].requiresModules)
			{
				Console.log("LOADING MODULE REQUIREMENT: " + f_requiredModuleName);
				if (getModuleState(f_requiredModuleName) == NOT_LOADED)
					_loadModule(f_requiredModuleName);
			}
			
			_loadAssetsOfModule(p_moduleName);
		}
	}
	
	//@donow: two things plz. insert bytes to Assets, and the Asset loaded, so we can check here if asset already loaded.
	private static function _loadAssetsOfModule(p_moduleName:String):Void
	{
		var l_bytes:Int = 0;
		
		for (asset in Project.modules[p_moduleName].assets)
			l_bytes += Std.parseInt(asset.bytes);
		
		_moduleStates[p_moduleName] = LOADING;
		_modulesLoadQueue.push(p_moduleName);
		_modulesLoadQueueBytes.push(l_bytes);
		
		if (_loadingBatch==false) _startLoadBatch();
	}
	
	//@warning: If the user uses the Asset Service himself manually, it will interfere with the signals sent here
	//and fuck everything up! figure it out!
	private static function _startLoadBatch():Void
	{
		//do a check here if _loadingBatch is false? don't have to currently due to logic, but maybe just 
		//do be safe? performance vs safety, hmmmm
		
		
		if (_modulesLoadQueue.length > 0)
		{
			var l_moduleName:String = _modulesLoadQueue[0];
			
			Assets.initiateBatch();
			
			for (asset in Project.modules[l_moduleName].assets)
			{
				Console.log("adding file: " + asset.id);
				Assets.addFile(Project.getPath(asset.location,asset.type)+asset.url, asset.id, asset.forceLoadAsData == "true");
			}
			Assets.loadBatch();
			
			_loadingBatch = true;
		}
	}
}