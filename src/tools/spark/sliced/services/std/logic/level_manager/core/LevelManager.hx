/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, February 2016
 */

package tools.spark.sliced.services.std.logic.level_manager.core;
import tools.spark.framework.Assets;
import tools.spark.framework.assets.interfaces.IBatchLoader;
import tools.spark.framework.ModuleManager;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.core.Sliced;
import flambe.System;
import tools.spark.sliced.services.std.logic.level_manager.interfaces.EActionAfterLoad;
import flambe.util.SignalConnection;
import flambe.util.Signal0;

/**
 * ...
 * @author Aris Kostakos
 */
@:keep class LevelManager
{
	//So, here's the deal.. we only have 1 LevelManager and 1 ModuleManager
	//LevelManager has slots. Games will most likely use only slot 1. Editor will most likely use 2 slots
	//ModuleManager, we WANT this to be common. So in the editor, the game takes advantage of modules loaded from the editor, etc.
	//Finally, even if we have slots now, only ONE LEVEL CAN BE LOADED AT ANY TIME.. Otherwise, things will get screwed up
	//NEXT: Do slots, then do Spark Editor with levels, then do BlankTemplate, then Enjoy the new editor with new possibilities
	//QUESTION: Now that we have slots, do we need GlobalSpace?
	//ANSWER: YES WE DO! Globals can have things SHARED between levels on same slot.and globals are not MEANT to be displayed at all on their own
	//MAIN EVENT SHEETS MAY run on a global level that is running on a different slot
	//BUT we still need globalSpace for "COMMON" or "SHARED" things between levels
	//For using the same object, i just move the game entity from memory to new level
	//for recreating same object, i use 'common' 'shared' thing. SO, maybe I should deprecate CommonSpace. Common module still fine, CommonSpace isn't fine.
	//for something that always exists, i use the global level thing
	//how's that?
	//also, I think common is now.. ULTRA TRANS-LEVEL/TRANS-RUNSLOT common..
	//So, in BlankTemplate, should I move MainEventSheets to Global level, instead of shared-level. hhmmmhmmhmhmhmhhmhmmhmmmmmmmmmmm
	//leaving it there for now.. but THINK ABOUT IT..
	//the result is, we need both slots and global level(slots).. so... good..
	//start editor
	
	
	//public var levelEntities( default, null ):Map<String, IGameEntity>; //store by name/by url/both? //WTF is this? levelEntites(references) are stored in Level.egc...
	public var currentLevel( default, null ):Map<String, IGameEntity>; //SLOTS!
	
	//helper vars to pass arguments through the load function callback. ALWAYS set them, when loading a level
	private var _actionAfterLoad:EActionAfterLoad; //always set this one when calling _loadLevel
	private var _levelRunSlot:String;  //always set this one when calling _loadLevel
	private var _levelLoading:IGameEntity; //set at _loadLevel
	private var _preLoaderActive:Bool;
	
	//Signals for ExternalCaller<-LevelManager
	public var levelLoaded:Signal0;
	public var levelCreated:Signal0;
	public var levelRan:Signal0;
	
	public function new() 
	{
		Console.info("Creating Level Manager");
		
		_init();
	}
	
	private function _init():Void
	{
		//levelEntities = new Map<String, IGameEntity>();
		currentLevel = new Map<String, IGameEntity>();
		_preLoaderActive = true;
		levelLoaded = new Signal0();
		levelCreated = new Signal0();
		levelRan = new Signal0();
	}
	
	public function addLevel(p_levelEntity:Dynamic):Void
	{
		Console.error("addLevel...");
	}
	
	public function loadLevel(p_levelEntity:Dynamic):Void
	{
		Console.error("loadLevel...");
	}
	
	public function runLevel(p_levelEntity:Dynamic, p_runSlot:String="Main"):Void
	{
		_actionAfterLoad = RUN;
		_levelRunSlot = p_runSlot;
		_loadLevel_start(p_levelEntity);
	}
	
	
	private function _loadLevel_start(p_levelEntity:Dynamic):Void
	{
		var l_level:IGameEntity;
		
		if (p_levelEntity != null)
		{
			//Figure out what p_levelEntity is
			//It can be either IGameEntity,String(name),String(url)
			
			//Level is already instantiated
			if (Reflect.hasField(p_levelEntity, 'getState')) //this is a little hacky :(
			{
				//Console.warn("Level is already instantiated");
				l_level = p_levelEntity;
			}
			//Level is already instantiated and given as name
			//todo: there might also be an option for the string to be in the form of lala/classname.egc so account for that too somewhere here
			//right now, if dot not found assumes its in the form of lala.classname
			//so look for slashes before looking for dots.. and that's it..
			else if (p_levelEntity.indexOf('.') == -1)
			{
				//Console.warn("Level is already instantiated and given as name");
				l_level = Sliced.logic.getEntityByName(p_levelEntity);
			}
			//Level is not created and given as url
			else
			{
				//Console.warn("Level is not created and given as url");
				
				//Get file path to determine if file is loaded
				var l_assetPathName:String = StringTools.replace(p_levelEntity,".","/") + ".egc";
				
				//Asset loaded. Create it
				if (Assets.assetLoaded(l_assetPathName))
					l_level = Sliced.logic.create(p_levelEntity);
				//Asset not even loaded. Load it, then create it..
				else
				{
					//Console.info("Level.egc not loaded.. Loading it now..");
					
					//All this... needs to go.. the whole adding a file at runtime code should go somewhere deeper... into a loader somewhere..
					//or at the very least, as a Logic.helper.. but i think to a loader is better
					
					//Initiate Load
					var loader = Assets.initiateBatch();
					
					//Load
					loader.start();
					
					var l_loader:IBatchLoader = Assets.initiateBatch();
					l_loader.addFile("assets/scripts/" + l_assetPathName, l_assetPathName);
					l_loader.successSignal.connect(function () {
						l_level = Sliced.logic.create(p_levelEntity);
						_loadLevel_end(l_level);
					}).once();
					
					l_loader.start();
					
					return; //careful of this return..
				}
			}
			//what about Level.egc not even been loaded? why not load it for me here..
		}
		else
		{
			Console.error("No parameters found for LevelManager.runLevel!");
			return;
		}
		
		_loadLevel_end(l_level);
	}
	
	private function _loadLevel_end(p_level:IGameEntity):Void
	{
		//Figure out References here
		var moduleReferences = [];
		var viewReferences = [];
		var eventSheetReferences = [];
		
		for (child in p_level.children)
		{
			if (child.getState('type') == 'Module')
				moduleReferences.push(child);
			else if (child.getState('type') == 'View')
				viewReferences.push(child);
			else if (child.getState('type') == 'EventSheet')
				eventSheetReferences.push(child);
		}
		
		//Store later, break this function to tiny private ones ofc..
		p_level.setState('moduleReferences', moduleReferences);
		p_level.setState('viewReferences', viewReferences);
		p_level.setState('eventSheetReferences', eventSheetReferences);
		
		
		//Load all modules (for now assume always exactly 1 module reference exists)
		_levelLoading = p_level;
		ModuleManager.successSignal.connect(_onLevelLoaded).once();
		ModuleManager.execute(moduleReferences[0].getState('url'));
	}
	
	//So remember.. this class is a singleton.. and only one level is loaded at any time.. and all that..
	//I say this since this signal will only work if we only load one module at a time.. and all that
	//if something else calls modulemanager other than this levelLoader at the same time, everything is royaly screwed
	private function _onLevelLoaded()
	{
		//Console.warn("LEVEL LOADED!! yaayyyyee");
		
		//Send the good news
		levelLoaded.emit();
		
		if (_actionAfterLoad==CREATE)
			_createLevel(_levelLoading);
		else if (_actionAfterLoad == RUN)
			_runLevel(_levelLoading, _levelRunSlot);
	}
	
	private function _createLevel(p_level:IGameEntity):Void
	{
		if (p_level.getState('created') == false)
		{
			//Create Level's eventSheet references (right now, it always assumes 0 or 1 eventSheet reference)
			var eventSheetReferences:Array<IGameEntity> = p_level.getState('eventSheetReferences');
			if (eventSheetReferences.length > 0)
			{
				var testEventSheet:IGameEntity = Sliced.logic.create(eventSheetReferences[0].getState('url'));
				p_level.addChild(testEventSheet);
			}
			
			//Create Level's view references (right now, it always assumes exactly 1 view reference)
			var viewReferences:Array<IGameEntity> = p_level.getState('viewReferences');
			var l_views:Array<IGameEntity> = [];
			
			var testView:IGameEntity = Sliced.logic.create(viewReferences[0].getState('url'));
			l_views.push(testView);
			//Console.warn("View Created: " + testView.getState('name'));
			
			var testScene:IGameEntity = Sliced.logic.create(testView.getState('initSceneName'));
			//Console.warn("Scene Created: " + testScene.getState('name'));
			
			var testCamera:IGameEntity = Sliced.logic.create(testView.getState('initCameraName'));
			//Console.warn("Camera Created: " + testCamera.getState('name'));
			
			//Set it up so it's ready to be used
			testView.setState('scene', testScene);
			testView.setState('camera', testCamera);
			
			//Add Scene and Camera to this level
			p_level.addChild(testScene);
			p_level.addChild(testCamera);
			
			p_level.setState('created', true);
			p_level.setState('views', l_views);
			
			//Send the good news
			levelCreated.emit();
		}
		else
		{
			Console.warn("Level already created. Ignoring...");
		}
	}
	
	private function _runLevel(p_level:IGameEntity, p_runSlot:String):Void
	{
		if (p_level.getState('created') == false)
			_createLevel(p_level);
		
		if (p_level != currentLevel[p_runSlot])
		{
			//Unload Current Level (if any)
			if (currentLevel[p_runSlot] != null)
			{
				//Just remove from stage, or completely unload? for now, just remove from stage..
				_removeLevel(currentLevel[p_runSlot]);
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
			Sliced.display.projectActiveSpaceReference.spaceEntity.addChild(p_level);
			Sliced.display.projectActiveSpaceReference.activeStageReference.stageEntity.addChild(l_views[0]);
			
			currentLevel[p_runSlot] = p_level;
			
			//Send the good news
			levelRan.emit();
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
		p_level.remove();
		l_views[0].remove();
	}
}
