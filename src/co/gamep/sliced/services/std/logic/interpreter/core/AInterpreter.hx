/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.services.std.logic.interpreter.core;
import haxe.io.Bytes;
import co.gamep.sliced.services.std.logic.interpreter.interfaces.IInterpreter;
import haxe.crypto.Crc32;
import haxe.crypto.Sha1;
import haxe.crypto.Md5;

/**
 * ...
 * @author Aris Kostakos
 */
class AInterpreter implements IInterpreter
{
	private var _hashTable:Map<Int,String>;
	
	private function new() 
	{
		Console.log("Init Abstract Interpreter...");
		
		_hashTable = new Map<Int,String>();
	}
	
	public function hash(script:String):Int
	{
		return _store(script, Crc32.make(Bytes.ofString(script)));
	}
	
	public function run(hashId:Int, parameters:Map<String,Dynamic>):Bool
	{
		//override me...
		return false;
	}
	
	inline private function _get(hashId:Int):String
	{
		var script:String = _hashTable[hashId];
		
		if (script == null)
			Console.error('Script not found on address [$hashId]');
		
		return script;
	}
	
	private function _store(script:String, hashId: Int):Int
	{
		if (_hashTable[hashId] != null)
		{
			if (script == _hashTable[hashId])
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