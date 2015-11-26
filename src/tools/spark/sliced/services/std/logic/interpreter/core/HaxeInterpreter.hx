/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.interpreter.core;
import hscript.Parser;
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

import haxe.ds.StringMap;
import haxe.ds.IntMap;
import haxe.ds.ObjectMap;


/**
 * ...
 * @author Aris Kostakos
 */
class HaxeInterpreter implements IInterpreter
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
		_interpreter.variables.set("Key", Key); // share the Key enum
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
		
		//so bad..
		#if html
		_interpreter.variables.set("XMLHttpRequest", js.html.XMLHttpRequest); // share the XMLHttpRequest
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
	
	
	public function hash(script:String):Int
	{
		try
		{
			return _store(_parser.parseString(script), Crc32.make(Bytes.ofString(script)));
		}
		catch (e:Dynamic)
		{
			Console.error("<<<<<SPARK SCRIPT PARSING ERROR [Line: " + _parser.line + "]>>>>>: " + e);
			Console.error("Stack: " + script);
			
			var errorMsg:String = "Display.error('This script failed to parse. Look at stack above.'); CouldNotParseScript;";
			
			return _store(_parser.parseString(errorMsg), Crc32.make(Bytes.ofString(errorMsg)));
		}
	}
	
	
	inline private function _get(hashId:Int):Expr
	{
		var script:Expr = _hashTable[hashId];
		
		if (script == null)
			Console.error('Script not found on address [$hashId]');
		
		return script;
	}
	
	private function _store(script:Expr, hashId: Int):Int
	{
		if (_hashTable[hashId] != null)
		{
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
		}
		else
		{
			//Console.log('Entering hashId: [$hashId] with Script: $script');
			_hashTable[hashId] = script;
			return hashId;
		}
	}
}