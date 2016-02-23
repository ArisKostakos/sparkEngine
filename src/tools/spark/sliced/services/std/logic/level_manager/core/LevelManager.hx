/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, February 2016
 */

package tools.spark.sliced.services.std.logic.level_manager.core;
import tools.spark.framework.ModuleManager;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.core.Sliced;
import flambe.System;
import tools.spark.sliced.services.std.logic.level_manager.interfaces.EActionAfterLoad;

/**
 * ...
 * @author Aris Kostakos
 */
@:keep class LevelManager// implements IGameFactory
{
	public var levelEntities( default, null ):Map<String, IGameEntity>; //store by name/by url/both?
	public var currentLevel( default, null ):IGameEntity;
	
	//helper vars to pass arguments through the load function callback. ALWAYS set them, when loading a level
	private var _actionAfterLoad:EActionAfterLoad; //always set this one when calling _loadLevel
	private var _levelLoading:IGameEntity; //this is already always set at _loadLevel
	private var _preLoaderActive:Bool;
	
	public function new() 
	{
		Console.log("Creating Level Manager");
		
		_init();
	}
	
	private function _init():Void
	{
		levelEntities = new Map<String, IGameEntity>();
		_preLoaderActive = true;
	}
	
	public function addLevel(p_levelEntity:Dynamic):Void
	{
		Console.error("addLevel...");
	}
	
	public function loadLevel(p_levelEntity:Dynamic):Void
	{
		Console.error("loadLevel...");
	}
	
	public function runLevel(p_levelEntity:Dynamic):Void
	{
		_actionAfterLoad = RUN;
		_loadLevel(p_levelEntity);
	}
	
	
	private function _loadLevel(p_levelEntity:Dynamic):Void
	{
		var l_level:IGameEntity;
		
		if (p_levelEntity != null)
		{
			//Figure out what p_levelEntity is
			//It can be either IGameEntity,String(name),String(url)
			
			//Level is already instantiated
			if (Reflect.hasField(p_levelEntity, 'getState')) //this is a little hacky :(
			{
				Console.warn("Level is already instantiated");
				l_level = p_levelEntity;
			}
			//Level is already instantiated and given as name
			else if (p_levelEntity.indexOf('.') == -1)
			{
				Console.warn("Level is already instantiated and given as name");
				l_level = Sliced.logic.getEntityByName(p_levelEntity);
			}
			//Level is not created and given as url
			else
			{
				Console.warn("Level is not created and given as url");
				l_level = Sliced.logic.create(p_levelEntity);
			}
		}
		else
		{
			Console.error("No parameters found for LevelManager.runLevel!");
			return;
		}
		
		//Figure out References here
		var moduleReferences = [];
		var viewReferences = [];
		
		for (child in l_level.children)
		{
			if (child.getState('type') == 'Module')
				moduleReferences.push(child);
			else if (child.getState('type') == 'View')
				viewReferences.push(child);
		}
		
		//Store later, break this function to tiny private ones ofc..
		l_level.setState('moduleReferences', moduleReferences);
		l_level.setState('viewReferences', viewReferences);
		
		
		
		//Load all modules (for now assume always exactly 1 module reference exists)
		_levelLoading = l_level;
		ModuleManager.successSignal.connect(_onLevelLoaded).once();
		ModuleManager.execute(moduleReferences[0].getState('url'));
	}
	
	
	//So remember.. this class is a singleton.. and only one level is loaded at any time.. and all that..
	//I say this since this signal will only work if we only load one module at a time.. and all that
	//if something else calls modulemanager other than this levelLoader at the same time, everything is royaly screwed
	private function _onLevelLoaded()
	{
		Console.warn("LEVEL LOADED!! yaayyyyee");
		
		
		if (_actionAfterLoad==CREATE)
			_createLevel(_levelLoading);
		else if (_actionAfterLoad == RUN)
			_runLevel(_levelLoading);
	}
	
	private function _createLevel(p_level:IGameEntity):Void
	{
		if (p_level.getState('created') == false)
		{
			//Create Level's view references (right now, it always assumes exactly 1 view reference)
			var viewReferences:Array<IGameEntity> = p_level.getState('viewReferences');
			var l_views:Array<IGameEntity> = [];
			
			var testView:IGameEntity = Sliced.logic.create(viewReferences[0].getState('url'));
			l_views.push(testView);
			Console.warn("View Created: " + testView.getState('name'));
			
			var testScene:IGameEntity = Sliced.logic.create(testView.getState('initSceneName'));
			Console.warn("Scene Created: " + testScene.getState('name'));
			
			var testCamera:IGameEntity = Sliced.logic.create(testView.getState('initCameraName'));
			Console.warn("Camera Created: " + testCamera.getState('name'));
			
			//Set it up so it's ready to be used
			testView.setState('scene', testScene);
			testView.setState('camera', testCamera);
			
			p_level.setState('created', true);
			p_level.setState('views', l_views);
		}
		else
		{
			Console.warn("Level already created. Ignoring...");
		}
	}
	
	private function _runLevel(p_level:IGameEntity):Void
	{
		if (p_level.getState('created') == false)
			_createLevel(p_level);
		
		if (p_level != currentLevel)
		{
			//Unload Current Level (if any)
			if (currentLevel != null)
			{
				//Just remove from stage, or completely unload? for now, just remove from stage..
				_removeLevel(currentLevel);
			}
			
			//If Preloader was active, remove it..
			if (_preLoaderActive)
			{
				System.external.call("hidePreloader");
				_preLoaderActive = false;
			}
			
			//Add Level's views (right now, it always assumes exactly 1 views)
			var l_views:Array<IGameEntity> = p_level.getState('views');
			
			//Adding things to active Space/Stage
			Sliced.display.projectActiveSpaceReference.spaceEntity.addChild(l_views[0].getState('scene'));
			Sliced.display.projectActiveSpaceReference.spaceEntity.addChild(l_views[0].getState('camera'));
			Sliced.display.projectActiveSpaceReference.activeStageReference.stageEntity.addChild(l_views[0]);
			
			currentLevel = p_level;
		}
		else
		{
			Console.warn("Level already running. Ignoring...");
		}
	}
	
	//Only removes, doesn't unload
	private function _removeLevel(p_level:IGameEntity):Void
	{
		//Add Level's views (right now, it always assumes exactly 1 views)
		var l_views:Array<IGameEntity> = p_level.getState('views');
		
		//Remove things from active Space/Stage
		l_views[0].getState('scene').remove();
		l_views[0].getState('camera').remove();
		l_views[0].remove();
	}
}
