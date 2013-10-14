/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, July 2013
 */

import org.gamepl.awe6.core.Factory;
import flash.Lib;
import haxe.Resource;
import mconsole.Console;
import mconsole.LogLevel;

/**
 * ...
 * @author Aris Kostakos
 */
class Main 
{	
	static function main() 
	{
		//Is Debug?
		#if debug
		var l_isDebug:Bool = true;
		#else
		var l_isDebug:Bool = false;
		#end
		
		//Init Console
		Console.start();
		Console.logLevel = LogLevel.info;
		
		//Create awe6 Factory
		var l_awe6Factory:Factory = new Factory( Lib.current, l_isDebug, Resource.getString( "config" ) );
	}
}