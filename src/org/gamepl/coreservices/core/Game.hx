/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package org.gamepl.coreservices.core;
import org.gamepl.coreservices.interfaces.ISound;
import org.gamepl.coreservices.interfaces.ILogic;
import org.gamepl.coreservices.interfaces.IInput;
import org.gamepl.coreservices.interfaces.IComms;
import org.gamepl.coreservices.interfaces.IEvent;
import org.gamepl.coreservices.interfaces.IDisplay;

/**
 * ...
 * @author Aris Kostakos
 */
class Game
{
	public static var sound( default, null ):ISound;
	public static var logic( default, null ):ILogic;
	public static var input( default, null ):IInput;
	public static var comms( default, null ):IComms;
	public static var event( default, null ):IEvent;
	public static var display( default, null ):IDisplay;
	
	public static function init(p_sound:ISound, p_logic:ILogic, p_input:IInput, p_comms:IComms, p_event:IEvent, p_display:IDisplay):Void
	{
		Console.log("Init Core (S.L.I.C.E.D.)...");
		sound = p_sound;
		logic = p_logic;
		input = p_input;
		comms = p_comms;
		event = p_event;
		display = p_display;
	}
	
	//@todo: maybe inline all the update functions?
	inline public static function update():Void
	{
		//Input Update
		Game.input.update();
		
		//Event Update
		Game.event.update();
		
		//Logic Update
		Game.logic.update();
		
		//Display Update
		Game.display.update();
	}
}