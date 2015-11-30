/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.core;
import flambe.input.MouseButton;
import haxe.ds.IntMap;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap;
import tools.spark.framework.Assets;
import tools.spark.framework.assets.Asset;
import tools.spark.framework.assets.Module;
import tools.spark.framework.Project;
import tools.spark.sliced.interfaces.ISound;
import tools.spark.sliced.interfaces.ILogic;
import tools.spark.sliced.interfaces.IInput;
import tools.spark.sliced.interfaces.IComms;
import tools.spark.sliced.interfaces.IEvent;
import tools.spark.sliced.interfaces.IDisplay;
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventType;
import flambe.input.Key;

/**
 * ...
 * @author Aris Kostakos
 */
@:expose("Sliced") class Sliced
{
	public static var sound( default, null ):ISound;
	public static var logic( default, null ):ILogic;
	public static var input( default, null ):IInput;
	public static var comms( default, null ):IComms;
	public static var event( default, null ):IEvent;
	public static var display( default, null ):IDisplay;
	public static var dt( default, null ):Float;
	
	//There are references, so in scripting (in Js Interpreter for now) EVERYTHING goes through here.
	public static var _Std:Dynamic;
	public static var _StringMap:Dynamic;
	public static var _IntMap:Dynamic;
	public static var _ObjectMap:Dynamic;
	public static var _Assets:Dynamic;
	public static var _StringTools:Dynamic;
	public static var _Xml:Dynamic;
	public static var _MouseButton:Dynamic;
	public static var _EEventType:Dynamic;
	public static var _Key:Dynamic;
	public static var _Project:Dynamic;
	public static var _Module:Dynamic;
	public static var _Asset:Dynamic;
	
	
	public static function init():Void
	{
		//Create Service Factory (which will create S.L.I.C.E.D.)
		var l_serviceFactory:ServiceFactory = new ServiceFactory();
	}
	
	public static function assignServices(p_sound:ISound, p_logic:ILogic, p_input:IInput, p_comms:IComms, p_event:IEvent, p_display:IDisplay):Void
	{
		Console.log("Init Core (S.L.I.C.E.D.)...");
		sound = p_sound;
		logic = p_logic;
		input = p_input;
		comms = p_comms;
		event = p_event;
		display = p_display;
		_Std = Std;
		_StringMap = StringMap;
		_IntMap = IntMap;
		_ObjectMap = ObjectMap;
		_Assets = Assets;
		_StringTools = StringTools;
		_Xml = Xml;
		_MouseButton = MouseButton;
		_EEventType = EEventType;
		_Key = Key;
		_Project = Project;
		_Module = Module;
		_Asset = Asset;
	}
	
	//@todo: maybe inline all the update functions?
	inline public static function update(p_dt :Float):Void
	{
		//Update time value
		dt = p_dt;
		
		//Input Update
		Sliced.input.update();
		////Console.error("---------->Logic: EVENT update");
		//Event Update
		Sliced.event.update();
		//Console.error("---------->Logic: LOGIC update");
		//Logic Update
		Sliced.logic.update();
		
		//Display Update
		Sliced.display.update();
		
		//Comms Update
		Sliced.comms.update();
	}
}