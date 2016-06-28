/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.gde.core;
import tools.spark.framework.Assets;
import tools.spark.sliced.services.std.logic.gde.interfaces.EGameType;
import tools.spark.sliced.services.std.logic.gde.interfaces.ENodeType;
import tools.spark.sliced.services.std.logic.gde.interfaces.EConcurrencyType;
import tools.spark.sliced.services.std.logic.gde.interfaces.EStateType;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameAction;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameClassInstantiator;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameClassParser;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameClassValidator;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameFactory;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameForm;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameSpace;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameState;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameTrigger;

/**
 * ...
 * @author Aris Kostakos
 */
class GameClassParser implements IGameClassParser
{
	private var _gameClassValidator:IGameClassValidator;
	private var _gameClassInstantiator:IGameClassInstantiator;
	
	private var _xmlNodeTypeToNodeName:Map<ENodeType,String>;
	private var _xmlNodeNameToNodeType:Map<String,ENodeType>;
	private var _xmlGameTypeToNodeName:Map<EGameType,String>;
	private var _xmlNodeTypeToGameType:Map<ENodeType,EGameType>;
	//private var _xmlGameTypeToFileExtension:Map<EGameType,String>;
	private var _xmlConcurrencyTypeToName:Map<EConcurrencyType,String>;
	private var _xmlConcurrencyNameToType:Map<String,EConcurrencyType>;
	private var _xmlStateTypeToName:Map<EStateType,String>;
	private var _xmlStateNameToType:Map<String,EStateType>;
	private var _isNodeExtendable:Map<ENodeType,Bool>;
	private var _isNodeMergable:Map<ENodeType,Bool>;
	private var _isNodeTargetMergable:Map<ENodeType,Bool>;
	private var _isNodeArray:Map<ENodeType,Bool>;
	
	inline static private var _XMLELEMENT_EXTENDS:String = "Extends";
	inline static public var _XMLATTRIBUTE_EXTENDS:String = "extends";
	
	inline static private var _XMLELEMENT_TARGETMERGE:String = "Id";
	inline static private var _XMLATTRIBUTE_TARGETMERGE:String = "id";
	
	inline static private var _XMLNODEMODIFIER_MERGE:String = "_";
	inline static private var _MERGEWIDTH:Int = 1;
	
	public function new() 
	{
		Console.log("Creating Game Class Parser");
		
		_init();
	}
	
	private function _init():Void
	{
		_initNodeNamesMap();
		_initNodeTypesMap();
		_initGameTypesMap();
		_initNodeToGameMap();
		//_initFileExtensionsMap();
		_initExtendableNodesMap();
		_initMergableNodesMap();
		_initTargetMergableNodesMap();
		_initArrayNodesMap();
		_initConcurrencyTypeToNameMap();
		_initConcurrencyNameToTypeMap();
		_initStateTypeToNameMap();
		_initStateNameToTypeMap();
		_gameClassValidator = new GameClassValidator(_xmlNodeTypeToNodeName, _xmlConcurrencyTypeToName, _xmlStateTypeToName);
		_gameClassInstantiator = new GameClassInstantiator(_xmlNodeTypeToNodeName, _xmlConcurrencyNameToType, _xmlStateNameToType);
	}
	
	
	
	//Mapping
	
	private function _initNodeNamesMap():Void
	{
		_xmlNodeTypeToNodeName = new Map<ENodeType,String>();
		
		_xmlNodeTypeToNodeName[ENodeType.ACTION] = "Action";
		_xmlNodeTypeToNodeName[ENodeType.ACTIONS] = "Actions";
		_xmlNodeTypeToNodeName[ENodeType.ENTITIES] = "Entities";
		_xmlNodeTypeToNodeName[ENodeType.ENTITY] = "Entity";
		_xmlNodeTypeToNodeName[ENodeType.FORM] = "Form";
		_xmlNodeTypeToNodeName[ENodeType.SCRIPTS] = "Scripts";
		_xmlNodeTypeToNodeName[ENodeType.SCRIPT] = "Script";
		_xmlNodeTypeToNodeName[ENodeType.GML] = "Gml";
		_xmlNodeTypeToNodeName[ENodeType.TRIGGERS] = "Triggers";
		_xmlNodeTypeToNodeName[ENodeType.TRIGGER] = "Trigger";
		_xmlNodeTypeToNodeName[ENodeType.EVENT] = "Event";
		_xmlNodeTypeToNodeName[ENodeType.PARAMETER] = "Parameter";
		_xmlNodeTypeToNodeName[ENodeType.TARGET] = "Target";
		_xmlNodeTypeToNodeName[ENodeType.TARGET_TYPE] = "TargetType";
		_xmlNodeTypeToNodeName[ENodeType.CONCURRENCY] = "Concurrency";
		_xmlNodeTypeToNodeName[ENodeType.ID] = "Id";
		_xmlNodeTypeToNodeName[ENodeType.SPACE] = "Space";
		_xmlNodeTypeToNodeName[ENodeType.STATE] = "State";
		_xmlNodeTypeToNodeName[ENodeType.STATES] = "States";
		_xmlNodeTypeToNodeName[ENodeType.TYPE] = "Type";
		_xmlNodeTypeToNodeName[ENodeType.VALUE] = "Value";
		_xmlNodeTypeToNodeName[ENodeType.EXTENDS] = "Extends";
	}
	
