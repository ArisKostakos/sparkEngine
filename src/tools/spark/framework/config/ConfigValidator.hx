/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2014
 */

package tools.spark.framework.config;

import haxe.xml.Check;
import haxe.xml.Check.Filter;
import haxe.xml.Check.Rule;
import haxe.xml.Check.Rule.RList;
import haxe.xml.Check.Rule.RNode;
import haxe.xml.Check.Rule.RChoice;
import haxe.xml.Check.Rule.RData;
import haxe.xml.Check.Rule.RMulti;
import haxe.xml.Check.Rule.ROptional;

/**
 * //@todo: filters for everything. And maybe special filter/logic for asset types. Like, script asset types cannot have an id parameter, etc..
 * @author Aris Kostakos
 */
class ConfigValidator
{
	private var _xmlNodeTypeToNodeName:Map<ENodeType,String>;
	private var _xmlNodeTypeToNodeRule:Map<ENodeType,Rule>;
	
	public function new(p_xmlNodeTypeToNodeName:Map<ENodeType,String>) 
	{
		_xmlNodeTypeToNodeName = p_xmlNodeTypeToNodeName;
	}
	
	public function init(p_rootNodeType:ENodeType):Void
	{
		_initNodeRulesMap(p_rootNodeType);
	}
		
	
	
