/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.gde.core;
import tools.spark.framework.haxe.LooseCheck;
import tools.spark.framework.haxe.LooseCheck.Filter;
import tools.spark.framework.haxe.LooseCheck.Rule;
import tools.spark.framework.haxe.LooseCheck.Rule.RList;
import tools.spark.framework.haxe.LooseCheck.Rule.RNode;
import tools.spark.framework.haxe.LooseCheck.Rule.RChoice;
import tools.spark.framework.haxe.LooseCheck.Rule.RData;
import tools.spark.framework.haxe.LooseCheck.Rule.RMulti;
import tools.spark.framework.haxe.LooseCheck.Rule.ROptional;
import tools.spark.sliced.services.std.logic.gde.interfaces.ENodeType;
import tools.spark.sliced.services.std.logic.gde.interfaces.EConcurrencyType;
import tools.spark.sliced.services.std.logic.gde.interfaces.EStateType;
import tools.spark.sliced.services.std.logic.gde.interfaces.EventType;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameClassValidator;


/**
 * ...
 * @author Aris Kostakos
 */
class GameClassValidator implements IGameClassValidator
{
	private var _xmlNodeTypeToNodeName:Map<ENodeType,String>;
	private var _xmlNodeTypeToNodeRule:Map<ENodeType,Rule>;
	private var _xmlConcurrencyTypeToName:Map<EConcurrencyType,String>;
	private var _xmlStateTypeToName:Map<EStateType,String>;
	
	public function new(p_xmlNodeTypeToNodeName:Map<ENodeType,String>, p_xmlConcurrencyTypeToName:Map<EConcurrencyType,String>, p_xmlStateTypeToName:Map<EStateType,String>) 
	{
		Console.info("Creating Game Class Validator");
		_xmlNodeTypeToNodeName = p_xmlNodeTypeToNodeName;
		_xmlConcurrencyTypeToName = p_xmlConcurrencyTypeToName;
		_xmlStateTypeToName = p_xmlStateTypeToName;
		_init();
	}
	
	private function _init():Void
	{
		_initNodeRulesMap();
	}
		
	
	