	private function _initNodeTypesMap():Void
	{
		_xmlNodeNameToNodeType = new Map<String,ENodeType>();
		
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.ACTION]] = ENodeType.ACTION;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.ACTIONS]] = ENodeType.ACTIONS;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.ENTITIES]] = ENodeType.ENTITIES;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.ENTITY]] = ENodeType.ENTITY;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.FORM]] = ENodeType.FORM;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.SCRIPTS]] = ENodeType.SCRIPTS;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.SCRIPT]] = ENodeType.SCRIPT;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.GML]] = ENodeType.GML;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.TRIGGERS]] = ENodeType.TRIGGERS;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.TRIGGER]] = ENodeType.TRIGGER;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.EVENT]] = ENodeType.EVENT;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.PARAMETER]] = ENodeType.PARAMETER;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.TARGET]] = ENodeType.TARGET;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.TARGET_TYPE]] = ENodeType.TARGET_TYPE;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.CONCURRENCY]] = ENodeType.CONCURRENCY;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.ID]] = ENodeType.ID;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.SPACE]] = ENodeType.SPACE;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.STATE]] = ENodeType.STATE;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.STATES]] = ENodeType.STATES;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.TYPE]] = ENodeType.TYPE;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.VALUE]] = ENodeType.VALUE;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.EXTENDS]] = ENodeType.EXTENDS;
	}
	
	private function _initGameTypesMap():Void
	{
		_xmlGameTypeToNodeName = new Map<EGameType,String>();
		
		_xmlGameTypeToNodeName[EGameType.ENTITY] = _xmlNodeTypeToNodeName[ENodeType.ENTITY];
		_xmlGameTypeToNodeName[EGameType.STATE] = _xmlNodeTypeToNodeName[ENodeType.STATE];
		_xmlGameTypeToNodeName[EGameType.SPACE] = _xmlNodeTypeToNodeName[ENodeType.SPACE];
		_xmlGameTypeToNodeName[EGameType.FORM] = _xmlNodeTypeToNodeName[ENodeType.FORM];
		_xmlGameTypeToNodeName[EGameType.ACTION] = _xmlNodeTypeToNodeName[ENodeType.ACTION];
		_xmlGameTypeToNodeName[EGameType.TRIGGER] = _xmlNodeTypeToNodeName[ENodeType.TRIGGER];
	}
	
	private function _initNodeToGameMap():Void
	{
		_xmlNodeTypeToGameType = new Map<ENodeType,EGameType>();
		
		_xmlNodeTypeToGameType[ENodeType.ENTITY] = EGameType.ENTITY;
		_xmlNodeTypeToGameType[ENodeType.STATE] = EGameType.STATE;
		_xmlNodeTypeToGameType[ENodeType.SPACE] = EGameType.SPACE;
		_xmlNodeTypeToGameType[ENodeType.FORM] = EGameType.FORM;
		_xmlNodeTypeToGameType[ENodeType.ACTION] = EGameType.ACTION;
		_xmlNodeTypeToGameType[ENodeType.TRIGGER] = EGameType.TRIGGER;
	}
	
	/* Don't need it anymore.. but maybe we will later
	private function _initFileExtensionsMap():Void
	{
		_xmlGameTypeToFileExtension = new Map<EGameType,String>();
		
		_xmlGameTypeToFileExtension[EGameType.ENTITY] = "egc";
		_xmlGameTypeToFileExtension[EGameType.STATE] = "sgc";
		_xmlGameTypeToFileExtension[EGameType.SPACE] = "pgc";
		_xmlGameTypeToFileExtension[EGameType.FORM] = "fgc";
		_xmlGameTypeToFileExtension[EGameType.ACTION] = "agc";
		_xmlGameTypeToFileExtension[EGameType.TRIGGER] = "tgc";
	}
	*/

	private function _initExtendableNodesMap():Void
	{
		_isNodeExtendable = new Map<ENodeType,Bool>();
		
		_isNodeExtendable[ENodeType.ACTION] = true;
		_isNodeExtendable[ENodeType.ACTIONS] = false;
		_isNodeExtendable[ENodeType.ENTITIES] = false;
		_isNodeExtendable[ENodeType.ENTITY] = true;
		_isNodeExtendable[ENodeType.FORM] = true;
		_isNodeExtendable[ENodeType.SCRIPTS] = false;
		_isNodeExtendable[ENodeType.SCRIPT] = false;
		_isNodeExtendable[ENodeType.GML] = false;
		_isNodeExtendable[ENodeType.TRIGGERS] = false;
		_isNodeExtendable[ENodeType.TRIGGER] = true;
		_isNodeExtendable[ENodeType.EVENT] = false;
		_isNodeExtendable[ENodeType.PARAMETER] = false;
		_isNodeExtendable[ENodeType.TARGET] = false;
		_isNodeExtendable[ENodeType.TARGET_TYPE] = false;
		_isNodeExtendable[ENodeType.CONCURRENCY] = false;
		_isNodeExtendable[ENodeType.ID] = false;
		_isNodeExtendable[ENodeType.SPACE] = true;
		_isNodeExtendable[ENodeType.STATE] = true;
		_isNodeExtendable[ENodeType.STATES] = false;
		_isNodeExtendable[ENodeType.TYPE] = false;
		_isNodeExtendable[ENodeType.VALUE] = false;
		_isNodeExtendable[ENodeType.EXTENDS] = false;
	}
	
	private function _initMergableNodesMap():Void
	{
		_isNodeMergable = new Map<ENodeType,Bool>();
		
		_isNodeMergable[ENodeType.ACTION] = false;
		_isNodeMergable[ENodeType.ACTIONS] = true;
		_isNodeMergable[ENodeType.ENTITIES] = true;
		_isNodeMergable[ENodeType.ENTITY] = false;
		_isNodeMergable[ENodeType.FORM] = true; //should this be false? this code is 2 years old, can't remember. maybe its fine.. i guess its fine..
		_isNodeMergable[ENodeType.SCRIPTS] = true;
		_isNodeMergable[ENodeType.SCRIPT] = false;
		_isNodeMergable[ENodeType.GML] = false;
		_isNodeMergable[ENodeType.TRIGGERS] = true;
		_isNodeMergable[ENodeType.TRIGGER] = false;
		_isNodeMergable[ENodeType.EVENT] = false;
		_isNodeMergable[ENodeType.PARAMETER] = false;
		_isNodeMergable[ENodeType.TARGET] = false;
		_isNodeMergable[ENodeType.TARGET_TYPE] = false;
		_isNodeMergable[ENodeType.CONCURRENCY] = false;
		_isNodeMergable[ENodeType.ID] = false;
		_isNodeMergable[ENodeType.SPACE] = true;
		_isNodeMergable[ENodeType.STATE] = false;
		_isNodeMergable[ENodeType.STATES] = true;
		_isNodeMergable[ENodeType.TYPE] = false;
		_isNodeMergable[ENodeType.VALUE] = false;
		_isNodeMergable[ENodeType.EXTENDS] = false;
	}
	
	private function _initTargetMergableNodesMap():Void
	{
		_isNodeTargetMergable = new Map<ENodeType,Bool>();
		
		_isNodeTargetMergable[ENodeType.ACTION] = true;
		_isNodeTargetMergable[ENodeType.ACTIONS] = false;
		_isNodeTargetMergable[ENodeType.ENTITIES] = false;
		_isNodeTargetMergable[ENodeType.ENTITY] = false;
		_isNodeTargetMergable[ENodeType.FORM] = false;
		_isNodeTargetMergable[ENodeType.SCRIPTS] = false;
		_isNodeTargetMergable[ENodeType.SCRIPT] = false;
		_isNodeTargetMergable[ENodeType.GML] = false;
		_isNodeTargetMergable[ENodeType.TRIGGERS] = false;
		_isNodeTargetMergable[ENodeType.TRIGGER] = false;
		_isNodeTargetMergable[ENodeType.EVENT] = false;
		_isNodeTargetMergable[ENodeType.PARAMETER] = false;
		_isNodeTargetMergable[ENodeType.TARGET] = false;
		_isNodeTargetMergable[ENodeType.TARGET_TYPE] = false;
		_isNodeTargetMergable[ENodeType.CONCURRENCY] = false;
		_isNodeTargetMergable[ENodeType.ID] = false;
		_isNodeTargetMergable[ENodeType.SPACE] = false;
		_isNodeTargetMergable[ENodeType.STATE] = true;
		_isNodeTargetMergable[ENodeType.STATES] = false;
		_isNodeTargetMergable[ENodeType.TYPE] = false;
		_isNodeTargetMergable[ENodeType.VALUE] = false;
		_isNodeTargetMergable[ENodeType.EXTENDS] = false;
	}
	
	private function _initArrayNodesMap():Void
	{
		_isNodeArray = new Map<ENodeType,Bool>();
		
		_isNodeArray[ENodeType.ACTION] = false;
		_isNodeArray[ENodeType.ACTIONS] = true;
		_isNodeArray[ENodeType.ENTITIES] = true;
		_isNodeArray[ENodeType.ENTITY] = false;
		_isNodeArray[ENodeType.FORM] = false;
		_isNodeArray[ENodeType.SCRIPTS] = true;
		_isNodeArray[ENodeType.SCRIPT] = false;
		_isNodeArray[ENodeType.GML] = false;
		_isNodeArray[ENodeType.TRIGGERS] = true;
		_isNodeArray[ENodeType.TRIGGER] = false;
		_isNodeArray[ENodeType.EVENT] = false;
		_isNodeArray[ENodeType.PARAMETER] = false;
		_isNodeArray[ENodeType.TARGET] = false;
		_isNodeArray[ENodeType.TARGET_TYPE] = false;
		_isNodeArray[ENodeType.CONCURRENCY] = false;
		_isNodeArray[ENodeType.ID] = false;
		_isNodeArray[ENodeType.SPACE] = false;
		_isNodeArray[ENodeType.STATE] = false;
		_isNodeArray[ENodeType.STATES] = true;
		_isNodeArray[ENodeType.TYPE] = false;
		_isNodeArray[ENodeType.VALUE] = false;
		_isNodeArray[ENodeType.EXTENDS] = true;
	}

	private function _initConcurrencyTypeToNameMap():Void
	{
		_xmlConcurrencyTypeToName = new Map<EConcurrencyType,String>();
		
		_xmlConcurrencyTypeToName[EConcurrencyType.PARALLEL] = "Parallel";
		_xmlConcurrencyTypeToName[EConcurrencyType.PERSISTENT] = "Persistent";
		_xmlConcurrencyTypeToName[EConcurrencyType.TRANSIENT] = "Transient";
	}
	
	private function _initConcurrencyNameToTypeMap():Void
	{
		_xmlConcurrencyNameToType = new Map<String,EConcurrencyType>();
		
		_xmlConcurrencyNameToType[_xmlConcurrencyTypeToName[EConcurrencyType.PARALLEL]] = EConcurrencyType.PARALLEL;
		_xmlConcurrencyNameToType[_xmlConcurrencyTypeToName[EConcurrencyType.PERSISTENT]] = EConcurrencyType.PERSISTENT;
		_xmlConcurrencyNameToType[_xmlConcurrencyTypeToName[EConcurrencyType.TRANSIENT]] = EConcurrencyType.TRANSIENT;
	}
	
	private function _initStateTypeToNameMap():Void
	{
		_xmlStateTypeToName = new Map<EStateType,String>();
		
		_xmlStateTypeToName[EStateType.EXPRESSION] = "Expression";
		_xmlStateTypeToName[EStateType.DYNAMIC] = "Dynamic";
		_xmlStateTypeToName[EStateType.BOOLEAN] = "Boolean";
		_xmlStateTypeToName[EStateType.DECIMAL] = "Decimal";
		_xmlStateTypeToName[EStateType.INTEGER] = "Integer";
		_xmlStateTypeToName[EStateType.TEXT] = "Text";
	}
	
	private function _initStateNameToTypeMap():Void
	{
		_xmlStateNameToType = new Map<String,EStateType>();
		
		_xmlStateNameToType[_xmlStateTypeToName[EStateType.EXPRESSION]] = EStateType.EXPRESSION;
		_xmlStateNameToType[_xmlStateTypeToName[EStateType.DYNAMIC]] = EStateType.DYNAMIC;
		_xmlStateNameToType[_xmlStateTypeToName[EStateType.BOOLEAN]] = EStateType.BOOLEAN;
		_xmlStateNameToType[_xmlStateTypeToName[EStateType.DECIMAL]] = EStateType.DECIMAL;
		_xmlStateNameToType[_xmlStateTypeToName[EStateType.INTEGER]] = EStateType.INTEGER;
		_xmlStateNameToType[_xmlStateTypeToName[EStateType.TEXT]] = EStateType.TEXT;
	}
	
	//METHODS
	
	//Parser
	public function parseGameNode(p_gameNode:Xml):Bool
	{
		//extend
		//Console.log('Extending ' + p_gameNode.nodeName + ' Node...');
		if (_extendGameNode(p_gameNode))
		{
			//Display the full Node after extending it
			//Console.debug(p_gameNode.toString());
			//Console.log('Extending ' + p_gameNode.nodeName + ' Node COMPLETED');
			
			//merge
			//Console.log('Merging ' + p_gameNode.nodeName + ' Node...');
			_mergeGameNode(p_gameNode);

			//Display the full Node after merging it
			//Console.debug(p_gameNode.toString());
			//Console.log('Merging ' + p_gameNode.nodeName + ' Node COMPLETED');
			
			//Validate
			//Console.log('Validating ' + p_gameNode.nodeName + ' Node...');
			if (_validateGameNode(p_gameNode))
			{
				//Display the full Node after validating it
				//Console.debug(p_gameNode.toString());
				//Console.log('Validating ' + p_gameNode.nodeName + ' Node COMPLETED');
				
				return true;
			}
			else
			{
				Console.error('Game Entity could not be validated');
				return false;
			}
		}
		else
		{
			Console.error('Game Entity Class is not valid!');
			//Console.debug(p_gameNode);
			return false;
		}
	}
	
	//Instantiators
	inline public function instantiateEntity(p_gameNode:Xml):IGameEntity {
		return _gameClassInstantiator.instantiateEntity(p_gameNode);
	}
	inline public function instantiateForm(p_gameNode:Xml):IGameForm {
		return _gameClassInstantiator.instantiateForm(p_gameNode);
	}
	inline public function instantiateSpace(p_gameNode:Xml):IGameSpace {
		return _gameClassInstantiator.instantiateSpace(p_gameNode);
	}
	inline public function instantiateState(p_gameNode:Xml):IGameState {
		return _gameClassInstantiator.instantiateState(p_gameNode);
	}
	inline public function instantiateAction(p_gameNode:Xml):IGameAction {
		return _gameClassInstantiator.instantiateAction(p_gameNode);
	}
	
	inline public function instantiateTrigger(p_gameNode:Xml):IGameTrigger {
		return _gameClassInstantiator.instantiateTrigger(p_gameNode);
	}
	
	//Deep parsing functions (most are called a lot so they're inlined)
	
	//@todo: instead of the whole Boolean system, use try/catch/throw for all functions, including _extendGameNode itself.or not? can I do it with thtrow/catch and still
	//keep the error messages that tell me what went wrong exactly and also have the code be more clear than with the nested ifs???
	private function _extendGameNode(p_gameNode:Xml):Bool
	{
		//Get Node Type
		var l_gameNodeType:ENodeType;
		
		//If element is a mergeNode
		if (p_gameNode.nodeName.substr(0,_MERGEWIDTH) == _XMLNODEMODIFIER_MERGE)
			l_gameNodeType = _xmlNodeNameToNodeType[p_gameNode.nodeName.substr(_MERGEWIDTH)];
		else //if element is a clean node
			l_gameNodeType = _xmlNodeNameToNodeType[p_gameNode.nodeName];
		
		if (l_gameNodeType == null)
		{
			Console.error('Unexpected Element: <' + p_gameNode.nodeName + '>');
			return false;
		}
		else
		{
			//For all Elements
			//@todo: Catch infinite recursion if an entity contains itself in it's form space. or in other cases as well
			for ( elt in p_gameNode.elements() ) 
			{
				if (_extendGameNode(elt) == false)
				{
					Console.error('Failed to parse node ' + elt.nodeName);
					return false;
				}
			}
				
			if (_handleExtendsElement(p_gameNode, l_gameNodeType))
			{
				if (_handleExtendsAttribute(p_gameNode, l_gameNodeType))
				{	
					return true;
				}
				else
				{
					Console.error('Failed to extend $l_gameNodeType node from the "extends" parameter.');
					return false;
				}
			}
			else
			{
				Console.error('Failed to extend $l_gameNodeType node from the "Extends" tag.');
				return false;
			}
		}
	}

	private function _handleExtendsElement(p_gameNode:Xml, p_nodeType:ENodeType):Bool
	{
		var l_extendsElementFound:Bool = p_gameNode.elementsNamed(_XMLELEMENT_EXTENDS).hasNext();
		
		if (_isNodeExtendable[p_nodeType] && l_extendsElementFound)
		{ 
			var l_extendsElement:Xml = p_gameNode.elementsNamed(_XMLELEMENT_EXTENDS).next();
			
			var l_extendsChildren:Array<Xml> = new Array<Xml>();
			
			for(elt in l_extendsElement.elements())
				l_extendsChildren.insert(0,elt);    
			
			for (elt in l_extendsChildren) 
			{
				if (_xmlNodeTypeToNodeName[p_nodeType] == elt.nodeName)
				{
					//Move super's children to p_gameNode
					_moveChildren(p_gameNode, elt);
				}
				else
				{
					Console.error("Expected Node <" + _xmlNodeTypeToNodeName[p_nodeType] + ">. Got <" + elt.nodeName + ">.");
					return false;
				}
			}
			
			p_gameNode.removeChild(l_extendsElement);
			return true;
		}
		else
		{
			if (l_extendsElementFound)
			{
				Console.warn('Element $p_nodeType cannot be extended!');
				return false;
			}
			else
			{
				return true;
			}
		}
	}
	
	inline private function _handleExtendsAttribute(p_gameNode:Xml, p_nodeType:ENodeType):Bool
	{
		if (_isNodeExtendable[p_nodeType] && p_gameNode.exists(_XMLATTRIBUTE_EXTENDS))
		{ 
			//Get the class from the embedded assets folder(preloaded)
			var l_superNode:Xml = getGameNode(_xmlNodeTypeToGameType[p_nodeType], p_gameNode.get(_XMLATTRIBUTE_EXTENDS));
			
			p_gameNode.remove(_XMLATTRIBUTE_EXTENDS);
			
			if (l_superNode!=null)
			{
				if (_extendGameNode(l_superNode))
				{
					//Console.debug('Successful parsing of Super-Node ' + l_superNode.nodeName);
					
					//Move super's children to p_gameNode
					_moveChildren(p_gameNode, l_superNode);
					
					return true;
				}
				else
				{
					Console.error('$p_nodeType Class is not valid!');
					return false;
				}
			}
			else
			{
				Console.error('$p_nodeType Class is not well-formed or not found!');
				return false;
			}
		}
		else
		{
			if (p_gameNode.exists(_XMLATTRIBUTE_EXTENDS))
			{
				Console.error('Element $p_nodeType cannot be extended!');
				return false;
			}
			else
			{
				return true;
			}
		}
	}
	
	inline private function _moveChildren(p_gameNode:Xml, p_superNode:Xml):Void
	{
		//Solution to html5 bug
		var childrenArray:Array<Xml> = new Array<Xml>();
		for (elt in p_superNode.elements())
			childrenArray.push(elt);
		
		//For all Elements of supernode
		for (elt in childrenArray)
		{
			//If a node with the same name does not exist in p_gameNode
			if (p_gameNode.elementsNamed(elt.nodeName).hasNext() == false)
			{
				//Move the node to p_gameNode
				p_gameNode.addChild(elt);
			}
			else
			{
				//If element is a mergeNode
				if (elt.nodeName.substr(0,_MERGEWIDTH) == _XMLNODEMODIFIER_MERGE)
				{
					//Move the node at the top of p_gameNode's children
					p_gameNode.insertChild(elt, 0);
				}
			}
		}
	}
	
	private function _validateGameNode(p_gameNode:Xml):Bool
	{
		var l_gameNodeType:ENodeType = _xmlNodeNameToNodeType[p_gameNode.nodeName];
		
		if (_gameClassValidator.validateGameNode(p_gameNode, l_gameNodeType))
		{
			//For all Elements
			//@todo: Catch infinite recursion if an entity contains itself in it's form space. or in other cases as well
			for ( elt in p_gameNode.elements() ) 
			{
				if (_validateGameNode(elt) == false)
				{
					Console.error('Failed to validate node ' + elt.nodeName);
					
					//for when you can't find what the problem is, maybe this will help
					//if (elt.nodeName=="Entity") 
					//	Console.error(p_gameNode.toString());
						
					return false;
				}
			}
			return true;
		}
		else
		{
			Console.error('Failed to validate $l_gameNodeType node');
			return false;
		}
	}
	
	private function _mergeGameNode(p_gameNode:Xml):Void
	{
		_mergeSingleGameNode(p_gameNode);

		//For all Elements
		//@todo: Catch infinite recursion if an entity contains itself in it's form space. or in other cases as well
		for ( elt in p_gameNode.elements() ) 
		{
			_mergeGameNode(elt);
		}
	}
	
	inline private function _mergeSingleGameNode(p_gameNode:Xml):Void
	{
		//Solution to html5 bug
		//@TODO: maybe there's a better way to solve this. How about you just store the enumerable of p_gameNode instead of creating a new array. Small otpimization, but it IS the better solution
		var childrenArray:Array<Xml> = new Array<Xml>();
		for (elt in p_gameNode.elements())
			childrenArray.push(elt);
			
		//For all Elements
		for ( elt in childrenArray ) 
		{
			//If element is a mergeNode
			if (elt.nodeName.substr(0,_MERGEWIDTH) == _XMLNODEMODIFIER_MERGE)
			{
				//Clean node name
				var l_elementCleanNodeName:String = elt.nodeName.substr(_MERGEWIDTH);
				
				//If the element is a mergable node
				if (_isNodeMergable[_xmlNodeNameToNodeType[l_elementCleanNodeName]])
				{
					//If a clean corresponding node exists
					if (p_gameNode.elementsNamed(l_elementCleanNodeName).hasNext())
					{
						//Get corresponding clean node
						var l_cleanNode:Xml = p_gameNode.elementsNamed(l_elementCleanNodeName).next();
						
						//Merge Children
						_mergeChildren(elt, l_cleanNode);
						
						//Remove the empty merge node
						p_gameNode.removeChild(elt);
					}
					//If a clean corresponding clean node does not exist
					else
					{
						//Rename merge node as a clean node
						elt.nodeName = elt.nodeName.substr(_MERGEWIDTH);
					}
				}
				else
				{
					//If the element is a target-mergable node  (mergableNodes and target-mergableNodes are mutually exclusive. One can't be both!)
					if (_isNodeTargetMergable[_xmlNodeNameToNodeType[l_elementCleanNodeName]])
					{
						if (elt.exists(_XMLATTRIBUTE_TARGETMERGE))
						{
							//Look for the target clean Node
							var l_cleanNode:Xml=null;
							var l_targetNodeFound:Bool = false;
							for (i_cleanNode in p_gameNode.elementsNamed(l_elementCleanNodeName))
							{
								if (i_cleanNode.elementsNamed(_XMLELEMENT_TARGETMERGE).hasNext())
								{
									var l_targetMergeElement:Xml = i_cleanNode.elementsNamed(_XMLELEMENT_TARGETMERGE).next();
									if (l_targetMergeElement.firstChild().nodeValue == elt.get(_XMLATTRIBUTE_TARGETMERGE))
									{
										l_cleanNode = i_cleanNode;
										l_targetNodeFound = true;
										break;
									}
								}
							}
							
							if (l_targetNodeFound)
							{
								//Merge Children
								_mergeChildren(elt, l_cleanNode);
						
								//Remove the empty merge node
								p_gameNode.removeChild(elt);
							}
							else
							{
								//Rename merge node as a clean node
								elt.nodeName = elt.nodeName.substr(_MERGEWIDTH);
								
								//@todo: maybe i should even create a target-merge-element IF one is not found? I'm inclining towards NO for now. Does't help, user will need to enter other
									//mandatory fields as well (ex. for State, he would need to enter the type element as well, which he probably wouldn't, so he might as well
									//enter the id element too. For Action he'd also need to enter the Concurrency element which he probably wouldn't).
								
								//Remove the target-merge attribute
								elt.remove(_XMLATTRIBUTE_TARGETMERGE);
							}
						}
						else
						{
							Console.warn('Target-Mergable Element $l_elementCleanNodeName does not have a targetMerge attribute');
						}
					}
					else
					{
						Console.warn('Non-mergable element $l_elementCleanNodeName has a merge identifier');
					}
				}
			}
		}
	}
	
	inline private function _mergeChildren(mergeNode:Xml, cleanNode:Xml):Void
	{
		//Solution to html5 bug
		var childrenArray:Array<Xml> = new Array<Xml>();
		for (elt in mergeNode.elements())
			childrenArray.push(elt);
			
		//If the element is an array node
		if (_isNodeArray[_xmlNodeNameToNodeType[cleanNode.nodeName]])
		{
			//Move children of merge node to the clean node
			for ( mergeNodeChild in childrenArray )
				cleanNode.addChild(mergeNodeChild);
		}
		else
		{
			//Move children of merge node to the clean node
			for ( mergeNodeChild in childrenArray ) 
			{
				if (mergeNodeChild.nodeName.substr(0,_MERGEWIDTH) != _XMLNODEMODIFIER_MERGE) //If the child is clean
					if (cleanNode.elementsNamed(mergeNodeChild.nodeName).hasNext()) //If a clean child with that name already exists in the non-array clean node
						cleanNode.removeChild(cleanNode.elementsNamed(mergeNodeChild.nodeName).next()); //remove the clean child with the same name from the clean node
				
				//Move the child to cleanNode
				cleanNode.addChild(mergeNodeChild);
			}
		}
	}
	
	inline private function _parseEmbeddedStringAsset(p_stringAssetUrl:String):Xml
	{
		try 
		{
			return Xml.parse(Assets.getScript(p_stringAssetUrl).toString());
		}
		catch (err:Dynamic) 
		{
			Console.error(Std.string(err));
			Console.error("Spark Parser Error: Entity [" + p_stringAssetUrl + "] has not been loaded!");
			return null;
		}
	}

	//DEPRECATED
	/*
	inline private function _getClassUrl(p_gameEntityClassName:String, p_fileExtension:String):String
	{
		return StringTools.replace(p_gameEntityClassName,".","/") + "." + p_fileExtension;
	}*/
	
	inline public function getGameNode(p_expectedGameType:EGameType, ?p_gameClassName:String, ?p_gameClassNode:Xml):Xml
	{
		var l_gameClassNode:Xml;

		if (p_gameClassName != null && p_gameClassNode != null)
		{
			Console.warn('Both a game class name and a game class node have been specified to create a game class. Using game class node...');
			l_gameClassNode = p_gameClassNode;
		}
		else if (p_gameClassName != null)
		{
			//@todo: _the function below may throw an exception(no it won't). in this case, throw one here too, and a trace saying the class file is not well-formed. Also, return null.
			//l_gameClassNode = _parseEmbeddedStringAsset(_getClassUrl(p_gameClassName, _xmlGameTypeToFileExtension[p_expectedGameType]));
			l_gameClassNode = _parseEmbeddedStringAsset(p_gameClassName);
			
			if (l_gameClassNode != null) l_gameClassNode = l_gameClassNode.firstElement();
		}
		else if (p_gameClassNode != null)
		{
			l_gameClassNode = p_gameClassNode;
		}
		else
		{
			l_gameClassNode = Xml.createElement(_xmlGameTypeToNodeName[p_expectedGameType]);
		}
		
		if (l_gameClassNode != null)
		{
			if (l_gameClassNode.nodeName != _xmlGameTypeToNodeName[p_expectedGameType])
			{
				Console.error('Expected ' + _xmlGameTypeToNodeName[p_expectedGameType] + ', got ' + l_gameClassNode.nodeName);
				return null;
			}
			else
			{
				return l_gameClassNode;
			}
		}
		else
		{
			Console.error('Class $p_expectedGameType ['+p_gameClassName+'] is not well-formed or not found!');
			return null;
		}
	}
}