	private function _initNodeRulesMap(p_rootNodeType:ENodeType):Void
	{
		_xmlNodeTypeToNodeRule = new Map<ENodeType,Rule>();
		
		//Common
		_xmlNodeTypeToNodeRule[ENodeType.REQUIRES_MODULE] = _createRequiresModuleNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.REQUIRES] = _createRequiresNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.ASSET] = _createAssetNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.MODULE] = _createModuleNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.ASSETS] = _createAssetsNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.PATH] = _createPathNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.PATHS] = _createPathsNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.SOUND_SERVICE] = _createSoundServiceNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.LOGIC_SERVICE] = _createLogicServiceNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.INPUT_SERVICE] = _createInputServiceNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.COMMUNICATIONS_SERVICE] = _createCommsServiceNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.EVENT_SERVICE] = _createEventServiceNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.DISPLAY_SERVICE] = _createDisplayServiceNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.EXECUTE_MODULE] = _createExecuteModuleNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.EXECUTE_AT_LAUNCH] = _createExecuteAtLaunchNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.PROJECT_NAME] = _createProjectNameNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.PROJECT_VERSION] = _createProjectVersionNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.PROJECT] = _createProjectNodeRule();
		
		//Client Only
		if (p_rootNodeType == ENodeType.CLIENT)
		{
			_xmlNodeTypeToNodeRule[ENodeType.SLICED] = _createSlicedClientNodeRule();
			_xmlNodeTypeToNodeRule[ENodeType.CLIENT] = _createClientNodeRule();
		}
		//Server Only
		else if (p_rootNodeType == ENodeType.SERVER)
		{
			_xmlNodeTypeToNodeRule[ENodeType.SLICED] = _createSlicedServerNodeRule();
			_xmlNodeTypeToNodeRule[ENodeType.SERVER] = _createServerNodeRule();
		}
	}
	
	
	//METHODS
	
	public inline function validateConfigNode(p_configNode:Xml, p_nodeType:ENodeType):Bool
	{
		if (_xmlNodeTypeToNodeRule[p_nodeType] == null)
		{
			Console.error("This Config Node Rule has not been created Yet!");
			return false;
		}
		
		try 
		{
			Check.checkNode(p_configNode, _xmlNodeTypeToNodeRule[p_nodeType]);
			return true;
		}
		catch (m:String) 
		{
			Console.error(m);
			return false;
		}
	}
	
	
	//XML RULES (Schema)
	
	inline private function _createClientNodeRule():Rule
	{
		var l_children:Rule = RList(
			[
				_xmlNodeTypeToNodeRule[ENodeType.PROJECT],
				_xmlNodeTypeToNodeRule[ENodeType.SLICED],
				_xmlNodeTypeToNodeRule[ENodeType.PATHS],
				_xmlNodeTypeToNodeRule[ENodeType.ASSETS]
			],
			false
		);
		
		return RNode(_xmlNodeTypeToNodeName[ENodeType.CLIENT], [], l_children);
	}
	
	inline private function _createServerNodeRule():Rule
	{
		var l_children:Rule = RList(
			[
				_xmlNodeTypeToNodeRule[ENodeType.PROJECT],
				_xmlNodeTypeToNodeRule[ENodeType.SLICED],
				_xmlNodeTypeToNodeRule[ENodeType.PATHS],
				_xmlNodeTypeToNodeRule[ENodeType.ASSETS]
			],
			false
		);
		
		return RNode(_xmlNodeTypeToNodeName[ENodeType.SERVER], [], l_children);
	}
	
	inline private function _createProjectNodeRule():Rule
	{
		var l_children:Rule = RList(
			[
				_xmlNodeTypeToNodeRule[ENodeType.PROJECT_NAME],
				_xmlNodeTypeToNodeRule[ENodeType.PROJECT_VERSION],
				_xmlNodeTypeToNodeRule[ENodeType.EXECUTE_AT_LAUNCH]
			],
			false
		);
		
		return RNode(_xmlNodeTypeToNodeName[ENodeType.PROJECT], [], l_children);
	}
	
	inline private function _createProjectNameNodeRule():Rule
	{
		var l_children:Rule = RData();

		return RNode(_xmlNodeTypeToNodeName[ENodeType.PROJECT_NAME], [], l_children);
	}
	
	inline private function _createProjectVersionNodeRule():Rule
	{
		var l_children:Rule = RData();

		return RNode(_xmlNodeTypeToNodeName[ENodeType.PROJECT_VERSION], [], l_children);
	}
	
	inline private function _createExecuteAtLaunchNodeRule():Rule
	{
		var l_children:Rule = RMulti(_xmlNodeTypeToNodeRule[ENodeType.EXECUTE_MODULE], true);

		return RNode(_xmlNodeTypeToNodeName[ENodeType.EXECUTE_AT_LAUNCH], [], l_children);
	}
	
	inline private function _createExecuteModuleNodeRule():Rule
	{
		var l_children:Rule = RData();

		return RNode(_xmlNodeTypeToNodeName[ENodeType.EXECUTE_MODULE], [], l_children);
	}
	
	inline private function _createSlicedClientNodeRule():Rule
	{
		var l_children:Rule = RList(
			[
				_xmlNodeTypeToNodeRule[ENodeType.SOUND_SERVICE],
				_xmlNodeTypeToNodeRule[ENodeType.LOGIC_SERVICE],
				_xmlNodeTypeToNodeRule[ENodeType.INPUT_SERVICE],
				_xmlNodeTypeToNodeRule[ENodeType.COMMUNICATIONS_SERVICE],
				_xmlNodeTypeToNodeRule[ENodeType.EVENT_SERVICE],
				_xmlNodeTypeToNodeRule[ENodeType.DISPLAY_SERVICE]
			],
			false
		);
		
		return RNode(_xmlNodeTypeToNodeName[ENodeType.SLICED], [], l_children);
	}
	
	inline private function _createSlicedServerNodeRule():Rule
	{
		var l_children:Rule = RList(
			[
				_xmlNodeTypeToNodeRule[ENodeType.LOGIC_SERVICE],
				_xmlNodeTypeToNodeRule[ENodeType.COMMUNICATIONS_SERVICE],
				_xmlNodeTypeToNodeRule[ENodeType.EVENT_SERVICE]
			],
			false
		);
		
		return RNode(_xmlNodeTypeToNodeName[ENodeType.SLICED], [], l_children);
	}
	
	inline private function _createSoundServiceNodeRule():Rule
	{
		var l_children:Rule = RData();

		return RNode(_xmlNodeTypeToNodeName[ENodeType.SOUND_SERVICE], [], l_children);
	}
	
	inline private function _createLogicServiceNodeRule():Rule
	{
		var l_children:Rule = RData();

		return RNode(_xmlNodeTypeToNodeName[ENodeType.LOGIC_SERVICE], [], l_children);
	}
	
	inline private function _createInputServiceNodeRule():Rule
	{
		var l_children:Rule = RData();

		return RNode(_xmlNodeTypeToNodeName[ENodeType.INPUT_SERVICE], [], l_children);
	}
	
	inline private function _createCommsServiceNodeRule():Rule
	{
		var l_children:Rule = RData();

		return RNode(_xmlNodeTypeToNodeName[ENodeType.COMMUNICATIONS_SERVICE], [], l_children);
	}
	
	inline private function _createEventServiceNodeRule():Rule
	{
		var l_children:Rule = RData();

		return RNode(_xmlNodeTypeToNodeName[ENodeType.EVENT_SERVICE], [], l_children);
	}
	
	inline private function _createDisplayServiceNodeRule():Rule
	{
		var l_children:Rule = RData();

		return RNode(_xmlNodeTypeToNodeName[ENodeType.DISPLAY_SERVICE], [], l_children);
	}
	
	inline private function _createPathsNodeRule():Rule
	{
		var l_children:Rule = RMulti(_xmlNodeTypeToNodeRule[ENodeType.PATH], true);

		return RNode(_xmlNodeTypeToNodeName[ENodeType.PATHS], [], l_children);
	}
	
	inline private function _createPathNodeRule():Rule
	{
		var l_children:Rule = RData();

		var l_attributes:Array<Attrib> = [	Attrib.Att("location"),
											Attrib.Att("type")
										 ];
		
		return RNode(_xmlNodeTypeToNodeName[ENodeType.PATH], l_attributes, l_children);
	}
	
	inline private function _createAssetsNodeRule():Rule
	{
		var l_children:Rule = RMulti(_xmlNodeTypeToNodeRule[ENodeType.MODULE], true);

		return RNode(_xmlNodeTypeToNodeName[ENodeType.ASSETS], [], l_children);
	}
	
	inline private function _createModuleNodeRule():Rule
	{
		var l_children:Rule = RList(
			[
				ROptional(_xmlNodeTypeToNodeRule[ENodeType.REQUIRES]),
				RMulti(_xmlNodeTypeToNodeRule[ENodeType.ASSET], true)
			],
			false
		);
		
		
		var l_attributes:Array<Attrib> = [	Attrib.Att("id"),
											Attrib.Att("executeEntity",null,"none")
										 ];
										 
		return RNode(_xmlNodeTypeToNodeName[ENodeType.MODULE], l_attributes, l_children);
	}
	
	inline private function _createAssetNodeRule():Rule
	{
		var l_children:Rule = RData();

		var l_attributes:Array<Attrib> = [	Attrib.Att("location"),
											Attrib.Att("type"),
											Attrib.Att("bytes"),
											Attrib.Att("subtype",null,"none"),
											Attrib.Att("id",null,"useUrl"),
											Attrib.Att("condition",null,"always"),
											Attrib.Att("forceLoadAsData",null,"false")
										 ];
		
		return RNode(_xmlNodeTypeToNodeName[ENodeType.ASSET], l_attributes, l_children);
	}
	
	inline private function _createRequiresNodeRule():Rule
	{
		var l_children:Rule = RMulti(_xmlNodeTypeToNodeRule[ENodeType.REQUIRES_MODULE], true);

		return RNode(_xmlNodeTypeToNodeName[ENodeType.REQUIRES], [], l_children);
	}
	
	inline private function _createRequiresModuleNodeRule():Rule
	{
		var l_children:Rule = RData();

		return RNode(_xmlNodeTypeToNodeName[ENodeType.REQUIRES_MODULE], [], l_children);
	}
	/*
	inline private function _createConcurrencyNodeRule():Rule
	{
		var l_children:Rule = RData(FEnum([_xmlConcurrencyTypeToName[EConcurrencyType.PARALLEL],
								_xmlConcurrencyTypeToName[EConcurrencyType.PERSISTENT],
								_xmlConcurrencyTypeToName[EConcurrencyType.TRANSIENT]
								])
							);

		return RNode(_xmlNodeTypeToNodeName[ENodeType.CONCURRENCY], [], l_children);
	}
	*/
}