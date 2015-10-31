/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.core;

import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.interfaces.ILogic;
import tools.spark.sliced.core.AService;
import tools.spark.sliced.services.std.logic.gde.core.GameFactory;
import tools.spark.sliced.services.std.logic.gde.interfaces.EventType;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameFactory;
import tools.spark.sliced.services.std.logic.interpreter.core.GmlInterpreter;
import tools.spark.sliced.services.std.logic.interpreter.core.HaxeInterpreter;
import tools.spark.sliced.services.std.logic.interpreter.interfaces.IInterpreter;

/**
 * ...
 * @author Aris Kostakos
 */
class Logic extends AService implements ILogic
{
	public var rootGameEntitiesRunning( default, null ):Map<String, IGameEntity>;
	public var rootGameEntitiesPaused( default, null ):Map<String, IGameEntity>;
	
	public var scriptInterpreter( default, null ):IInterpreter;
	public var gmlInterpreter( default, null ):IInterpreter;
	public var gameFactory( default, null ):IGameFactory;
	private var _gameEntitiesByName:Map<String, Array<IGameEntity>>;
	
	public function new() 
	{
		super();
		
		_init();
	}
	
	public function _init():Void
	{
		Console.log("Init Logic std Service...");
		
		//Init event types (before we create the factory, which needs the eventTypes set)
		EventType.init();
		
		//Create GameFactory
		gameFactory = new GameFactory();
		
		//Create Maps
		rootGameEntitiesRunning = new Map<String, IGameEntity>();
		rootGameEntitiesPaused = new Map<String, IGameEntity>();
		_gameEntitiesByName = new Map<String, Array<IGameEntity>>();
	}
	
	//This is taken out from _init because we need to create the Interpreters after Sliced is fully built, to feed the services as parameters for the interpreters
	public function createInterpreters():Void
	{
		//Create Script Interpreter
		scriptInterpreter = new HaxeInterpreter();
		
		//Create Gml Interpreter
		gmlInterpreter = new GmlInterpreter();
	}
	
	public function update():Void
	{
		//@warning: Game Entities may NOT run in order!!! If that's the case, use an Array, and 
		//will have to traverse the Array if you need to pick up an entity by a url reference
		//now that i think about it, maybe array would be better, to allow for multiple instances of the
		//same gameEntity to run (i forbid module run concurrency, but not game entity run concurrency..)
		//think about itttttttt! but then how do i say, pause this one, etc..?hmm
		for (gameEntity in rootGameEntitiesRunning)
			gameEntity.doActions();
	}
	
	public function startAction(entity:IGameEntity, actionId:String):Bool
	{
		return entity.startAction(actionId);
	}
	
	public function createAndRun(p_gameEntityUrl:String):Void
	{
		//Create GameEntity
		rootGameEntitiesRunning[p_gameEntityUrl] = gameFactory.createGameEntity(p_gameEntityUrl);
		Console.warn("Logic Service: Create and Running entity: " + p_gameEntityUrl);
	}
	
	public function createAndPause(p_gameEntityUrl:String):Void
	{
		//Create GameEntity
		rootGameEntitiesPaused[p_gameEntityUrl] = gameFactory.createGameEntity(p_gameEntityUrl);
	}
	
	public function getAllEntitiesByName(p_stateName:String):Array<IGameEntity>
	{
		return _gameEntitiesByName.get(p_stateName);
	}
	
	public function getEntityByName(p_stateName:String):IGameEntity
	{
		if (_gameEntitiesByName.exists(p_stateName))
			return _gameEntitiesByName.get(p_stateName)[ _gameEntitiesByName.get(p_stateName).length-1];
		else
			return null;
	}
	
	public function queryGameEntity(p_gameEntity:IGameEntity, p_query:String, ?queryArgument:Dynamic, p_bAllRenderers:Bool = false, p_bAllInstances:Bool = false):Dynamic //result query for false,false, hash otherwise
	{
		if (p_bAllRenderers == false && p_bAllInstances == false)
		{
			var l_realObject:Dynamic = Sliced.display.getSpace2_5Object(p_gameEntity);
			
			if (l_realObject != null)
			{
				return l_realObject.query(p_query, queryArgument); //right now only AInstantiable have a query function. Implement for the rest (AView,etc)
			}
			else
				return null;
		}
		else
		{
			//Not yet implemented
			return null;
		}
	}
	
	public function registerEntityByName(p_entity:IGameEntity):Void
	{
		if (p_entity.getState('name') != null)
		{
			var l_entityName:String = p_entity.getState('name');
			
			if (_gameEntitiesByName.exists(l_entityName) == false)
				_gameEntitiesByName.set(l_entityName, new Array<IGameEntity>());
			
			_gameEntitiesByName.get(l_entityName).push(p_entity);
		}
	}
	
	//Helper Functions
	public function replace(p_source:String, p_regex:String, p_regexParameters:String, p_replaceWith:String):String
	{
		var l_regEx:EReg = new EReg(p_regex, p_regexParameters);
		return l_regEx.replace(p_source, p_replaceWith);
	}
	
	public function getDt():Float
	{
		return Sliced.dt;
	}
	
	public function reflectField(p_object: Dynamic, p_field:String):Dynamic
	{
		return Reflect.getProperty(p_object, p_field);
	}
	
	public function reflectFieldOfField(p_object: Dynamic, p_field:String, p_field2:String):Dynamic
	{
		return Reflect.getProperty(Reflect.getProperty(p_object, p_field), p_field2); 
	}
	
	//Intepreter's toString() doesn't work well for Xml objects on Release mode.
	public function xmlToString(p_object:Xml):String
	{
		return p_object.toString();
	}
}