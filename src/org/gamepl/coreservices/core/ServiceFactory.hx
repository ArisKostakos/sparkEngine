/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package org.gamepl.coreservices.core;
import awe6.interfaces.IKernel;
import org.gamepl.coreservices.interfaces.IServiceFactory;
import org.gamepl.coreservices.interfaces.ISound;
import org.gamepl.coreservices.interfaces.ILogic;
import org.gamepl.coreservices.interfaces.IInput;
import org.gamepl.coreservices.interfaces.IComms;
import org.gamepl.coreservices.interfaces.IEvent;
import org.gamepl.coreservices.interfaces.IDisplay;


/**
 * Every Available Service must be included below.
 * So that it is packaged to the application, in case
 * it needs to be reflected.
 */
//Dummy
import org.gamepl.coreservices.services.dummy.Sound;
//import org.gamepl.coreservices.services.dummy.Logic;
//import org.gamepl.coreservices.services.dummy.Input;
import org.gamepl.coreservices.services.dummy.Comms;
//import org.gamepl.coreservices.services.dummy.Event;
//import org.gamepl.coreservices.services.dummy.Display;

//Std
import org.gamepl.coreservices.services.std.logic.core.Logic;
import org.gamepl.coreservices.services.std.input.core.Input;
import org.gamepl.coreservices.services.std.event.core.Event;
import org.gamepl.coreservices.services.std.display.core.Display;

/**
 * ...
 * @author Aris Kostakos
 */
class ServiceFactory implements IServiceFactory
{
	private var _kernel:IKernel;
	
	public function new(p_kernel:IKernel) 
	{
		_kernel = p_kernel;
		_init();
	}
	
	private function _init():Void
	{
		//Create Services (S.L.I.C.E.D.)
		_createServices();
	}
	
	private function _createServices():Void
	{
		var l_soundService:ISound = _reflectService("services.sound");
		var l_logicService:ILogic = _reflectService("services.logic");
		var l_inputService:IInput = _reflectService("services.input");
		var l_commsService:IComms = _reflectService("services.comms");
		var l_eventService:IEvent = _reflectService("services.event");
		var l_displayService:IDisplay = _reflectService("services.display");
		
		Game.init(l_soundService, l_logicService, l_inputService, l_commsService, l_eventService, l_displayService);
	}
	
	inline private function _reflectService(p_configUrl:String):Dynamic
	{
		//@todo: create throw/catch for an exception when the url cannot be resolved or cannot be created.
		var l_classPath:String = _kernel.getConfig( p_configUrl );
		return Type.createInstance(Type.resolveClass(l_classPath), [_kernel]);
	}
}