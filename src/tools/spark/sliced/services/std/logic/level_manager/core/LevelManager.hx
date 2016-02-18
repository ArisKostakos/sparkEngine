/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, February 2016
 */

package tools.spark.sliced.services.std.logic.level_manager.core;
import tools.spark.framework.ModuleManager;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.core.Sliced;

/**
 * ...
 * @author Aris Kostakos
 */
@:keep class LevelManager// implements IGameFactory
{
	public var levelEntities( default, null ):Map<String, IGameEntity>; //store by name/by url/both?
	public var currentLevel( default, null ):IGameEntity;
	
	public function new() 
	{
		Console.log("Creating Level Manager");
		
		_init();
	}
	
	private function _init():Void
	{
		levelEntities = new Map<String, IGameEntity>();
	}
	
	public function addLevel(?p_levelEntity:IGameEntity, ?p_levelUrlName:String):Void
	{
		Console.error("addLevel...");
	}
	
	public function loadLevel(?p_levelEntity:IGameEntity, ?p_levelUrlName:String):Void
	{
		Console.error("loadLevel...");
	}
	
	public function runLevel(p_levelEntity:Dynamic):Void
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
		currentLevel = l_level;
		
		
		
		//Load all modules (for now assume always exactly 1 module exists)
		ModuleManager.successSignal.connect(_onLevelLoaded).once();
		ModuleManager.execute(moduleReferences[0].getState('url'));
	}
	
	//So remember.. this class is a singleton.. and only one level is loaded at any time.. and all that..
	//I say this since this signal will only work if we only load one module at a time.. and all that
	//if something else calls modulemanager other than this levelLoader at the same time, everything is royaly screwed
	private function _onLevelLoaded()
	{
		Console.warn("LEVEL LOADED!! yaayyyyee");
		
		//Add View to Stage
		var viewReferences:Array<IGameEntity> = currentLevel.getState('viewReferences');
		
		var testView:IGameEntity = Sliced.logic.create(viewReferences[0].getState('url'));
		Console.warn("View Created: " + testView.getState('name'));
		
		var testScene:IGameEntity = Sliced.logic.create(testView.getState('initSceneName'));
		Console.warn("Scene Created: " + testScene.getState('name'));
		
		var testCamera:IGameEntity = Sliced.logic.create(testView.getState('initCameraName'));
		Console.warn("Camera Created: " + testCamera.getState('name'));
		
		testView.setState('scene', testScene);
		testView.setState('camera', testCamera);
		
		Sliced.display.projectActiveSpaceReference.spaceEntity.addChild(testScene);
		Sliced.display.projectActiveSpaceReference.spaceEntity.addChild(testCamera);
		Sliced.display.projectActiveSpaceReference.activeStageReference.stageEntity.addChild(testView);
		
		//Remove Loading Screen
		//System.external.call("hidePreloader");
	}
}
