/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.services.std.logic.interpreter.core;
import hscript.Interp;
import hscript.Parser;
import co.gamep.sliced.core.Sliced;
import flambe.input.Key;
import hscript.Expr;
/**
 * ...
 * @author Aris Kostakos
 */
class HaxeInterpreter extends AInterpreter
{
	var _parser:Parser;
	var _interpreter:Interp;
		
	public function new() 
	{
		super();
		Console.log("Init Haxe Interpreter...");
		_init();
	}
	
	private function _init():Void
	{
		_parser =  new hscript.Parser();
		_interpreter = new hscript.Interp();
		
		//Static variables
		_interpreter.variables.set("Game", Sliced); // share the Game class
		_interpreter.variables.set("Sound", Sliced.sound); // share the Sound class
		_interpreter.variables.set("Logic", Sliced.logic); // share the Logic class
		_interpreter.variables.set("Input", Sliced.input); // share the Input class
		_interpreter.variables.set("Comms", Sliced.comms); // share the Comms class
		_interpreter.variables.set("Display", Sliced.display); // share the Display class
		_interpreter.variables.set("Key", Key); // share the EKey enum
	}
	
	override public function run(hashId:Int, parameters:Map<String,Dynamic>):Bool
	{
		//@todo: V.EASY/IMPORTANT/ASAP: don't create a new parser and interpenter EVERY SINGLE TIME!!!!
		//Console.time("interpreting");
		
		//@todo: PARSE EVERYTHING IN THE HASH ONCE AND STORE DUMMY!
		var program:Expr = _parser.parseString(_get(hashId));
		
		
		_interpreter = new hscript.Interp();
		//Static variables
		_interpreter.variables.set("Game", Sliced); // share the Game class
		_interpreter.variables.set("Sound", Sliced.sound); // share the Sound class
		_interpreter.variables.set("Logic", Sliced.logic); // share the Logic class
		_interpreter.variables.set("Input", Sliced.input); // share the Input class
		_interpreter.variables.set("Comms", Sliced.comms); // share the Comms class
		_interpreter.variables.set("Display", Sliced.display); // share the Display class
		_interpreter.variables.set("Key", Key); // share the EKey enum
		
		
		//Dynamic Variables
		for (varName in parameters.keys())
		{
			_interpreter.variables.set(varName, parameters[varName]);
		}
		
		//Console.timeEnd("interpreting");
		//Console.warn("Interpenter Executing: " + hashId);
		return _interpreter.execute(program);
	}
}