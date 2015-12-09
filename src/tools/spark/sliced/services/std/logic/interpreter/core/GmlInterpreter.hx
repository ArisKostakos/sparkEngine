/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.interpreter.core;
import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameBase;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import flambe.input.Key;
import haxe.io.Bytes;
import haxe.crypto.Crc32;
import tools.spark.sliced.services.std.logic.interpreter.interfaces.IInterpreter;

/**
 * ...
 * @author Aris Kostakos
 */
class GmlInterpreter implements IInterpreter
{
	private var _hashTable:Map<Int,String>;
	//private var _parser:Parser;
	//private var _interpreter:Interp;
	
	public function new() 
	{
		Console.log("Init Gml Interpreter...");
		_init();
	}
	
	private function _init():Void
	{
		_hashTable = new Map<Int,String>();
		
		//_parser =  new hscript.Parser();
		//_interpreter = new hscript.Interp();
		
		/*
		//Static variables
		_interpreter.variables.set("Game", Sliced); // share the Game class
		_interpreter.variables.set("Sound", Sliced.sound); // share the Sound class
		_interpreter.variables.set("Logic", Sliced.logic); // share the Logic class
		_interpreter.variables.set("Input", Sliced.input); // share the Input class
		_interpreter.variables.set("Comms", Sliced.comms); // share the Comms class
		_interpreter.variables.set("Display", Sliced.display); // share the Display class
		_interpreter.variables.set("Key", Key); // share the Key enum
		_interpreter.variables.set("Console", Console); // share the Console
		_interpreter.variables.set("Math", Math); // share the Math
		_interpreter.variables.set("Std", Std); // share the Std
		//_interpreter.variables.set("Int", Int); // share the Int
		*/
	}
	
	public function runExpr(hashId:Int, ?p_me:IGameBase, ?p_parent:IGameBase, ?p_it:IGameBase):Dynamic
	{
		//dummy
		return null;
	}
	
	public function hashExpr(script:String):Int
	{
		//dummy
		return null;
	}
	
	public function run(hashId:Int, parameters:Map<String,Dynamic>):Bool
	{
		//@todo: V.EASY/IMPORTANT/ASAP: don't create a new parser and interpenter EVERY SINGLE TIME!!!!
		//Console.time("interpreting");
		
		//@todo: PARSE EVERYTHING IN THE HASH ONCE AND STORE DUMMY!
		var program:String = _get(hashId);
		
		/*
		//_interpreter = new hscript.Interp();
		//Static variables
		_interpreter.variables.set("Game", Sliced); // share the Game class
		_interpreter.variables.set("Sound", Sliced.sound); // share the Sound class
		_interpreter.variables.set("Logic", Sliced.logic); // share the Logic class
		_interpreter.variables.set("Input", Sliced.input); // share the Input class
		_interpreter.variables.set("Comms", Sliced.comms); // share the Comms class
		_interpreter.variables.set("Display", Sliced.display); // share the Display class
		_interpreter.variables.set("Key", Key); // share the Key enum
		_interpreter.variables.set("Console", Console); // share the Console
		_interpreter.variables.set("Math", Math); // share the Math
		_interpreter.variables.set("Std", Std); // share the Std
		//_interpreter.variables.set("Int", Int); // share the Int
		
		//Dynamic Variables
		for (varName in parameters.keys())
		{
			_interpreter.variables.set(varName, parameters[varName]);
		}
		*/
		//Console.timeEnd("interpreting");
		//Console.warn("Interpenter Executing: " + hashId);
		
		//return _interpreter.execute(program);
		_deleteMeCircleAround(parameters["me"]);
		
		
		return true;
	}
	
	private function _deleteMeCircleAround(me:IGameEntity):Void
	{
		if (me.getState('std_object')!=null)
		{
			me.setState('std_x',me.getState('initX')+50*Math.cos(me.getState('rotationDegree')));
			me.getState('std_object').x=me.getState('std_x');
			
			me.setState('std_y',me.getState('initY')+50*Math.sin(me.getState('rotationDegree')));
			me.getState('std_object').y=me.getState('std_y');
			
			me.setState('rotationDegree',me.getState('rotationDegree')+0.1);
		}
	}
	
	
	public function hash(script:String):Int
	{
		//return _store(_parser.parseString(script), Crc32.make(Bytes.ofString(script)));
		return -1;
	}
	
	
	inline private function _get(hashId:Int):String
	{
		return "doTheCircle";
		/*
		var script:String = _hashTable[hashId];
		
		if (script == null)
			Console.error('Script not found on address [$hashId]');
		
		return script;
		*/
	}
	
	private function _store(script:String, hashId: Int):Int
	{
		if (_hashTable[hashId] != null)
		{
			if (Std.string(script) == Std.string(_hashTable[hashId]))
			{
				Console.log('Same Script found: [$script] in hashId: [$hashId]');
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
			Console.log('Entering hashId: [$hashId] with Script: $script');
			_hashTable[hashId] = script;
			return hashId;
		}
	}
}