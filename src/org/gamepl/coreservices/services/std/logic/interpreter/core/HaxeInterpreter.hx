/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package org.gamepl.coreservices.services.std.logic.interpreter.core;
import org.gamepl.coreservices.core.Game;
import awe6.interfaces.EKey;
/**
 * ...
 * @author Aris Kostakos
 */
class HaxeInterpreter extends AInterpreter
{
	public function new() 
	{
		super();
		Console.log("Init Haxe Interpreter...");
	}
	
	override public function run(hashId:Int, parameters:Map<String,Dynamic>):Bool
	{
		//@todo: V.EASY/IMPORTANT/ASAP: don't create a new parser and interpenter EVERY SINGLE TIME!!!!
		var parser = new hscript.Parser();
		var program = parser.parseString(_get(hashId));
		var interp = new hscript.Interp();
		
		//Static variables
		interp.variables.set("Game", Game); // share the Game class
		interp.variables.set("Sound", Game.sound); // share the Sound class
		interp.variables.set("Logic", Game.logic); // share the Logic class
		interp.variables.set("Input", Game.input); // share the Input class
		interp.variables.set("Comms", Game.comms); // share the Comms class
		interp.variables.set("Display", Game.display); // share the Display class
		interp.variables.set("Key", EKey); // share the EKey enum
		
		//Dynamic Variables
		for (varName in parameters.keys())
		{
			interp.variables.set(varName, parameters[varName]); // share the Game class
		}
		
		return interp.execute(program);
	}
}