	private function _initNodeRulesMap():Void
	{
		_xmlNodeTypeToNodeRule = new Map<ENodeType,Rule>();
		
		_xmlNodeTypeToNodeRule[ENodeType.ACTION] = _createActionNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.ACTIONS] = _createActionsNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.ENTITIES] = _createEntitiesNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.ENTITY] = _createEntityNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.FORM] = _createFormNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.SCRIPTS] = _createScriptsNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.SCRIPT] = _createScriptNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.GML] = _createGmlNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.TRIGGERS] = _createTriggersNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.TRIGGER] = _createTriggerNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.EVENT] = _createEventNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.PARAMETER] = _createParameterNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.TARGET] = _createTargetNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.TARGET_TYPE] = _createTargetTypeNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.CONCURRENCY] = _createConcurrencyNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.ID] = _createIdNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.SPACE] = _createSpaceNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.STATE] = _createStateNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.STATES] = _createStatesNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.TYPE] = _createTypeNodeRule();
		_xmlNodeTypeToNodeRule[ENodeType.VALUE] = _createValueNodeRule();
	}
	
	
	//METHODS
	
	public inline function validateGameNode(p_gameNode:Xml, p_nodeType:ENodeType):Bool
	{
		if (_xmlNodeTypeToNodeRule[p_nodeType] == null)
		{
			Console.error("This rule has not been created Yet!");
			return false;
		}
		
		try 
		{
			//@warning: This works, but LooseCheck has bugs. Benefit of loose check, i get good error messages, since
			//i check every node individually. Bad things is attribute validation won't work properly, i broke it
			//when modifying haxe.Check. If you need attribute validation in the future, just remove LooseCheck
			//and use Haxe's original Check the same way I use it in framework.config (the proper way to use Check, not check
			//node by node.. But the problem was, I was getting too abstract error messages, so I had to recheck all nodes,
			//in order to get proper messages about where the fault in the xml is.
			LooseCheck.checkNode(p_gameNode, _xmlNodeTypeToNodeRule[p_nodeType]);
			return true;
		}
		catch (m:String) 
		{
			Console.error(m);
			return false;
		}
	}
	
	
	//XML RULES (Schema)
	
	inline private function _createEntityNodeRule():Rule
	{
		var l_children:Rule = RList(
			[
				ROptional(RNode(_xmlNodeTypeToNodeName[ENodeType.ACTIONS])),
				ROptional(RNode(_xmlNodeTypeToNodeName[ENodeType.STATES])),
				ROptional(RNode(_xmlNodeTypeToNodeName[ENodeType.TRIGGERS])),
				RNode(_xmlNodeTypeToNodeName[ENodeType.FORM])
			],
			false
		);
		
		return RNode(_xmlNodeTypeToNodeName[ENodeType.ENTITY], [], l_children);
	}
	
	
	
	
	inline private function _createFormNodeRule():Rule
	{
		var l_children:Rule = RList(
			[
				ROptional(RNode(_xmlNodeTypeToNodeName[ENodeType.STATES])),
				RNode(_xmlNodeTypeToNodeName[ENodeType.SPACE])
			],
			false
		);
		
		return RNode(_xmlNodeTypeToNodeName[ENodeType.FORM], [], l_children);
	}
	
	inline private function _createStateNodeRule():Rule
	{
		var l_children:Rule = RList(
			[
				RNode(_xmlNodeTypeToNodeName[ENodeType.ID]),
				RNode(_xmlNodeTypeToNodeName[ENodeType.TYPE]),
				RNode(_xmlNodeTypeToNodeName[ENodeType.VALUE])
			],
			false
		);

		return RNode(_xmlNodeTypeToNodeName[ENodeType.STATE], [], l_children);
	}
	
	inline private function _createActionNodeRule():Rule
	{
		var l_children:Rule = RList(
			[
				RNode(_xmlNodeTypeToNodeName[ENodeType.ID]),
				RNode(_xmlNodeTypeToNodeName[ENodeType.CONCURRENCY]),
				RNode(_xmlNodeTypeToNodeName[ENodeType.SCRIPTS]),
				ROptional(RNode(_xmlNodeTypeToNodeName[ENodeType.STATES]))
			],
			false
		);
		//@todo: GOAP: add rules for action's metadata. a StatesRule for requirement states and a StatesRule for affected states. smth like that....

		return RNode(_xmlNodeTypeToNodeName[ENodeType.ACTION], [], l_children);
	}
	
	inline private function _createSpaceNodeRule():Rule
	{
		var l_children:Rule = ROptional(RNode(_xmlNodeTypeToNodeName[ENodeType.ENTITIES]));

		return RNode(_xmlNodeTypeToNodeName[ENodeType.SPACE], [], l_children);
	}

	inline private function _createEntitiesNodeRule():Rule
	{
		var l_children:Rule = RMulti(RNode(_xmlNodeTypeToNodeName[ENodeType.ENTITY]), false);

		return RNode(_xmlNodeTypeToNodeName[ENodeType.ENTITIES], [], l_children);
	}
	
	inline private function _createStatesNodeRule():Rule
	{
		var l_children:Rule = RMulti(RNode(_xmlNodeTypeToNodeName[ENodeType.STATE]), false);

		return RNode(_xmlNodeTypeToNodeName[ENodeType.STATES], [], l_children);
	}
	
	inline private function _createActionsNodeRule():Rule
	{
		var l_children:Rule = RMulti(RNode(_xmlNodeTypeToNodeName[ENodeType.ACTION]), false);

		return RNode(_xmlNodeTypeToNodeName[ENodeType.ACTIONS], [], l_children);
	}
	
	inline private function _createIdNodeRule():Rule
	{
		var l_children:Rule = RData();

		return RNode(_xmlNodeTypeToNodeName[ENodeType.ID], [], l_children);
	}
	
	inline private function _createScriptsNodeRule():Rule
	{
		var l_children:Rule = RMulti(
				RChoice(
				[
					RNode(_xmlNodeTypeToNodeName[ENodeType.SCRIPT]),
					RNode(_xmlNodeTypeToNodeName[ENodeType.GML])
				]
				),
			true
		);
		return RNode(_xmlNodeTypeToNodeName[ENodeType.SCRIPTS], [], l_children);
	}
	
	inline private function _createScriptNodeRule():Rule
	{
		var l_children:Rule = RData();

		return RNode(_xmlNodeTypeToNodeName[ENodeType.SCRIPT], [], l_children);
	}
	
	inline private function _createGmlNodeRule():Rule
	{
		var l_children:Rule = RData();

		return RNode(_xmlNodeTypeToNodeName[ENodeType.GML], [], l_children);
	}
	
	inline private function _createTriggersNodeRule():Rule
	{
		var l_children:Rule = RMulti(RNode(_xmlNodeTypeToNodeName[ENodeType.TRIGGER]), false);

		return RNode(_xmlNodeTypeToNodeName[ENodeType.TRIGGERS], [], l_children);
	}
	
	inline private function _createTriggerNodeRule():Rule
	{
		var l_children:Rule = RList(
			[
				RNode(_xmlNodeTypeToNodeName[ENodeType.EVENT]),
				ROptional(RNode(_xmlNodeTypeToNodeName[ENodeType.PARAMETER])),
				ROptional(RNode(_xmlNodeTypeToNodeName[ENodeType.TARGET])),
				ROptional(RNode(_xmlNodeTypeToNodeName[ENodeType.TARGET_TYPE])),
				RNode(_xmlNodeTypeToNodeName[ENodeType.SCRIPTS])
			],
			false
		);
		
		return RNode(_xmlNodeTypeToNodeName[ENodeType.TRIGGER], [], l_children);
	}

	inline private function _createParameterNodeRule():Rule
	{
		var l_children:Rule = RData();

		return RNode(_xmlNodeTypeToNodeName[ENodeType.PARAMETER], [], l_children);
	}
	inline private function _createTargetNodeRule():Rule
	{
		var l_children:Rule = RData();

		return RNode(_xmlNodeTypeToNodeName[ENodeType.TARGET], [], l_children);
	}
	inline private function _createTargetTypeNodeRule():Rule
	{
		var l_children:Rule = RData();

		return RNode(_xmlNodeTypeToNodeName[ENodeType.TARGET_TYPE], [], l_children);
	}
	
	
	inline private function _createConcurrencyNodeRule():Rule
	{
		var l_children:Rule = RData(FEnum([_xmlConcurrencyTypeToName[EConcurrencyType.PARALLEL],
								_xmlConcurrencyTypeToName[EConcurrencyType.PERSISTENT],
								_xmlConcurrencyTypeToName[EConcurrencyType.TRANSIENT]
								])
							);

		return RNode(_xmlNodeTypeToNodeName[ENodeType.CONCURRENCY], [], l_children);
	}
	

	inline private function _createTypeNodeRule():Rule
	{
		var l_children:Rule = RData(FEnum([
								_xmlStateTypeToName[EStateType.DYNAMIC],
								_xmlStateTypeToName[EStateType.INTEGER],
								_xmlStateTypeToName[EStateType.DECIMAL],
								_xmlStateTypeToName[EStateType.BOOLEAN],
								_xmlStateTypeToName[EStateType.TEXT]
								])
							);

		return RNode(_xmlNodeTypeToNodeName[ENodeType.TYPE], [], l_children);
	}
	
	inline private function _createValueNodeRule():Rule
	{
		var l_children:Rule = RData();

		return RNode(_xmlNodeTypeToNodeName[ENodeType.VALUE], [], l_children);
	}
	
	inline private function _createEventNodeRule():Rule
	{
		var l_children:Rule = RData(FEnum(EventType.eventTypesStringArray));

		return RNode(_xmlNodeTypeToNodeName[ENodeType.EVENT], [], l_children);
	}
}