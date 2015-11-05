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
	
	//Xml functions
	public function xml_createDocument():Xml
	{
		return Xml.createDocument();
	}
	
	public function xml_clone(p_xml:Xml):Xml
	{
		return Xml.parse(xmlToString(p_xml)).firstElement();
	}
	
	public function xml_createElements(p_xmlNodes:Array<String>):Dynamic
	{
		var l_Return:Dynamic = { };
		
		l_Return.first = null;
		l_Return.last = null;
		
		for (xmlNodeStr in p_xmlNodes)
		{
			var f_xml:Xml = Xml.createElement(xmlNodeStr);
			
			if (l_Return.first==null)
				l_Return.first = f_xml;
			else
				l_Return.last.addChild(f_xml);
			
			l_Return.last = f_xml;
		}
		
		return l_Return;
	}
	
	public function xml_createElement(p_xmlNode:String):Xml
	{
		return Xml.createElement(p_xmlNode);
	}
	
	public function xml_createElementAttr(p_xmlNode:String, p_attrName:String, p_attrValue:String):Xml
	{
		var l_xml:Xml = Xml.createElement(p_xmlNode);
		
		l_xml.set(p_attrName, p_attrValue);
		
		return l_xml;
	}
	
	public function xml_entity_addMState(p_EntityXml:Xml, p_State:Dynamic, p_merge:Bool):Xml
	{
		var l_groupName:String;
		if (p_merge) l_groupName = "_States";
			else l_groupName = "States";
		
		//Check if group exists, else create it
		var l_group:Xml;
		var l_elements:Iterator<Xml> = p_EntityXml.elementsNamed(l_groupName);
		
		if (l_elements.hasNext())
			l_group = l_elements.next();
		else
		{
			l_group = Xml.createElement(l_groupName);
			p_EntityXml.addChild(l_group);
		}
		
		//Create it and add it
		var l_state:Xml = Xml.createElement("_State");
		l_group.addChild(l_state);
		
		//Check for stuff
		if (p_State.id != null)
		{
			l_state.set("id", p_State.id);
		}
		
		if (p_State.value != null)
		{
			var l_xml:Xml = Xml.createElement("Value");
			l_state.addChild(l_xml);
			
			l_xml.addChild(Xml.createPCData(p_State.value));
		}
		
		return l_state;
	}
	
	public function xml_entity_addTrigger(p_EntityXml:Xml, p_Trigger:Dynamic, p_merge:Bool):Xml
	{
		var l_groupName:String;
		if (p_merge) l_groupName = "_Triggers";
			else l_groupName = "Triggers";
		
		//Check if group exists, else create it
		var l_group:Xml;
		var l_elements:Iterator<Xml> = p_EntityXml.elementsNamed(l_groupName);
		
		if (l_elements.hasNext())
			l_group = l_elements.next();
		else
		{
			l_group = Xml.createElement(l_groupName);
			p_EntityXml.addChild(l_group);
		}
		
		//Create it and add it
		var l_trigger:Xml = Xml.createElement("Trigger");
		l_group.addChild(l_trigger);
		
		//Check for stuff
		if (p_Trigger.ext != null)
		{
			l_trigger.set("extends", p_Trigger.ext);
		}
		
		if (p_Trigger.event != null)
		{
			var l_xml:Xml = Xml.createElement("Event");
			l_trigger.addChild(l_xml);
			
			l_xml.addChild(Xml.createPCData(p_Trigger.event));
		}
		
		if (p_Trigger.target != null)
		{
			var l_xml:Xml = Xml.createElement("Target");
			l_trigger.addChild(l_xml);
			
			l_xml.addChild(Xml.createPCData(p_Trigger.target));
		}
		
		if (p_Trigger.parameter != null)
		{
			var l_xml:Xml = Xml.createElement("Parameter");
			l_trigger.addChild(l_xml);
			
			l_xml.addChild(Xml.createPCData(p_Trigger.parameter));
		}
		
		return l_trigger;
	}
}