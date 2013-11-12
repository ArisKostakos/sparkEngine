/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.services.std.logic.gde.core;
import co.gamep.framework.Assets;
import co.gamep.sliced.services.std.logic.gde.interfaces.EGameType;
import co.gamep.sliced.services.std.logic.gde.interfaces.ENodeType;
import co.gamep.sliced.services.std.logic.gde.interfaces.EConcurrencyType;
import co.gamep.sliced.services.std.logic.gde.interfaces.EStateType;
import co.gamep.sliced.services.std.logic.gde.interfaces.EEventPrefab;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameAction;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameClassInstantiator;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameClassParser;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameClassValidator;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameEntity;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameFactory;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameForm;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameSpace;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameState;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameTrigger;

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
	private var _xmlGameTypeToFileExtension:Map<EGameType,String>;
	private var _xmlConcurrencyTypeToName:Map<EConcurrencyType,String>;
	private var _xmlConcurrencyNameToType:Map<String,EConcurrencyType>;
	private var _xmlStateTypeToName:Map<EStateType,String>;
	private var _xmlStateNameToType:Map<String,EStateType>;
	private var _xmlEventPrefabToName:Map<EEventPrefab,String>;
	private var _xmlEventNameToPrefab:Map<String,EEventPrefab>;
	private var _isNodeExtendable:Map<ENodeType,Bool>;
	private var _isNodeMergable:Map<ENodeType,Bool>;
	private var _isNodeTargetMergable:Map<ENodeType,Bool>;
	private var _isNodeArray:Map<ENodeType,Bool>;
	
	inline static private var _XMLELEMENT_EXTENDS:String = "Extends";
	inline static private var _XMLATTRIBUTE_EXTENDS:String = "extends";
	
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
		_initFileExtensionsMap();
		_initExtendableNodesMap();
		_initMergableNodesMap();
		_initTargetMergableNodesMap();
		_initArrayNodesMap();
		_initConcurrencyTypeToNameMap();
		_initConcurrencyNameToTypeMap();
		_initStateTypeToNameMap();
		_initStateNameToTypeMap();
		_initEventPrefabToNameMap();
		_initEventNameToPrefabMap();
		_gameClassValidator = new GameClassValidator(_xmlNodeTypeToNodeName, _xmlConcurrencyTypeToName, _xmlStateTypeToName, _xmlEventPrefabToName);
		_gameClassInstantiator = new GameClassInstantiator(_xmlNodeTypeToNodeName, _xmlConcurrencyNameToType, _xmlStateNameToType, _xmlEventNameToPrefab);
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
		_xmlNodeTypeToNodeName[ENodeType.TRIGGERS] = "Triggers";
		_xmlNodeTypeToNodeName[ENodeType.TRIGGER] = "Trigger";
		_xmlNodeTypeToNodeName[ENodeType.EVENT] = "Event";
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
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.TRIGGERS]] = ENodeType.TRIGGERS;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.TRIGGER]] = ENodeType.TRIGGER;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.EVENT]] = ENodeType.EVENT;
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
		_isNodeExtendable[ENodeType.TRIGGERS] = false;
		_isNodeExtendable[ENodeType.TRIGGER] = true;
		_isNodeExtendable[ENodeType.EVENT] = false;
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
		_isNodeMergable[ENodeType.FORM] = true;
		_isNodeMergable[ENodeType.SCRIPTS] = true;
		_isNodeMergable[ENodeType.SCRIPT] = false;
		_isNodeMergable[ENodeType.TRIGGERS] = true;
		_isNodeMergable[ENodeType.TRIGGER] = false;
		_isNodeMergable[ENodeType.EVENT] = false;
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
		_isNodeTargetMergable[ENodeType.TRIGGERS] = false;
		_isNodeTargetMergable[ENodeType.TRIGGER] = false;
		_isNodeTargetMergable[ENodeType.EVENT] = false;
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
		_isNodeArray[ENodeType.TRIGGERS] = true;
		_isNodeArray[ENodeType.TRIGGER] = false;
		_isNodeArray[ENodeType.EVENT] = false;
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
		
		_xmlStateTypeToName[EStateType.DYNAMIC] = "Dynamic";
		_xmlStateTypeToName[EStateType.BOOLEAN] = "Boolean";
		_xmlStateTypeToName[EStateType.DECIMAL] = "Decimal";
		_xmlStateTypeToName[EStateType.INTEGER] = "Integer";
		_xmlStateTypeToName[EStateType.TEXT] = "Text";
	}
	
	private function _initStateNameToTypeMap():Void
	{
		_xmlStateNameToType = new Map<String,EStateType>();
		
		_xmlStateNameToType[_xmlStateTypeToName[EStateType.DYNAMIC]] = EStateType.DYNAMIC;
		_xmlStateNameToType[_xmlStateTypeToName[EStateType.BOOLEAN]] = EStateType.BOOLEAN;
		_xmlStateNameToType[_xmlStateTypeToName[EStateType.DECIMAL]] = EStateType.DECIMAL;
		_xmlStateNameToType[_xmlStateTypeToName[EStateType.INTEGER]] = EStateType.INTEGER;
		_xmlStateNameToType[_xmlStateTypeToName[EStateType.TEXT]] = EStateType.TEXT;
	}
	
	private function _initEventPrefabToNameMap():Void
	{
		_xmlEventPrefabToName = new Map<EEventPrefab,String>();
		
		_xmlEventPrefabToName[EEventPrefab.CREATED] = "Created";
		_xmlEventPrefabToName[EEventPrefab.UPDATE] = "Update";
		_xmlEventPrefabToName[EEventPrefab.MOUSE_LEFT_CLICK] = "MouseLeftClick";
		_xmlEventPrefabToName[EEventPrefab.MOUSE_RIGHT_CLICK] = "MouseRightClick";
		_xmlEventPrefabToName[EEventPrefab.MOUSE_LEFT_CLICKED] = "MouseLeftClicked";
		_xmlEventPrefabToName[EEventPrefab.MOUSE_RIGHT_CLICKED] = "MouseRightClicked";
		_xmlEventPrefabToName[EEventPrefab.MOUSE_OVER] = "MouseOver";
		_xmlEventPrefabToName[EEventPrefab.MOUSE_OUT] = "MouseOut";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED] = "KeyPressed";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED] = "KeyReleased";
				
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_ALT] = "KeyPressed_Alt";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_BACKSPACE] = "KeyPressed_Backspace";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_CAPS_LOCK] = "KeyPressed_Capslock";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_CONTROL] = "KeyPressed_Control";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_DELETE] = "KeyPressed_Delete";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_DOWN] = "KeyPressed_Down";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_END] = "KeyPressed_End";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_ENTER] = "KeyPressed_Enter";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_ESCAPE] = "KeyPressed_Escape";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F1] = "KeyPressed_F1";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F10] = "KeyPressed_F10";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F11] = "KeyPressed_F11";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F12] = "KeyPressed_F12";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F13] = "KeyPressed_F13";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F14] = "KeyPressed_F14";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F15] = "KeyPressed_F15";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F2] = "KeyPressed_F2";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F3] = "KeyPressed_F3";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F4] = "KeyPressed_F4";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F5] = "KeyPressed_F5";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F6] = "KeyPressed_F6";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F7] = "KeyPressed_F7";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F8] = "KeyPressed_F8";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F9] = "KeyPressed_F9";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_HOME] = "KeyPressed_Home";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_INSERT] = "KeyPressed_Insert";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_LEFT] = "KeyPressed_Left";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_0] = "KeyPressed_Num0";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_1] = "KeyPressed_Num1";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_2] = "KeyPressed_Num2";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_3] = "KeyPressed_Num3";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_4] = "KeyPressed_Num4";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_5] = "KeyPressed_Num5";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_6] = "KeyPressed_Num6";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_7] = "KeyPressed_Num7";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_8] = "KeyPressed_Num8";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_9] = "KeyPressed_Num9";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_ADD] = "KeyPressed_Add";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_DECIMAL] = "KeyPressed_Decimal";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_DIVIDE] = "KeyPressed_Divide";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_ENTER] = "KeyPressed_Enter";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_MULTIPLY] = "KeyPressed_Multiply";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_SUBTRACT] = "KeyPressed_Subtract";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_PAGE_DOWN] = "KeyPressed_Pagedown";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_PAGE_UP] = "KeyPressed_Pageup";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_RIGHT] = "KeyPressed_Right";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_SHIFT] = "KeyPressed_Shift";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_SPACE] = "KeyPressed_Space";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_TAB] = "KeyPressed_Tab";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_UP] = "KeyPressed_Up";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_A] = "KeyPressed_A";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_B] = "KeyPressed_B";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_C] = "KeyPressed_C";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_D] = "KeyPressed_D";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_E] = "KeyPressed_E";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F] = "KeyPressed_F";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_G] = "KeyPressed_G";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_H] = "KeyPressed_H";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_I] = "KeyPressed_I";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_J] = "KeyPressed_J";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_K] = "KeyPressed_K";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_L] = "KeyPressed_L";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_M] = "KeyPressed_M";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_N] = "KeyPressed_N";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_O] = "KeyPressed_O";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_P] = "KeyPressed_P";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_Q] = "KeyPressed_Q";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_R] = "KeyPressed_R";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_S] = "KeyPressed_S";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_T] = "KeyPressed_T";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_U] = "KeyPressed_U";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_V] = "KeyPressed_V";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_W] = "KeyPressed_W";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_X] = "KeyPressed_X";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_Y] = "KeyPressed_Y";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_Z] = "KeyPressed_Z";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_0] = "KeyPressed_0";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_1] = "KeyPressed_1";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_2] = "KeyPressed_2";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_3] = "KeyPressed_3";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_4] = "KeyPressed_4";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_5] = "KeyPressed_5";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_6] = "KeyPressed_6";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_7] = "KeyPressed_7";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_8] = "KeyPressed_8";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_9] = "KeyPressed_9";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_EQUALS] = "KeyPressed_Equals";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_SLASH] = "KeyPressed_Slash";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_BACKSLASH] = "KeyPressed_Backslash";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_LEFTBRACKET] = "KeyPressed_LeftBracket";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_RIGHTBRACKET] = "KeyPressed_RightBracket";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_BACKQUOTE] = "KeyPressed_Backquote";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_COMMA] = "KeyPressed_Comma";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_COMMAND] = "KeyPressed_Command";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_MINUS] = "KeyPressed_Minus";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_PERIOD] = "KeyPressed_Period";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_QUOTE] = "KeyPressed_Quote";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_SEMICOLON] = "KeyPressed_Semicolon";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_ANDROIDMENU] = "KeyPressed_AndroidMenu";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_ANDROIDSEARCH] = "KeyPressed_AndroidSearch";
		_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_UNKNOWN] = "KeyPressed_Unknown";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_ALT] = "KeyReleased_Alt";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_BACKSPACE] = "KeyReleased_Backspace";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_CAPS_LOCK] = "KeyReleased_Capslock";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_CONTROL] = "KeyReleased_Control";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_DELETE] = "KeyReleased_Delete";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_DOWN] = "KeyReleased_Down";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_END] = "KeyReleased_End";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_ENTER] = "KeyReleased_Enter";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_ESCAPE] = "KeyReleased_Escape";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F1] = "KeyReleased_F1";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F10] = "KeyReleased_F10";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F11] = "KeyReleased_F11";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F12] = "KeyReleased_F12";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F13] = "KeyReleased_F13";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F14] = "KeyReleased_F14";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F15] = "KeyReleased_F15";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F2] = "KeyReleased_F2";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F3] = "KeyReleased_F3";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F4] = "KeyReleased_F4";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F5] = "KeyReleased_F5";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F6] = "KeyReleased_F6";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F7] = "KeyReleased_F7";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F8] = "KeyReleased_F8";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F9] = "KeyReleased_F9";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_HOME] = "KeyReleased_Home";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_INSERT] = "KeyReleased_Insert";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_LEFT] = "KeyReleased_Left";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_0] = "KeyReleased_Num0";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_1] = "KeyReleased_Num1";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_2] = "KeyReleased_Num2";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_3] = "KeyReleased_Num3";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_4] = "KeyReleased_Num4";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_5] = "KeyReleased_Num5";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_6] = "KeyReleased_Num6";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_7] = "KeyReleased_Num7";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_8] = "KeyReleased_Num8";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_9] = "KeyReleased_Num9";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_ADD] = "KeyReleased_Add";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_DECIMAL] = "KeyReleased_Decimal";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_DIVIDE] = "KeyReleased_Divide";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_ENTER] = "KeyReleased_Enter";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_MULTIPLY] = "KeyReleased_Multiply";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_SUBTRACT] = "KeyReleased_Subtract";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_PAGE_DOWN] = "KeyReleased_Pagedown";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_PAGE_UP] = "KeyReleased_Pageup";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_RIGHT] = "KeyReleased_Right";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_SHIFT] = "KeyReleased_Shift";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_SPACE] = "KeyReleased_Space";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_TAB] = "KeyReleased_Tab";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_UP] = "KeyReleased_Up";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_A] = "KeyReleased_A";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_B] = "KeyReleased_B";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_C] = "KeyReleased_C";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_D] = "KeyReleased_D";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_E] = "KeyReleased_E";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F] = "KeyReleased_F";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_G] = "KeyReleased_G";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_H] = "KeyReleased_H";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_I] = "KeyReleased_I";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_J] = "KeyReleased_J";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_K] = "KeyReleased_K";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_L] = "KeyReleased_L";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_M] = "KeyReleased_M";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_N] = "KeyReleased_N";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_O] = "KeyReleased_O";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_P] = "KeyReleased_P";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_Q] = "KeyReleased_Q";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_R] = "KeyReleased_R";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_S] = "KeyReleased_S";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_T] = "KeyReleased_T";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_U] = "KeyReleased_U";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_V] = "KeyReleased_V";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_W] = "KeyReleased_W";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_X] = "KeyReleased_X";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_Y] = "KeyReleased_Y";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_Z] = "KeyReleased_Z";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_0] = "KeyReleased_0";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_1] = "KeyReleased_1";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_2] = "KeyReleased_2";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_3] = "KeyReleased_3";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_4] = "KeyReleased_4";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_5] = "KeyReleased_5";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_6] = "KeyReleased_6";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_7] = "KeyReleased_7";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_8] = "KeyReleased_8";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_9] = "KeyReleased_9";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_EQUALS] = "KeyReleased_Equals";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_SLASH] = "KeyReleased_Slash";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_BACKSLASH] = "KeyReleased_Backslash";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_LEFTBRACKET] = "KeyReleased_LeftBracket";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_RIGHTBRACKET] = "KeyReleased_RightBracket";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_BACKQUOTE] = "KeyReleased_Backquote";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_COMMA] = "KeyReleased_Comma";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_COMMAND] = "KeyReleased_Command";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_MINUS] = "KeyReleased_Minus";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_PERIOD] = "KeyReleased_Period";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_QUOTE] = "KeyReleased_Quote";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_SEMICOLON] = "KeyReleased_Semicolon";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_ANDROIDMENU] = "KeyReleased_AndroidMenu";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_ANDROIDSEARCH] = "KeyReleased_AndroidSearch";
		_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_UNKNOWN] = "KeyReleased_Unknown";
	}
	
	private function _initEventNameToPrefabMap():Void
	{
		_xmlEventNameToPrefab = new Map<String,EEventPrefab>();
		
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.CREATED]] = EEventPrefab.CREATED;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.UPDATE]] = EEventPrefab.UPDATE;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.MOUSE_LEFT_CLICK]] = EEventPrefab.MOUSE_LEFT_CLICK;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.MOUSE_RIGHT_CLICK]] = EEventPrefab.MOUSE_RIGHT_CLICK;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.MOUSE_LEFT_CLICKED]] = EEventPrefab.MOUSE_LEFT_CLICKED;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.MOUSE_RIGHT_CLICKED]] = EEventPrefab.MOUSE_RIGHT_CLICKED;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.MOUSE_OVER]] = EEventPrefab.MOUSE_OVER;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.MOUSE_OUT]] = EEventPrefab.MOUSE_OUT;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED]] = EEventPrefab.KEY_PRESSED;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED]] = EEventPrefab.KEY_RELEASED;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_ALT]] = EEventPrefab.KEY_PRESSED_ALT;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_BACKSPACE]] = EEventPrefab.KEY_PRESSED_BACKSPACE;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_CAPS_LOCK]] = EEventPrefab.KEY_PRESSED_CAPS_LOCK;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_CONTROL]] = EEventPrefab.KEY_PRESSED_CONTROL;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_DELETE]] = EEventPrefab.KEY_PRESSED_DELETE;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_DOWN]] = EEventPrefab.KEY_PRESSED_DOWN;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_END]] = EEventPrefab.KEY_PRESSED_END;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_ENTER]] = EEventPrefab.KEY_PRESSED_ENTER;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_ESCAPE]] = EEventPrefab.KEY_PRESSED_ESCAPE;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F1]] = EEventPrefab.KEY_PRESSED_F1;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F10]] = EEventPrefab.KEY_PRESSED_F10;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F11]] = EEventPrefab.KEY_PRESSED_F11;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F12]] = EEventPrefab.KEY_PRESSED_F12;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F13]] = EEventPrefab.KEY_PRESSED_F13;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F14]] = EEventPrefab.KEY_PRESSED_F14;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F15]] = EEventPrefab.KEY_PRESSED_F15;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F2]] = EEventPrefab.KEY_PRESSED_F2;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F3]] = EEventPrefab.KEY_PRESSED_F3;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F4]] = EEventPrefab.KEY_PRESSED_F4;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F5]] = EEventPrefab.KEY_PRESSED_F5;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F6]] = EEventPrefab.KEY_PRESSED_F6;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F7]] = EEventPrefab.KEY_PRESSED_F7;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F8]] = EEventPrefab.KEY_PRESSED_F8;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F9]] = EEventPrefab.KEY_PRESSED_F9;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_HOME]] = EEventPrefab.KEY_PRESSED_HOME;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_INSERT]] = EEventPrefab.KEY_PRESSED_INSERT;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_LEFT]] = EEventPrefab.KEY_PRESSED_LEFT;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_0]] = EEventPrefab.KEY_PRESSED_NUMPAD_0;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_1]] = EEventPrefab.KEY_PRESSED_NUMPAD_1;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_2]] = EEventPrefab.KEY_PRESSED_NUMPAD_2;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_3]] = EEventPrefab.KEY_PRESSED_NUMPAD_3;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_4]] = EEventPrefab.KEY_PRESSED_NUMPAD_4;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_5]] = EEventPrefab.KEY_PRESSED_NUMPAD_5;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_6]] = EEventPrefab.KEY_PRESSED_NUMPAD_6;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_7]] = EEventPrefab.KEY_PRESSED_NUMPAD_7;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_8]] = EEventPrefab.KEY_PRESSED_NUMPAD_8;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_9]] = EEventPrefab.KEY_PRESSED_NUMPAD_9;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_ADD]] = EEventPrefab.KEY_PRESSED_NUMPAD_ADD;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_DECIMAL]] = EEventPrefab.KEY_PRESSED_NUMPAD_DECIMAL;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_DIVIDE]] = EEventPrefab.KEY_PRESSED_NUMPAD_DIVIDE;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_ENTER]] = EEventPrefab.KEY_PRESSED_NUMPAD_ENTER;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_MULTIPLY]] = EEventPrefab.KEY_PRESSED_NUMPAD_MULTIPLY;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMPAD_SUBTRACT]] = EEventPrefab.KEY_PRESSED_NUMPAD_SUBTRACT;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_PAGE_DOWN]] = EEventPrefab.KEY_PRESSED_PAGE_DOWN;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_PAGE_UP]] = EEventPrefab.KEY_PRESSED_PAGE_UP;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_RIGHT]] = EEventPrefab.KEY_PRESSED_RIGHT;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_SHIFT]] = EEventPrefab.KEY_PRESSED_SHIFT;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_SPACE]] = EEventPrefab.KEY_PRESSED_SPACE;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_TAB]] = EEventPrefab.KEY_PRESSED_TAB;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_UP]] = EEventPrefab.KEY_PRESSED_UP;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_A]] = EEventPrefab.KEY_PRESSED_A;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_B]] = EEventPrefab.KEY_PRESSED_B;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_C]] = EEventPrefab.KEY_PRESSED_C;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_D]] = EEventPrefab.KEY_PRESSED_D;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_E]] = EEventPrefab.KEY_PRESSED_E;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_F]] = EEventPrefab.KEY_PRESSED_F;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_G]] = EEventPrefab.KEY_PRESSED_G;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_H]] = EEventPrefab.KEY_PRESSED_H;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_I]] = EEventPrefab.KEY_PRESSED_I;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_J]] = EEventPrefab.KEY_PRESSED_J;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_K]] = EEventPrefab.KEY_PRESSED_K;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_L]] = EEventPrefab.KEY_PRESSED_L;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_M]] = EEventPrefab.KEY_PRESSED_M;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_N]] = EEventPrefab.KEY_PRESSED_N;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_O]] = EEventPrefab.KEY_PRESSED_O;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_P]] = EEventPrefab.KEY_PRESSED_P;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_Q]] = EEventPrefab.KEY_PRESSED_Q;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_R]] = EEventPrefab.KEY_PRESSED_R;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_S]] = EEventPrefab.KEY_PRESSED_S;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_T]] = EEventPrefab.KEY_PRESSED_T;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_U]] = EEventPrefab.KEY_PRESSED_U;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_V]] = EEventPrefab.KEY_PRESSED_V;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_W]] = EEventPrefab.KEY_PRESSED_W;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_X]] = EEventPrefab.KEY_PRESSED_X;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_Y]] = EEventPrefab.KEY_PRESSED_Y;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_Z]] = EEventPrefab.KEY_PRESSED_Z;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_0]] = EEventPrefab.KEY_PRESSED_NUMBER_0;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_1]] = EEventPrefab.KEY_PRESSED_NUMBER_1;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_2]] = EEventPrefab.KEY_PRESSED_NUMBER_2;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_3]] = EEventPrefab.KEY_PRESSED_NUMBER_3;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_4]] = EEventPrefab.KEY_PRESSED_NUMBER_4;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_5]] = EEventPrefab.KEY_PRESSED_NUMBER_5;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_6]] = EEventPrefab.KEY_PRESSED_NUMBER_6;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_7]] = EEventPrefab.KEY_PRESSED_NUMBER_7;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_8]] = EEventPrefab.KEY_PRESSED_NUMBER_8;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_NUMBER_9]] = EEventPrefab.KEY_PRESSED_NUMBER_9;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_EQUALS]] = EEventPrefab.KEY_PRESSED_EQUALS;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_SLASH]] = EEventPrefab.KEY_PRESSED_SLASH;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_BACKSLASH]] = EEventPrefab.KEY_PRESSED_BACKSLASH;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_LEFTBRACKET]] = EEventPrefab.KEY_PRESSED_LEFTBRACKET;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_RIGHTBRACKET]] = EEventPrefab.KEY_PRESSED_RIGHTBRACKET;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_BACKQUOTE]] = EEventPrefab.KEY_PRESSED_BACKQUOTE;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_COMMA]] = EEventPrefab.KEY_PRESSED_COMMA;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_COMMAND]] = EEventPrefab.KEY_PRESSED_COMMAND;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_MINUS]] = EEventPrefab.KEY_PRESSED_MINUS;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_PERIOD]] = EEventPrefab.KEY_PRESSED_PERIOD;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_QUOTE]] = EEventPrefab.KEY_PRESSED_QUOTE;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_SEMICOLON]] = EEventPrefab.KEY_PRESSED_SEMICOLON;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_ANDROIDMENU]] = EEventPrefab.KEY_PRESSED_ANDROIDMENU;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_ANDROIDSEARCH]] = EEventPrefab.KEY_PRESSED_ANDROIDSEARCH;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_PRESSED_UNKNOWN]] = EEventPrefab.KEY_PRESSED_UNKNOWN;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_ALT]] = EEventPrefab.KEY_RELEASED_ALT;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_BACKSPACE]] = EEventPrefab.KEY_RELEASED_BACKSPACE;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_CAPS_LOCK]] = EEventPrefab.KEY_RELEASED_CAPS_LOCK;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_CONTROL]] = EEventPrefab.KEY_RELEASED_CONTROL;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_DELETE]] = EEventPrefab.KEY_RELEASED_DELETE;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_DOWN]] = EEventPrefab.KEY_RELEASED_DOWN;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_END]] = EEventPrefab.KEY_RELEASED_END;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_ENTER]] = EEventPrefab.KEY_RELEASED_ENTER;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_ESCAPE]] = EEventPrefab.KEY_RELEASED_ESCAPE;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F1]] = EEventPrefab.KEY_RELEASED_F1;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F10]] = EEventPrefab.KEY_RELEASED_F10;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F11]] = EEventPrefab.KEY_RELEASED_F11;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F12]] = EEventPrefab.KEY_RELEASED_F12;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F13]] = EEventPrefab.KEY_RELEASED_F13;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F14]] = EEventPrefab.KEY_RELEASED_F14;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F15]] = EEventPrefab.KEY_RELEASED_F15;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F2]] = EEventPrefab.KEY_RELEASED_F2;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F3]] = EEventPrefab.KEY_RELEASED_F3;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F4]] = EEventPrefab.KEY_RELEASED_F4;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F5]] = EEventPrefab.KEY_RELEASED_F5;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F6]] = EEventPrefab.KEY_RELEASED_F6;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F7]] = EEventPrefab.KEY_RELEASED_F7;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F8]] = EEventPrefab.KEY_RELEASED_F8;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F9]] = EEventPrefab.KEY_RELEASED_F9;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_HOME]] = EEventPrefab.KEY_RELEASED_HOME;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_INSERT]] = EEventPrefab.KEY_RELEASED_INSERT;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_LEFT]] = EEventPrefab.KEY_RELEASED_LEFT;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_0]] = EEventPrefab.KEY_RELEASED_NUMPAD_0;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_1]] = EEventPrefab.KEY_RELEASED_NUMPAD_1;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_2]] = EEventPrefab.KEY_RELEASED_NUMPAD_2;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_3]] = EEventPrefab.KEY_RELEASED_NUMPAD_3;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_4]] = EEventPrefab.KEY_RELEASED_NUMPAD_4;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_5]] = EEventPrefab.KEY_RELEASED_NUMPAD_5;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_6]] = EEventPrefab.KEY_RELEASED_NUMPAD_6;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_7]] = EEventPrefab.KEY_RELEASED_NUMPAD_7;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_8]] = EEventPrefab.KEY_RELEASED_NUMPAD_8;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_9]] = EEventPrefab.KEY_RELEASED_NUMPAD_9;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_ADD]] = EEventPrefab.KEY_RELEASED_NUMPAD_ADD;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_DECIMAL]] = EEventPrefab.KEY_RELEASED_NUMPAD_DECIMAL;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_DIVIDE]] = EEventPrefab.KEY_RELEASED_NUMPAD_DIVIDE;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_ENTER]] = EEventPrefab.KEY_RELEASED_NUMPAD_ENTER;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_MULTIPLY]] = EEventPrefab.KEY_RELEASED_NUMPAD_MULTIPLY;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMPAD_SUBTRACT]] = EEventPrefab.KEY_RELEASED_NUMPAD_SUBTRACT;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_PAGE_DOWN]] = EEventPrefab.KEY_RELEASED_PAGE_DOWN;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_PAGE_UP]] = EEventPrefab.KEY_RELEASED_PAGE_UP;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_RIGHT]] = EEventPrefab.KEY_RELEASED_RIGHT;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_SHIFT]] = EEventPrefab.KEY_RELEASED_SHIFT;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_SPACE]] = EEventPrefab.KEY_RELEASED_SPACE;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_TAB]] = EEventPrefab.KEY_RELEASED_TAB;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_UP]] = EEventPrefab.KEY_RELEASED_UP;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_A]] = EEventPrefab.KEY_RELEASED_A;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_B]] = EEventPrefab.KEY_RELEASED_B;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_C]] = EEventPrefab.KEY_RELEASED_C;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_D]] = EEventPrefab.KEY_RELEASED_D;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_E]] = EEventPrefab.KEY_RELEASED_E;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_F]] = EEventPrefab.KEY_RELEASED_F;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_G]] = EEventPrefab.KEY_RELEASED_G;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_H]] = EEventPrefab.KEY_RELEASED_H;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_I]] = EEventPrefab.KEY_RELEASED_I;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_J]] = EEventPrefab.KEY_RELEASED_J;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_K]] = EEventPrefab.KEY_RELEASED_K;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_L]] = EEventPrefab.KEY_RELEASED_L;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_M]] = EEventPrefab.KEY_RELEASED_M;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_N]] = EEventPrefab.KEY_RELEASED_N;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_O]] = EEventPrefab.KEY_RELEASED_O;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_P]] = EEventPrefab.KEY_RELEASED_P;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_Q]] = EEventPrefab.KEY_RELEASED_Q;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_R]] = EEventPrefab.KEY_RELEASED_R;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_S]] = EEventPrefab.KEY_RELEASED_S;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_T]] = EEventPrefab.KEY_RELEASED_T;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_U]] = EEventPrefab.KEY_RELEASED_U;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_V]] = EEventPrefab.KEY_RELEASED_V;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_W]] = EEventPrefab.KEY_RELEASED_W;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_X]] = EEventPrefab.KEY_RELEASED_X;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_Y]] = EEventPrefab.KEY_RELEASED_Y;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_Z]] = EEventPrefab.KEY_RELEASED_Z;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_0]] = EEventPrefab.KEY_RELEASED_NUMBER_0;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_1]] = EEventPrefab.KEY_RELEASED_NUMBER_1;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_2]] = EEventPrefab.KEY_RELEASED_NUMBER_2;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_3]] = EEventPrefab.KEY_RELEASED_NUMBER_3;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_4]] = EEventPrefab.KEY_RELEASED_NUMBER_4;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_5]] = EEventPrefab.KEY_RELEASED_NUMBER_5;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_6]] = EEventPrefab.KEY_RELEASED_NUMBER_6;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_7]] = EEventPrefab.KEY_RELEASED_NUMBER_7;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_8]] = EEventPrefab.KEY_RELEASED_NUMBER_8;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_NUMBER_9]] = EEventPrefab.KEY_RELEASED_NUMBER_9;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_EQUALS]] = EEventPrefab.KEY_RELEASED_EQUALS;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_SLASH]] = EEventPrefab.KEY_RELEASED_SLASH;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_BACKSLASH]] = EEventPrefab.KEY_RELEASED_BACKSLASH;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_LEFTBRACKET]] = EEventPrefab.KEY_RELEASED_LEFTBRACKET;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_RIGHTBRACKET]] = EEventPrefab.KEY_RELEASED_RIGHTBRACKET;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_BACKQUOTE]] = EEventPrefab.KEY_RELEASED_BACKQUOTE;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_COMMA]] = EEventPrefab.KEY_RELEASED_COMMA;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_COMMAND]] = EEventPrefab.KEY_RELEASED_COMMAND;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_MINUS]] = EEventPrefab.KEY_RELEASED_MINUS;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_PERIOD]] = EEventPrefab.KEY_RELEASED_PERIOD;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_QUOTE]] = EEventPrefab.KEY_RELEASED_QUOTE;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_SEMICOLON]] = EEventPrefab.KEY_RELEASED_SEMICOLON;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_ANDROIDMENU]] = EEventPrefab.KEY_RELEASED_ANDROIDMENU;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_ANDROIDSEARCH]] = EEventPrefab.KEY_RELEASED_ANDROIDSEARCH;
		_xmlEventNameToPrefab[_xmlEventPrefabToName[EEventPrefab.KEY_RELEASED_UNKNOWN]] = EEventPrefab.KEY_RELEASED_UNKNOWN;
	}
	
	
	//METHODS
	
	//Parser
	public function parseGameNode(p_gameNode:Xml):Bool
	{
		//extend
		Console.info('Extending ' + p_gameNode.nodeName + ' Node...');
		if (_extendGameNode(p_gameNode))
		{
			//Display the full Node after extending it
			//Console.debug(p_gameNode);
			Console.info('Extending ' + p_gameNode.nodeName + ' Node COMPLETED');
			
			//merge
			Console.info('Merging ' + p_gameNode.nodeName + ' Node...');
			_mergeGameNode(p_gameNode);

			//Display the full Node after merging it
			//Console.debug(p_gameNode);
			Console.info('Merging ' + p_gameNode.nodeName + ' Node COMPLETED');
			
			//Validate
			Console.info('Validating ' + p_gameNode.nodeName + ' Node...');
			if (_validateGameNode(p_gameNode))
			{
				//Display the full Node after validating it
				//Console.debug(p_gameNode);
				Console.info('Validating ' + p_gameNode.nodeName + ' Node COMPLETED');
				
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
			return Xml.parse(Assets.lionscript.getFile(p_stringAssetUrl).toString());
		}
		catch (err:Dynamic) 
		{
			Console.error(Std.string(err));
			return null;
		}
	}

	inline private function _getClassUrl(p_gameEntityClassName:String, p_fileExtension:String):String
	{
		return StringTools.replace(p_gameEntityClassName,".","/") + "." + p_fileExtension;
	}
	
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
			l_gameClassNode = _parseEmbeddedStringAsset(_getClassUrl(p_gameClassName, _xmlGameTypeToFileExtension[p_expectedGameType]));

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
			Console.error('Class $p_expectedGameType is not well-formed or not found!');
			return null;
		}
	}
}