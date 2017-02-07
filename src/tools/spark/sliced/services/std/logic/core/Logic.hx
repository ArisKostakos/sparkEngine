/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.core;

import flambe.asset.File;
import flambe.subsystem.ExternalSystem;
import flambe.System;
import flambe.subsystem.StorageSystem;
import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.interfaces.ILogic;
import tools.spark.sliced.core.AService;
import tools.spark.sliced.services.std.logic.gde.core.GameFactory;
import tools.spark.sliced.services.std.logic.gde.interfaces.EventType;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameBase;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameFactory;
import tools.spark.sliced.services.std.logic.interpreter.core.GmlInterpreter;
import tools.spark.sliced.services.std.logic.interpreter.interfaces.IInterpreter;
import tools.spark.sliced.services.std.logic.level_manager.core.LevelManager;
import tools.spark.framework.Assets;

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
	public var levelManager( default, null ):LevelManager;
	public var pauseDt( default, default ):Float;
	public var storage( get, null ):StorageSystem;
	
	public var gameEntitiesByName( default, default ):Map<String, Array<IGameEntity>>;
	public var gameEntitiesByNameBackup( default, default ):Map<String, Array<IGameEntity>>;
	public var registerToBackupActive( default, default ):Bool;
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
		
		//Create LevelManager
		levelManager = new LevelManager();
		
		//Create Maps
		rootGameEntitiesRunning = new Map<String, IGameEntity>();
		rootGameEntitiesPaused = new Map<String, IGameEntity>();
		gameEntitiesByName = new Map<String, Array<IGameEntity>>();
		
		registerToBackupActive = false;
	}
	
	//This is taken out from _init because we need to create the Interpreters after Sliced is fully built, to feed the services as parameters for the interpreters
	public function createInterpreters():Void
	{
		//Create Script Interpreter
		#if html
			#if UseHaxeInterpreter
				scriptInterpreter = new tools.spark.sliced.services.std.logic.interpreter.core.HaxeInterpreter();
			#else
				scriptInterpreter = new tools.spark.sliced.services.std.logic.interpreter.core.platform.html.HaxeJsInterpreter();
			#end
		#else
			scriptInterpreter = new tools.spark.sliced.services.std.logic.interpreter.core.HaxeInterpreter();
		#end
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
		Console.log("Logic Service: Create and Running entity: " + p_gameEntityUrl);
		
		//Extremely temp place to put this..
		//Remove Loading Screen
		//System.external.call("hidePreloader"); //hideLoadingImage
	}
	
	public function createAndPause(p_gameEntityUrl:String):Void
	{
		//Create GameEntity
		rootGameEntitiesPaused[p_gameEntityUrl] = gameFactory.createGameEntity(p_gameEntityUrl);
	}
	
	public function create(p_gameEntityUrl:String, p_dontCache:Bool=false):IGameEntity
	{
		//Create GameEntity
		return gameFactory.createGameEntity(p_gameEntityUrl, p_dontCache);
	}
	
	public function createFromXml(p_xml:Xml, p_cloneFirst:Bool=true):IGameEntity
	{
		//Create GameEntity From Xml
		
		//To make this function NOT modify the p_xml passed as an arguement, I will clone the xml (gameFactory flattens the xmls it creates)
		
		//Best way to clone an xml (that i know of), is to reparse it:(
		if (p_cloneFirst)
		{
			var _clonedXml:Xml = xml_clone(p_xml);		
			return gameFactory.createGameEntity(_clonedXml);
		}
		else
			return gameFactory.createGameEntity(p_xml);
	}
	
	
	public function interpet(p_script:String, p_gameEntity:IGameEntity=null, p_gameBase:IGameBase=null):Dynamic
	{
		var l_parentEntity:IGameEntity = null;
		if (p_gameEntity != null)
			l_parentEntity = p_gameEntity.parentEntity;
			
		return scriptInterpreter.runExpr(scriptInterpreter.hashExpr(p_script), p_gameEntity, l_parentEntity, p_gameBase);
	}
	
	public function getAllEntitiesByName(p_stateName:String):Array<IGameEntity>
	{
		return gameEntitiesByName.get(p_stateName);
	}
	
	public function getEntityByName(p_stateName:String):IGameEntity
	{
		if (gameEntitiesByName.exists(p_stateName))
			return gameEntitiesByName.get(p_stateName)[ gameEntitiesByName.get(p_stateName).length-1];
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
			
			var l_gameEntitiesHash:Map<String, Array<IGameEntity>>;
			
			if (registerToBackupActive)
				l_gameEntitiesHash = gameEntitiesByNameBackup;
			else
				l_gameEntitiesHash = gameEntitiesByName;
			
			if (l_gameEntitiesHash.exists(l_entityName) == false)
				l_gameEntitiesHash.set(l_entityName, new Array<IGameEntity>());
			
			l_gameEntitiesHash.get(l_entityName).push(p_entity);
		}
	}
	
	public function deregisterEntityNameClass(p_entity:IGameEntity):Void
	{
		if (p_entity.getState('name') != null)
		{
			var l_entityName:String = p_entity.getState('name');
			
			var l_gameEntitiesHash:Map<String, Array<IGameEntity>>;
			
			if (registerToBackupActive)
				l_gameEntitiesHash = gameEntitiesByNameBackup;
			else
				l_gameEntitiesHash = gameEntitiesByName;
			
			if (l_gameEntitiesHash.exists(l_entityName))
				l_gameEntitiesHash.remove(l_entityName);
		}
	}
	
	
	//Getters
	private function get_storage():StorageSystem
	{
		return System.storage;
	}
	
	//Helper Functions
	public function getStorage():StorageSystem
	{
		return System.storage;
	}
	
	@:keep public function getExternal():ExternalSystem
	{
		return System.external;
	}
	
	
	public function random(p_from:Int, p_to:Int):Int
	{
		return p_from + Std.random(p_to - p_from + 1);
	}
	
	public function replace(p_source:String, p_regex:String, p_regexParameters:String, p_replaceWith:String):String
	{
		var l_regEx:EReg = new EReg(p_regex, p_regexParameters);
		return l_regEx.replace(p_source, p_replaceWith);
	}
	
	//Make this one Safe
	public function getTime():Float
	{
		return Math.min(Sliced.dt, 0.06);
	}
	
	//Do I use this one? Make it Raw
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
	
	public function copyObject(p_object:Dynamic):Dynamic
	{
		return Reflect.copy(p_object);
	}
	
	public function insertStr(a:String, b:String, position:Int):String
	{
		return a.substr(0, position) + b + a.substr(position);
	}
	
	public function lerp(start:Float, end:Float, percent:Float):Float
	{
		if (start == end)
		{
			return start;
		}
		return (end - start) * percent + start;
	}
	
	public function inverseLerp(start:Float, end:Float, middle:Float):Float
	{
		return (middle - start) / (end - start);
	}
	
	public function formatStr(p_par:Dynamic):String
	{
		var p_string:String = Std.string(p_par);
		//awefull..
		if (p_string.length>9) //billions
		{
			p_string = insertStr(p_string,",",p_string.length-9);
			p_string = insertStr(p_string,",",p_string.length-6);
			p_string = insertStr(p_string,",",p_string.length-3);
		}
		else if (p_string.length>6) //millions
		{
			p_string = insertStr(p_string,",",p_string.length-6);
			p_string = insertStr(p_string,",",p_string.length-3);
		}
		else if (p_string.length>3) //thousands
		{
			p_string = insertStr(p_string,",",p_string.length-3);
		}
		
		return p_string;
	}
	
	public function getDbaFlambeId(p_asset:Dynamic):String
	{
		return p_asset.type + ':' + p_asset.name;
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
	
	public function xml_from_file(p_file:File):Xml
	{
		return Xml.parse(p_file.toString()).firstElement();
	}
	
	public function xml_getElements(p_xml:Xml, p_xmlNodes:Array<String>):Dynamic
	{
		var l_xmlNode:Xml = p_xml;
		for (xmlNodeStr in p_xmlNodes)
		{
			l_xmlNode = xml_getElement(l_xmlNode, xmlNodeStr);
			if (l_xmlNode == null)
				return null;
		}
		
		return l_xmlNode;
	}
	
	public function xml_getAllStates(p_xml:Xml, p_merge:Bool):Map<String, Dynamic>
	{
		var l_states:Map<String, Dynamic> = new Map<String, Dynamic>();
		
		var l_groupName:String;
		if (p_merge) l_groupName = "_States";
			else l_groupName = "States";
			
		var l_statesNode:Xml = xml_getElement(p_xml, l_groupName);
		
		if (l_statesNode != null)
		{
			var l_statesChildren:Iterator<Xml> = l_statesNode.elementsNamed('State');
			//for each [entity] in [form.space.entities]
			while (l_statesChildren.hasNext())
			{
				var f_state:Xml = l_statesChildren.next();
				
				var f_id:String = xml_getElement(f_state, "Id").firstChild().nodeValue;
				var f_type:String = xml_getElement(f_state, "Type").firstChild().nodeValue;
				var f_value:String = xml_getElement(f_state, "Value").firstChild().nodeValue;
				
				l_states.set(f_id,{id: f_id, type: f_type, value: f_value, kind: "Normal", nick: f_state.get('nick'), objectSpecific: f_state.get('objectSpecific'), visible: f_state.get('visible'), onChange: f_state.get('onChange'), live: f_state.get('live'), control: f_state.get('control')});
			}
			return l_states;
		}
		else
		{
			return l_states;
		}
	}
	
	public function xml_getState(p_xml:Xml, p_stateId:String, p_merge:Bool):Dynamic
	{
		return xml_getAllStates(p_xml, p_merge).get(p_stateId);
	}
	
	public function xml_getAllMStates(p_xml:Xml, p_merge:Bool):Map<String, Dynamic>
	{
		var l_states:Map<String, Dynamic> = new Map<String, Dynamic>();
		
		var l_groupName:String;
		if (p_merge) l_groupName = "_States";
			else l_groupName = "States";
			
		var l_statesNode:Xml = xml_getElement(p_xml, l_groupName);
		
		if (l_statesNode != null)
		{
			var l_statesChildren:Iterator<Xml> = l_statesNode.elementsNamed('_State');
			//for each [entity] in [form.space.entities]
			while (l_statesChildren.hasNext())
			{
				var f_state:Xml = l_statesChildren.next();
				
				var f_id:String = f_state.get("id");
				var f_value:String = xml_getElement(f_state, "Value").firstChild().nodeValue;
				
				l_states.set(f_id,{id: f_id, value: f_value, kind: "Merge", nick: f_state.get('nick'), objectSpecific: f_state.get('objectSpecific'), visible: f_state.get('visible'), onChange: f_state.get('onChange'), live: f_state.get('live'), control: f_state.get('control')});
			}
			return l_states;
		}
		else
		{
			return l_states;
		}
	}
	
	public function xml_getMState(p_xml:Xml, p_mStateId:String, p_merge:Bool):Dynamic
	{
		return xml_getAllMStates(p_xml, p_merge).get(p_mStateId);
	}
	
	public function xml_getEveryState(p_xml:Xml, p_merge:Bool):Map<String, Dynamic>
	{
		var l_allStates:Map<String, Dynamic> = xml_getAllStates(p_xml, p_merge);
		var l_mStates:Map<String, Dynamic> = xml_getAllMStates(p_xml, p_merge);
		
		for (f_mState in l_mStates)
		{
			if (l_allStates.exists(f_mState.id))
				l_allStates.get(f_mState.id).value = f_mState.value; //update value (shouldn't really happen, like ever..)
			else
				l_allStates.set(f_mState.id, f_mState); //add to map
		}
		
		return l_allStates;
	}
	
	public function xml_getEveryState_Array(p_xml:Xml, p_merge:Bool):Array<Dynamic> //Never tried this..but it should work..
	{
		var l_states:Array<Dynamic> = new Array<Dynamic>();
		
		var l_groupName:String;
		if (p_merge) l_groupName = "_States";
			else l_groupName = "States";
			
		var l_statesNode:Xml = xml_getElement(p_xml, l_groupName);
		
		if (l_statesNode != null)
		{
			var l_statesChildren:Iterator<Xml> = l_statesNode.elementsNamed('State');
			//for each [entity] in [form.space.entities]
			while (l_statesChildren.hasNext())
			{
				var f_state:Xml = l_statesChildren.next();
				
				var f_id:String = xml_getElement(f_state, "Id").firstChild().nodeValue;
				var f_type:String = xml_getElement(f_state, "Type").firstChild().nodeValue;
				var f_value:String = xml_getElement(f_state, "Value").firstChild().nodeValue;
				
				l_states.push({id: f_id, type: f_type, value: f_value, kind: "Normal"});
			}
			
			var l_statesChildren:Iterator<Xml> = l_statesNode.elementsNamed('_State');
			//for each [entity] in [form.space.entities]
			while (l_statesChildren.hasNext())
			{
				var f_state:Xml = l_statesChildren.next();
				
				var f_id:String = f_state.get("id");
				var f_value:String = xml_getElement(f_state, "Value").firstChild().nodeValue;
				
				l_states.push({id: f_id, value: f_value, kind: "Merge"});
			}
			
			return l_states;
		}
		else
		{
			return l_states;
		}
	}
	
	//XML parsing functions
	public function xml_parseAsset(p_asset:Dynamic):Xml //deprecated?
	{
		return Xml.parse(Assets.getFile(p_asset.dir + '/' + p_asset.fileName + '.' + p_asset.fileExtension).toString()).firstElement();
	}
	
	public function xml_parseScript(p_script:File):Xml
	{
		return Xml.parse(p_script.toString()).firstElement();
	}
	
	public function xml_parseScriptName(p_scriptName:String):Xml
	{
		return xml_parseScript(Assets.getScript(p_scriptName));
	}
	
	public function xml_getElement(p_xml:Xml, p_xmlNode:String):Xml
	{
		var p_iterator:Iterator<Xml> = p_xml.elementsNamed(p_xmlNode);
		if (p_iterator.hasNext())
			return p_iterator.next();
		else
			return null;
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
	
	public function xml_createElement(p_xmlNode:String, ?p_pcdataChild:String):Xml
	{
		if (p_pcdataChild==null)
			return Xml.createElement(p_xmlNode);
		else
		{
			var l_xmlNode:Xml = Xml.createElement(p_xmlNode);
			l_xmlNode.addChild(Xml.createPCData(p_pcdataChild));
			return l_xmlNode;
		}
	}
	
	public function xml_createElementAttr(p_xmlNode:String, p_attrName:String, p_attrValue:String):Xml
	{
		var l_xml:Xml = Xml.createElement(p_xmlNode);
		
		l_xml.set(p_attrName, p_attrValue);
		
		return l_xml;
	}
	
	public function xml_entity_removeNode(p_EntityXml:Xml, p_xmlNodeName:String):Xml
	{
		//Check if node exists
		var l_elements:Iterator<Xml> = p_EntityXml.elementsNamed(p_xmlNodeName);
		
		if (l_elements.hasNext())
			p_EntityXml.removeChild(l_elements.next());
		
		return p_EntityXml;
	}
	
	public function xml_entity_removeAllNodes(p_EntityXml:Xml, p_xmlNodeName:String):Xml
	{
		//Check if node exists
		var l_elements:Iterator<Xml> = p_EntityXml.elementsNamed(p_xmlNodeName);
		
		while (l_elements.hasNext())
			p_EntityXml.removeChild(l_elements.next());
		
		return p_EntityXml;
	}
	
	public function xml_entity_addExtend(p_EntityXml:Xml, p_Entity:Dynamic):Xml
	{
		var l_groupName:String = "Extends";
		
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
		var l_entity:Xml = Xml.createElement("Entity");
		l_group.addChild(l_entity);
		
		//Check for stuff
		if (p_Entity.ext != null)
		{
			l_entity.set("extends", p_Entity.ext);
		}
		
		return l_entity;
	}
	
	public function xml_entity_getExtendsEntityNames(p_EntityXml:Xml):Array<String>
	{
		var l_array:Array<String> = new Array<String>();
		
		var l_groupName:String = "Extends";
		
		//Check if group exists
		var l_group:Xml = null;
		var l_elements:Iterator<Xml> = p_EntityXml.elementsNamed(l_groupName);
		
		if (l_elements.hasNext())
			l_group = l_elements.next();
		
		if (l_group != null)
		{
			var l_entities:Iterator<Xml> = l_group.elementsNamed("Entity");
			for (entity in l_entities)
			{
				l_array.push(entity.get("extends"));
			}
		}
		
		return l_array;
	}
	
	public function xml_entity_getExtendsEntities(p_EntityXml:Xml):Array<Dynamic>
	{
		var l_array:Array<Dynamic> = new Array<Dynamic>();
		
		var l_groupName:String = "Extends";
		
		//Check if group exists
		var l_group:Xml = null;
		var l_elements:Iterator<Xml> = p_EntityXml.elementsNamed(l_groupName);
		
		if (l_elements.hasNext())
			l_group = l_elements.next();
		
		if (l_group != null)
		{
			var l_entities:Iterator<Xml> = l_group.elementsNamed("Entity");
			for (entity in l_entities)
			{
				l_array.push({ext:entity.get("extends"), meta_editor:entity.get("meta_editor"), xml:entity});
			}
		}
		
		return l_array;
	}
	
	public function xml_entity_addFormState(p_EntityXml:Xml, p_State:Dynamic, p_mergeForm:Bool, p_mergeStates:Bool):Xml
	{
		var l_groupName:String;
		if (p_mergeForm) l_groupName = "_Form";
			else l_groupName = "Form";
		
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
		
		return xml_entity_addState(l_group, p_State, p_mergeStates);
	}
	
	public function xml_entity_updateFormState(p_EntityXml:Xml, p_State:Dynamic, p_mergeForm:Bool, p_mergeStates:Bool):Bool
	{
		var l_groupName:String;
		if (p_mergeForm) l_groupName = "_Form";
			else l_groupName = "Form";
		
		//Check if group exists, else quit
		var l_group:Xml;
		var l_elements:Iterator<Xml> = p_EntityXml.elementsNamed(l_groupName);
		
		if (l_elements.hasNext())
			l_group = l_elements.next();
		else
		{
			return false;
		}
		
		return xml_entity_updateState(l_group, p_State, p_mergeStates);
	}
	
	public function xml_entity_addState(p_EntityXml:Xml, p_State:Dynamic, p_merge:Bool):Xml
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
		var l_state:Xml = Xml.createElement("State");
		l_group.addChild(l_state);
		
		//Check for stuff
		if (p_State.id != null)
		{
			var l_xml:Xml = Xml.createElement("Id");
			l_state.addChild(l_xml);
			
			l_xml.addChild(Xml.createPCData(p_State.id));
		}
		
		if (p_State.type != null)
		{
			var l_xml:Xml = Xml.createElement("Type");
			l_state.addChild(l_xml);
			
			l_xml.addChild(Xml.createPCData(p_State.type));
		}
		
		if (p_State.value != null)
		{
			var l_xml:Xml = Xml.createElement("Value");
			l_state.addChild(l_xml);
			
			l_xml.addChild(Xml.createCData(p_State.value));
		}
		
		//Check for meta stuff
		if (p_State.visible != null)
			l_state.set("visible", p_State.visible);
			
		if (p_State.onChange != null)
			l_state.set("onChange", p_State.onChange);
			
		if (p_State.nick != null)
			l_state.set("nick", p_State.nick);
			
		if (p_State.objectSpecific != null)
			l_state.set("objectSpecific", p_State.objectSpecific);
			
		if (p_State.live != null)
			l_state.set("live", p_State.live);
			
		if (p_State.control != null)
			l_state.set("control", p_State.control);
			
		return l_state;
	}
	
	public function xml_entity_updateState(p_EntityXml:Xml, p_State:Dynamic, p_merge:Bool, p_forceCreate:Bool=false):Bool //for forceCreate to work here, p_State.type must be given
	{
		var l_groupName:String;
		if (p_merge) l_groupName = "_States";
			else l_groupName = "States";
		
		//Check if group exists, else quit
		var l_group:Xml;
		var l_elements:Iterator<Xml> = p_EntityXml.elementsNamed(l_groupName);
		
		if (l_elements.hasNext())
			l_group = l_elements.next();
		else
		{
			//Create it
			if (p_forceCreate)
			{
				xml_entity_addState(p_EntityXml, p_State, p_merge);
				return true;
			}
			else //Give up
				return false;
		}
		
		//Look for State
		for (stateNode in l_group.elements())
		{
			var f_id:String = xml_getElement(stateNode, "Id").firstChild().nodeValue;
			
			if (f_id == p_State.id)
			{
				var f_valueNode:Xml = xml_getElement(stateNode, "Value");
				f_valueNode.removeChild(f_valueNode.firstChild());
				f_valueNode.addChild(Xml.createCData(p_State.value));
				return true;
			}
			
		}
		
		//Didn't found it
		
		//Create it
		if (p_forceCreate)
		{
			xml_entity_addState(p_EntityXml, p_State, p_merge);
			return true;
		}
		else //Give up
			return false;
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
			
			l_xml.addChild(Xml.createCData(p_State.value));
		}
		
		//Check for meta stuff /edit 28-11-16: WE THE FUCK DO I HAVE TO ADD THE META TO THE MSTATES? Can't I get these shit from their parent states somehow??
		if (p_State.visible != null)
			l_state.set("visible", p_State.visible);
		
		if (p_State.onChange != null)
			l_state.set("onChange", p_State.onChange);
			
		if (p_State.nick != null)
			l_state.set("nick", p_State.nick);
			
		if (p_State.objectSpecific != null)
			l_state.set("objectSpecific", p_State.objectSpecific);
			
		if (p_State.live != null)
			l_state.set("live", p_State.live);
			
		if (p_State.control != null)
			l_state.set("control", p_State.control);
		
		return l_state;
	}
	
	public function xml_entity_updateMState(p_EntityXml:Xml, p_State:Dynamic, p_merge:Bool, p_forceCreate:Bool=false):Bool
	{
		var l_groupName:String;
		if (p_merge) l_groupName = "_States";
			else l_groupName = "States";
		
		//Check if group exists,
		var l_group:Xml;
		var l_elements:Iterator<Xml> = p_EntityXml.elementsNamed(l_groupName);
		
		if (l_elements.hasNext())
			l_group = l_elements.next();
		else //Group not found
		{
			//Create it
			if (p_forceCreate)
			{
				xml_entity_addMState(p_EntityXml, p_State, p_merge);
				return true;
			}
			else //Give up
				return false;
		}
		
		//Look for MState
		for (stateNode in l_group.elements()) //warning.. i should really do this elementsNamed("_States") instead..
		{
			var f_id:String = stateNode.get("id");
			
			if (f_id == p_State.id)
			{
				var f_valueNode:Xml = xml_getElement(stateNode, "Value");
				f_valueNode.removeChild(f_valueNode.firstChild());
				f_valueNode.addChild(Xml.createCData(p_State.value));
				return true;
			}
			
		}
		
		//Didn't found it
		
		//Create it
		if (p_forceCreate)
		{
			xml_entity_addMState(p_EntityXml, p_State, p_merge);
			return true;
		}
		else //Give up
			return false;
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