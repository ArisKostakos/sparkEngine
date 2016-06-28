/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.interpreter.core;
import flambe.System;
import flambe.animation.Ease;
import flambe.animation.Tween;
import flambe.asset.AssetEntry.AssetFormat;
import tools.spark.framework.assets.Asset;
import tools.spark.framework.assets.EModuleState;
import tools.spark.framework.assets.Module;
import tools.spark.framework.ModuleManager;
import tools.spark.framework.Project;
import tools.spark.sliced.core.Sliced;
import flambe.input.Key;
import hscript.Expr;
import haxe.io.Bytes;
import haxe.crypto.Crc32;
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventType;
import tools.spark.sliced.services.std.logic.interpreter.interfaces.IInterpreter;
import tools.spark.framework.Framework;
import tools.spark.framework.Assets;
import haxe.xml.Fast;
import EReg;
import flambe.input.MouseButton;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameBase;

import haxe.ds.StringMap;
import haxe.ds.IntMap;
import haxe.ds.ObjectMap;


/**
 * ...
 * @author Aris Kostakos
 */
@:keep class HaxeInterpreter implements IInterpreter
{
	private var _hashTable:Map<Int,Expr>;
	private var _parser:Parser;
	private var _interpreter:Interp;
	
	public function new() 
	{
		Console.log("Init Haxe Interpreter...");
		_init();
	}
	
	private function _init():Void
	{
		//Here we use somethings for no other reason than to prevent DCE to eliminate the classes. We want to include them so they can be reflected with the interprenter
		var dummy:Int = Std.random(1);
		var dummy2:Dynamic = System.storage;
		dummy2 = System.storage.supported;
		dummy2 = System.storage.clear;
		dummy2 = System.storage.get; dummy2 = System.storage.remove; dummy2 = System.storage.set; dummy2 = Ease.backIn; dummy2 = Ease.backInOut; dummy2 = Ease.backOut;
		dummy2 = Ease.bounceIn; dummy2 = Ease.bounceInOut; dummy2 = Ease.bounceOut; dummy2 = Ease.circIn; dummy2 = Ease.circInOut; dummy2 = Ease.circOut; dummy2 = Ease.circOutIn;
		dummy2 = Ease.cubeIn; dummy2 = Ease.cubeInOut; dummy2 = Ease.cubeOut; dummy2 = Ease.cubeOutIn; dummy2 = Ease.elasticIn; dummy2 = Ease.elasticInOut; dummy2 = Ease.elasticOut;
		dummy2 = Ease.expoIn; dummy2 = Ease.expoInOut; dummy2 = Ease.expoOut; dummy2 = Ease.expoOutIn; dummy2 = Ease.linear; dummy2 = Ease.quadIn; dummy2 = Ease.quadInOut;
		dummy2 = Ease.quadOut; dummy2 = Ease.quadOutIn; dummy2 = Ease.quartIn; dummy2 = Ease.quartInOut; dummy2 = Ease.quartOut; dummy2 = Ease.quartOutIn; dummy2 = Ease.quintIn;
		dummy2 = Ease.quintInOut; dummy2 = Ease.quintOut; dummy2 = Ease.quintOutIn; dummy2 = Ease.sineIn; dummy2 = Ease.sineInOut; dummy2 = Ease.sineOut; dummy2 = Ease.sineOutIn;
		//end of DCE prevention
		
		_hashTable = new Map<Int,Expr>();
		
		_parser =  new Parser();
		_interpreter = new Interp();
		
		
		//Static variables
		_interpreter.variables.set("Game", Sliced); // share the Game class
		_interpreter.variables.set("Sound", Sliced.sound); // share the Sound class
		_interpreter.variables.set("Logic", Sliced.logic); // share the Logic class
		_interpreter.variables.set("Input", Sliced.input); // share the Input class
		_interpreter.variables.set("Comms", Sliced.comms); // share the Comms class
		_interpreter.variables.set("Event", Sliced.event); // share the Event class
		_interpreter.variables.set("Display", Sliced.display); // share the Display class
		
		_interpreter.variables.set("Project", Project); // share the Project class
		_interpreter.variables.set("Module", Module); // share the Module class
		_interpreter.variables.set("Asset", Asset); // share the Asset class
		_interpreter.variables.set("AssetFormat", AssetFormat); // share the AssetFormat class
		
		
		_interpreter.variables.set("Key", Key); // share the Key enum
		_interpreter.variables.set("Ease", Ease); // share the Ease enum
		_interpreter.variables.set("Console", Console); // share the Console
		_interpreter.variables.set("Math", Math); // share the Math
		_interpreter.variables.set("Std", Std); // share the Std
		_interpreter.variables.set("String", String); // share the String
		//_interpreter.variables.set("Framework", Framework); // share the Framework class
		_interpreter.variables.set("Assets", Assets); // share the Assets class
		_interpreter.variables.set("Xml", Xml); // share the Xml class
		_interpreter.variables.set("Fast", Fast); // share the Fast class
		_interpreter.variables.set("StringTools", StringTools); // share the StringTools class
		_interpreter.variables.set("EReg", EReg); // share the EReg class
		_interpreter.variables.set("MouseButton", MouseButton); // share the MouseButton class
		//_interpreter.variables.set("Int", Int); // share the Int
		_interpreter.variables.set("StringMap", StringMap); // share the StringMap
		_interpreter.variables.set("IntMap", IntMap); // share the IntMap
		_interpreter.variables.set("ObjectMap", ObjectMap); // share the ObjectMap
		_interpreter.variables.set("EEventType", EEventType); // share the EEventType
		_interpreter.variables.set("EModuleState", EModuleState); // share the EModuleState
		_interpreter.variables.set("System", System); // share the System
		_interpreter.variables.set("ModuleManager", ModuleManager); // share the ModuleManager
		_interpreter.variables.set("Tween", Tween); // share the Tween
		
		//Shortcuts
		_interpreter.variables.set("expr", runExpr);
		_interpreter.variables.set("e", Sliced.logic.getEntityByName);
		_interpreter.variables.set("query", Sliced.logic.queryGameEntity);
		_interpreter.variables.set("string", Std.string);
		
		//so bad..
		#if html
		_interpreter.variables.set("XMLHttpRequest", js.html.XMLHttpRequest); // share the XMLHttpRequest
		_interpreter.variables.set("window", js.Browser.window); // share the window
		#end
	}
	
	public function run(hashId:Int, parameters:Map<String,Dynamic>):Bool
	{
		var program:Expr = _get(hashId);
		
		//Dynamic Variables
		for (varName in parameters.keys())
		{
			_interpreter.setVariableSafe(varName, parameters[varName]);
		}
		
		//Console.warn("Interpenter Executing: " + hashId);
		try
		{
			//We keep this, for much later when we do real js parsing and this returns a function we can just execute instead of running interprenter again and again
			var returnedValue:Dynamic = _interpreter.execute(program);
			
			return true;
		}
		catch (e:Dynamic)
		{
			Console.error("<<<<<SPARK SCRIPT RUN-TIME ERROR>>>>>: " + e);
			
			return false;
		}
	}
	
	
	public function runExpr(hashId:Int, ?p_me:IGameBase, ?p_parent:IGameBase, ?p_it:IGameBase):Dynamic
	{
		var program:Expr = _get(hashId);
		
		//Dynamic Variables
		_interpreter.setVariableSafe("me", p_me);
		_interpreter.setVariableSafe("parent", p_parent);
		_interpreter.setVariableSafe("it", p_it);
		
		try
		{
			return _interpreter.execute(program);
		}
		catch (e:Dynamic)
		{
			Console.error("<<<<<SPARK EXPRESSION RUN-TIME ERROR>>>>>: " + e);
			
			return null;
		}
	}
	
	public function hashExpr(script:String):Int
	{
		var l_script:String = "var _returnExpr = " + script + "; _returnExpr;";
		
		return _store(l_script, Crc32.make(Bytes.ofString(l_script)));
	}
	
	public function hash(script:String):Int
	{
		return _store(script, Crc32.make(Bytes.ofString(script)));
	}
	
	
	inline private function _get(hashId:Int):Expr
	{
		var script:Expr = _hashTable[hashId];
		
		if (script == null)
			Console.error('Script not found on address [$hashId]');
		
		return script;
	}
	
	private function _store(script:String, hashId: Int):Int
	{
		if (_hashTable[hashId] != null)
		{
			/*
			if (Std.string(script) == Std.string(_hashTable[hashId]))
			{
				//Console.log('Same Script found: [$script] in hashId: [$hashId]');
				return hashId;
			}
			else
			{
				Console.warn('Collision detected with hashId: [$hashId] and script [$script]. Previous Stored Entry Script: ' + _hashTable[hashId]);
				return _store(script, ++hashId);
			}
			*/
			return hashId;
		}
		else
		{
			//Console.log('Entering hashId: [$hashId] with Script: $script');
			
			try
			{
				_hashTable[hashId] = _parser.parseString(script);
				return hashId;
			}
			catch (e:Dynamic)
			{
				Console.error("<<<<<SPARK SCRIPT PARSING ERROR [Line: " + _parser.line + "]>>>>>: " + e);
				Console.error("Stack: " + script);
				return hashId; //it will occur a MISSING SCRIPT MSG when tried to execute i think.. which is good enough..
				
				//var errorMsg:String = "Display.error('This script failed to parse. Look at stack above.'); CouldNotParseScript;";
				//return _store(_parser.parseString(errorMsg), Crc32.make(Bytes.ofString(errorMsg)));
			}
		}
	}
}