/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, February 2016
 */

package tools.spark.sliced.services.std.logic.level_manager.core;
import flambe.util.Signal1;
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
	private var _levelParentStage:String;  //always set this one when calling _runLevel (can also be set before that, like before _loadlevel...)
	private var _levelLoading:IGameEntity; //set at _loadLevel
	private var _preLoaderActive:Bool;
	
	//Signals for ExternalCaller<-LevelManager
	public var levelLoaded:Signal1<Dynamic>;
	public var levelCreated:Signal0;
	public var levelRan:Signal0;
	
	public function new() 
	{
		Console.log("Creating Level Manager");
		
		_init();
	}
	
	private function _init():Void
	{
		//levelEntities = new Map<String, IGameEntity>();
		currentLevel = new Map<String, IGameEntity>();
		_preLoaderActive = true;
		levelLoaded = new Signal1<Dynamic>();
		levelCreated = new Signal0();
		levelRan = new Signal0();
	}
	
	public function addLevel(p_levelEntity:Dynamic):Void
	{
		Console.error("addLevel...");
	}
	
	public function loadLevel(p_levelEntity:Dynamic):Void
	{
		_actionAfterLoad = DO_NOTHING;
		_loadLevel(p_levelEntity);
	}
	
	public function runLevel(p_levelEntity:Dynamic, p_runSlot:String="Main", p_parentStage:String="Implicit"):Void
	{
		_actionAfterLoad = RUN;
		_levelRunSlot = p_runSlot;
		_levelParentStage = p_parentStage;
		_loadLevel(p_levelEntity);
	}
	/*
	public function restartCurrentLevel(p_runSlot:String="Main", p_parentStage:String="Implicit"):Void
	{
		_levelRunSlot = p_runSlot;
		_levelParentStage = p_parentStage;
		
		if (currentLevel[p_runSlot] != null)
		{
			//Just remove from stage, or completely unload? for now, just remove from stage..
			_removeLevel(currentLevel[p_runSlot]);
			
			//clear the runSlot flag
			currentLevel.remove(p_runSlot);
			
			
		}
	}
	*/
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
				//var l_assetPathName:String = StringTools.replace(p_levelEntity,".","/") + ".egc";
				
				//Asset loaded. Create it
				if (Assets.scriptLoaded(p_levelEntity))
					l_level = Sliced.logic.create(p_levelEntity);
				//Asset not even loaded. Load it, then create it..
				else
				{
					//Console.log("Level.egc not loaded.. Loading it now..");
					Console.error("Level Manager->Level " + p_levelEntity + " has not been loaded, and dynamic loaded has been deprecated! Quitting...");
					return;
					
					
					/*
					//All this... needs to go.. the whole adding a file at runtime code should go somewhere deeper... into a loader somewhere..
					//or at the very least, as a Logic.helper.. but i think to a loader is better
					
					//Initiate Load
					var loader = Assets.initiateBatch();
					
					//Load
					loader.start();
					
					var l_loader:IBatchLoader = Assets.initiateBatch();
					l_loader.addFile("assets/scripts/" + l_assetPathName, l_assetPathName); //this sucks
					l_loader.successSignal.connect(function () {
						l_level = Sliced.logic.create(p_levelEntity);
						_loadLevel_end(l_level);
					}).once();
					
					l_loader.start();
					
					return; //careful of this return..
					*/
				}
			}
		}
		else
		{
			Console.error("No parameters found for LevelManager.runLevel!");
			return;
		}
		
		//Level Entity Created, Find it's references
		l_level.forceAction("Find References");
		
		//Get the Module References (to load the firt one)
		var moduleReferences = l_level.getState('moduleReferences');
		
		if (moduleReferences != null)
		{
			//Load all modules (for now assume always exactly 1 module reference exists)
			_levelLoading = l_level;
			ModuleManager.successSignal.connect(_onLevelLoaded).once();
			ModuleManager.execute(moduleReferences[0].getState('url'));
		}
		else
		{
			Console.error("No Modules Found for level");
		}
	}
	
	
	//So remember.. this class is a singleton.. and only one level is loaded at any time.. and all that..
	//I say this since this signal will only work if we only load one module at a time.. and all that
	//if something else calls modulemanager other than this levelLoader at the same time, everything is royaly screwed
	private function _onLevelLoaded()
	{
		Console.log("LEVEL LOADED!");
		
		//Send the good news
		levelLoaded.emit(_levelLoading);
		
		if (_actionAfterLoad==CREATE)
			_createLevel(_levelLoading);
		else if (_actionAfterLoad == RUN)
			_runLevel(_levelLoading, _levelRunSlot);
	}
	
	private function _createLevel(p_level:IGameEntity):Void
	{
		if (p_level.getState('created') == false)
		{
			//Create Level's camera references
			var l_cameraReferences:Array<IGameEntity> = p_level.getState('cameraReferences');
			var l_levelCamera:IGameEntity=null;
			
			for (f_cameraReference in l_cameraReferences) //we assume 0 or 1, not more. later use level reference's refName to distinguish cameras, and which to use for each view
			{
				l_levelCamera = Sliced.logic.create(f_cameraReference.getState('url')); //, true);? probably (noCache)
				p_level.addChild(l_levelCamera);
			}
			
			//Array used for views and stageAreas
			var l_views:Array<IGameEntity> = [];
			
			//Array used for levelCameras and viewCameras
			var l_cameras:Array<IGameEntity> = [];
			
			if (l_levelCamera != null)
				l_cameras.push(l_levelCamera);
			
			//Create Level's stageArea references
			var l_stageAreaReferences:Array<IGameEntity> = p_level.getState('stageAreaReferences');
			for (f_stageAreaReference in l_stageAreaReferences)
			{
				var f_stageArea:IGameEntity = Sliced.logic.create(f_stageAreaReference.getState('url')); //, true);? probably (noCache)
				
				//Store this stageArea
				l_views.push(f_stageArea);
			}
			
			//Create Level's view references
			var l_viewReferences:Array<IGameEntity> = p_level.getState('viewReferences');
			for (f_viewReference in l_viewReferences)
			{
				var f_view:IGameEntity = Sliced.logic.create(f_viewReference.getState('url')); //, true);? probably (noCache)
				//Console.warn("View Created: " + testView.getState('name'));
				
				//Store this view
				l_views.push(f_view);
				
				var f_scene:IGameEntity = Sliced.logic.create(f_view.getState('initSceneUrl'), true); //noCache==true
				f_scene.setState('parentLevel', p_level);
				//Console.warn("Scene Created: " + f_scene.getState('name'));
				
				var f_camera:IGameEntity = null;
				if (f_view.getState('initCameraUrl') != "Level Camera")
				{
					f_camera = Sliced.logic.create(f_view.getState('initCameraUrl')); //, true);? probably (noCache)
					l_cameras.push(f_camera);
				}
				//Console.warn("Camera Created: " + testCamera.getState('name'));
				
				//Set it up so it's ready to be used
				f_view.setState('scene', f_scene);
				
				if (f_camera!=null)
					f_view.setState('camera', f_camera);
				else
					f_view.setState('camera', l_levelCamera);
				
				//Add Scene and Camera to this level
				p_level.addChild(f_scene);
				
				if (f_camera!=null)
					p_level.addChild(f_camera);
			}
			
			
			p_level.setState('created', true);
			p_level.setState('views', l_views);
			p_level.setState('cameras', l_cameras);
			
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
				
				//clear the runSlot flag
				currentLevel.remove(p_runSlot);
			}
			
			//If Preloader was active, remove it..
			if (_preLoaderActive)
			{
				System.external.call("hidePreloader");
				_preLoaderActive = false;
			}
			
			//Add Level's views
			var l_views:Array<IGameEntity> = p_level.getState('views');
			
			//Adding things to active Space/Stage
			Sliced.display.projectActiveSpaceReference.spaceEntity.addChild(p_level);
			
			for (f_view in l_views)
			{
				f_view.setState('parent', _levelParentStage); //The explicit rule to set views of a level to a specific parent(e.g. a StageArea)
				Sliced.display.projectActiveSpaceReference.activeStageReference.stageEntity.addChild(f_view);
			}
			
			currentLevel[p_runSlot] = p_level;
			
			//Send the good news
			levelRan.emit();
		}
		else
		{
			Console.warn("Level already running. Ignoring...");
		}
	}
	
	
	@:keep public function clearRunSlot(p_runSlot:String="Main"):Void //meh
	{
		//Current Level (if any)
		if (currentLevel[p_runSlot] != null)
		{
			currentLevel.remove(p_runSlot);
		}
	}
	
	@:keep public function addRunSlotToStage(p_runSlot:String="Main"):Void //meh
	{
		//add Current Level (if any)
		if (currentLevel[p_runSlot] != null)
		{
			//Just add to stage
			_addLevel(currentLevel[p_runSlot]);
		}
	}
	
	@:keep public function removeRunSlotFromStage(p_runSlot:String="Main"):Void //meh
	{
		//remove Current Level (if any)
		if (currentLevel[p_runSlot] != null)
		{
			//Just remove from stage
			_removeLevel(currentLevel[p_runSlot]);
		}
	}
	
	//Only adds, doesn't create
	private function _addLevel(p_level:IGameEntity):Void
	{
		//Get Level's views
		var l_views:Array<IGameEntity> = p_level.getState('views');
		
		//Adding things to active Space/Stage
		Sliced.display.projectActiveSpaceReference.spaceEntity.addChild(p_level);
		
		for (f_view in l_views)
			Sliced.display.projectActiveSpaceReference.activeStageReference.stageEntity.addChild(f_view);
	}
	
	//Only removes, doesn't unload
	private function _removeLevel(p_level:IGameEntity):Void
	{
		//Get Level's views
		var l_views:Array<IGameEntity> = p_level.getState('views');
		
		//Remove things from active Space/Stage
		p_level.remove();
		
		for (f_view in l_views)
			f_view.remove();
	}
}
