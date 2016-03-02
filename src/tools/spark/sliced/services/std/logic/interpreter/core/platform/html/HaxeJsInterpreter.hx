/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.interpreter.core.platform.html;

import haxe.io.Bytes;
import haxe.crypto.Crc32;
import tools.spark.framework.ModuleManager;
import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameBase;
import tools.spark.sliced.services.std.logic.interpreter.interfaces.IInterpreter;
import flambe.System;
import haxe.ds.IntMap;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap;
import flambe.input.MouseButton;
import tools.spark.framework.Assets;
import tools.spark.framework.assets.Asset;
import tools.spark.framework.assets.Module;
import tools.spark.framework.Project;
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventType;
import flambe.input.Key;

/**
 * ...
 * @author Aris Kostakos
 */
@:keep class HaxeJsInterpreter implements IInterpreter
{
	private var _hashTable:Map<Int,Dynamic>;
	
	public function new() 
	{
		Console.log("Init HaxeJs Interpreter...");
		_init();
	}
	
	private function _init():Void
	{
		//Here we use somethings for no other reason than to prevent DCE to eliminate the classes. We want to include them so they can be reflected with the interprenter
		var dummy:Int = Std.random(1);
		var dummy2:Dynamic = System.storage;
		dummy2 = System.storage.supported;
		dummy2 = System.storage.clear;
		dummy2 = System.storage.get;
		dummy2 = System.storage.remove;
		dummy2 = System.storage.set;
		//end of DCE prevention
		
		_hashTable = new Map<Int,Dynamic>();
		
		
		//Static variables
		untyped window.Sound = Sliced.sound;
		untyped window.Logic = Sliced.logic;
		untyped window.Input = Sliced.input;
		untyped window.Comms = Sliced.comms;
		untyped window.Event = Sliced.event;
		untyped window.Display = Sliced.display;
		
		untyped window.Project = Project;
		untyped window.Module = Module;
		untyped window.Asset = Asset;
		
		
		untyped window.Std = Std;
		untyped window.StringMap = StringMap;
		untyped window.IntMap = IntMap;
		untyped window.ObjectMap = ObjectMap;
		untyped window.Assets = Assets;
		untyped window.StringTools = StringTools;
		untyped window.Xml = Xml;
		untyped window.MouseButton = MouseButton;
		untyped window.EEventType = EEventType;
		untyped window.Key = Key;
		untyped window.System = System;
		untyped window.ModuleManager = ModuleManager;
		
		//Shortcuts
		untyped window.expr = runExpr;
		untyped window.e = Sliced.logic.getEntityByName;
		untyped window.query = Sliced.logic.queryGameEntity;
		untyped window.string = Std.string;
		
		//COMMENTED OUT Because we don't use them anywhere in the egcs anymore
		//_interpreter.variables.set("Console", Console); // share the Console
		//_interpreter.variables.set("Fast", Fast); // share the Fast class
		//_interpreter.variables.set("EReg", EReg); // share the EReg class
		
		//COMMENTED OUT Because apparently, they find a similar js class with the same name already
		//_interpreter.variables.set("Math", Math); // share the Math
		//_interpreter.variables.set("String", String); // share the String
		//_interpreter.variables.set("XMLHttpRequest", js.html.XMLHttpRequest); // share the XMLHttpRequest
	}
	
	public function run(hashId:Int, parameters:Map<String,Dynamic>):Bool
	{
		var program:Dynamic = _get(hashId);
		
		/*
		//Dynamic Variables
		for (varName in parameters.keys())
		{
			_interpreter.setVariableSafe(varName, parameters[varName]);
		}
		*/
		
		//Console.warn("Interpenter Executing: " + hashId);
		try
		{
			//We keep this, for much later when we do real js parsing and this returns a function we can just execute instead of running interprenter again and again
			//var returnedValue:Dynamic = _interpreter.execute(program);
			
			program(parameters['me'],parameters['parent'],parameters['it']);
			
			return true;
		}
		catch (e:Dynamic)
		{
			Console.error("<<<<<SPARK SCRIPT RUN-TIME JS ERROR>>>>>: " + e);
			System.external.call("console.log", [ e ]);
			System.external.call("console.log", [ program ]);
			return false;
		}
	}
	
	public function runExpr(hashId:Int, ?p_me:IGameBase, ?p_parent:IGameBase, ?p_it:IGameBase):Dynamic
	{
		var program:Dynamic = _get(hashId);
		
		try
		{
			return program(p_me,p_parent,p_it);
		}
		catch (e:Dynamic)
		{
			Console.error("<<<<<SPARK EXPRESSION RUN-TIME JS ERROR>>>>>: " + e);
			System.external.call("console.log", [ e ]);
			System.external.call("console.log", [ program ]);
			return null;
		}
	}
	
	public function hashExpr(script:String):Int
	{
		//var l_script:String = "(function(me,parent,it,spark){" + script + "})";
		var l_script:String = "(function(me,parent,it){return(" + script + ");})";
		
		return _store(l_script, Crc32.make(Bytes.ofString(l_script)));
	}
	
	public function hash(script:String):Int
	{
		//var l_script:String = "(function(me,parent,it,spark){" + script + "})";
		var l_script:String = "(function(me,parent,it){" + script + "})";
		
		return _store(l_script, Crc32.make(Bytes.ofString(l_script)));
	}
	
	
	inline private function _get(hashId:Int):Dynamic
	{
		var script:Dynamic = _hashTable[hashId];
		
		if (script == null)
			Console.error('Script not found on address [$hashId]');
		
		return script;
	}
	
	private var _lalala:Int = 0;
	
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
			}*/
			//Console.log("Js Parser: ALREADY EXISTS");
			return hashId;
		}
		else
		{
			try
			{
				_hashTable[hashId] = System.external.call("eval", [ script ]);
				_lalala += 1;
				//Console.log("Parsed Something: " + _lalala);
				return hashId;
			}
			catch (e:Dynamic)
			{
				Console.error("<<<<<SPARK SCRIPT PARSING ERROR: " + e);
				System.external.call("console.log", [ e ]);
				System.external.call("console.log", [ script ]);
				return -1;
			}
			
			/*
			//Console.log('Entering hashId: [$hashId] with Script: $script');
			var l_expr:Expr;
			
			try
			{
				l_expr=_parser.parseString(script);
			}
			catch (e:Dynamic)
			{
				Console.error("<<<<<SPARK SCRIPT PARSING ERROR [Line: " + _parser.line + "]>>>>>: " + e);
				Console.error("Stack: " + script);
				
				var errorMsg:String = "function(me,parent,this){Display.error('This script failed to parse. Look at stack above.'); CouldNotParseScript;}";
				
				l_expr=_parser.parseString(errorMsg);
			}
			
			try
			{
				//We keep this, for much later when we do real js parsing and this returns a function we can just execute instead of running interprenter again and again
				_lalala += 1;
				
				//if (_lalala < 125)
				//{
					_hashTable[hashId] = _interpreter.execute(l_expr);
					Console.log("Parsed Something: " + _lalala);
				//}
				return hashId;
			}
			catch (e:Dynamic)
			{
				Console.error("<<<<<SPARK SCRIPT RUN-TIME ERROR>>>>>: " + e);
				
				return -1;
			}
			*/
		}
	}
}