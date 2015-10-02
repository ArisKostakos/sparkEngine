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
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventPrefab;
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
	private var _xmlEventPrefabToName:Map<EEventPrefab,String>;
	
	public function new(p_xmlNodeTypeToNodeName:Map<ENodeType,String>, p_xmlConcurrencyTypeToName:Map<EConcurrencyType,String>, p_xmlStateTypeToName:Map<EStateType,String>, p_xmlEventPrefabToName:Map<EEventPrefab,String>) 
	{
		Console.log("Creating Game Class Validator");
		_xmlNodeTypeToNodeName = p_xmlNodeTypeToNodeName;
		_xmlConcurrencyTypeToName = p_xmlConcurrencyTypeToName;
		_xmlStateTypeToName = p_xmlStateTypeToName;
		_xmlEventPrefabToName = p_xmlEventPrefabToName;
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
				RNode(_xmlNodeTypeToNodeName[ENodeType.SCRIPTS])
			],
			false
		);
		
		return RNode(_xmlNodeTypeToNodeName[ENodeType.TRIGGER], [], l_children);
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
		var l_children:Rule = RData(FEnum([
								_xmlEventPrefabToName[EEventPrefab.CREATED],
								_xmlEventPrefabToName[EEventPrefab.UPDATE],
								_xmlEventPrefabToName[EEventPrefab.CHANGED],
								_xmlEventPrefabToName[EEventPrefab.NETWORK_CONNECTED],
								_xmlEventPrefabToName[EEventPrefab.NETWORK_REQUEST],
								_xmlEventPrefabToName[EEventPrefab.NETWORK_SERVER_EVENT],
								_xmlEventPrefabToName[EEventPrefab.FILETRANSFER_CONNECTED],
								_xmlEventPrefabToName[EEventPrefab.FILETRANSFER_SENDREQUEST],
								_xmlEventPrefabToName[EEventPrefab.MOUSE_LEFT_CLICK],
								_xmlEventPrefabToName[EEventPrefab.MOUSE_RIGHT_CLICK],
								_xmlEventPrefabToName[EEventPrefab.MOUSE_LEFT_DOWN],
								_xmlEventPrefabToName[EEventPrefab.MOUSE_RIGHT_DOWN],
								_xmlEventPrefabToName[EEventPrefab.MOUSE_SCROLL],
								_xmlEventPrefabToName[EEventPrefab.MOUSE_LEFT_CLICKED],
								_xmlEventPrefabToName[EEventPrefab.MOUSE_RIGHT_CLICKED],
								_xmlEventPrefabToName[EEventPrefab.MOUSE_ENTERED],
								_xmlEventPrefabToName[EEventPrefab.MOUSE_MOVED],
								_xmlEventPrefabToName[EEventPrefab.MOUSE_LEFT],
								_xmlEventPrefabToName[EEventPrefab.MOUSE_DOWN],
								_xmlEventPrefabToName[EEventPrefab.MOUSE_UP],
								_xmlEventPrefabToName[EEventPrefab.ON_DRAG_START],
								_xmlEventPrefabToName[EEventPrefab.ON_DRAG],
								_xmlEventPrefabToName[EEventPrefab.ON_DRAG_END],
								_xmlEventPrefabToName[EEventPrefab.ON_DRAG_ENTER],
								_xmlEventPrefabToName[EEventPrefab.ON_DRAG_OVER],
								_xmlEventPrefabToName[EEventPrefab.ON_DRAG_LEAVE],
								_xmlEventPrefabToName[EEventPrefab.ON_DROP],
								_xmlEventPrefabToName[EEventPrefab.PHYSICS_COLLISION_START],
								_xmlEventPrefabToName[EEventPrefab.PHYSICS_COLLISION_END],
								_xmlEventPrefabToName[EEventPrefab.PHYSICS_SENSOR_START],
								_xmlEventPrefabToName[EEventPrefab.PHYSICS_SENSOR_START_BIPED_FEET],
								_xmlEventPrefabToName[EEventPrefab.PHYSICS_SENSOR_END],
								_xmlEventPrefabToName[EEventPrefab.PHYSICS_SENSOR_END_BIPED_FEET],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_LOCAL],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_LOCAL],
								_xmlEventPrefabToName[EEventPrefab.KEY_DOWN_LOCAL],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_ALT],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_BACKSPACE],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_CAPS_LOCK],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_CONTROL],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_DELETE],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_DOWN],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_END],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_ENTER],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_ESCAPE],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F1],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F10],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F11],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F12],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F13],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F14],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F15],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F2],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F3],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F4],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F5],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F6],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F7],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F8],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F9],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_HOME],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_INSERT],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_LEFT],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_0],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_1],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_2],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_3],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_4],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_5],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_6],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_7],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_8],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_9],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_ADD],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_DECIMAL],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_DIVIDE],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_ENTER],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_MULTIPLY],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_SUBTRACT],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_PAGE_DOWN],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_PAGE_UP],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_RIGHT],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_SHIFT],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_SPACE],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_TAB],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_UP],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_A],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_B],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_C],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_D],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_E],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_G],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_H],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_I],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_J],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_K],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_L],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_M],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_N],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_O],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_P],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_Q],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_R],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_S],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_T],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_U],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_V],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_W],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_X],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_Y],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_Z],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_0],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_1],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_2],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_3],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_4],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_5],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_6],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_7],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_8],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_9],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_EQUALS],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_SLASH],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_BACKSLASH],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_LEFTBRACKET],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_RIGHTBRACKET],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_BACKQUOTE],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_COMMA],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_COMMAND],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_MINUS],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_PERIOD],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_QUOTE],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_SEMICOLON],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_ANDROIDMENU],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_ANDROIDSEARCH],
								_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_UNKNOWN],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_ALT],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_BACKSPACE],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_CAPS_LOCK],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_CONTROL],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_DELETE],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_DOWN],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_END],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_ENTER],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_ESCAPE],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F1],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F10],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F11],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F12],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F13],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F14],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F15],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F2],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F3],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F4],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F5],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F6],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F7],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F8],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F9],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_HOME],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_INSERT],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_LEFT],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_0],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_1],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_2],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_3],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_4],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_5],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_6],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_7],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_8],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_9],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_ADD],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_DECIMAL],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_DIVIDE],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_ENTER],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_MULTIPLY],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_SUBTRACT],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_PAGE_DOWN],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_PAGE_UP],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_RIGHT],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_SHIFT],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_SPACE],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_TAB],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_UP],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_A],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_B],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_C],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_D],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_E],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_G],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_H],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_I],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_J],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_K],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_L],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_M],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_N],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_O],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_P],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_Q],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_R],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_S],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_T],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_U],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_V],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_W],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_X],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_Y],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_Z],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_0],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_1],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_2],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_3],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_4],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_5],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_6],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_7],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_8],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_9],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_EQUALS],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_SLASH],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_BACKSLASH],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_LEFTBRACKET],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_RIGHTBRACKET],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_BACKQUOTE],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_COMMA],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_COMMAND],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_MINUS],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_PERIOD],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_QUOTE],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_SEMICOLON],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_ANDROIDMENU],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_ANDROIDSEARCH],
								_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_UNKNOWN]
								])
							);

		return RNode(_xmlNodeTypeToNodeName[ENodeType.EVENT], [], l_children);
	}
}