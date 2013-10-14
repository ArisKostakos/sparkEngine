/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package org.gamepl.coreservices.services.dummy;

import awe6.interfaces.IKernel;
import org.gamepl.coreservices.interfaces.IComms;
import org.gamepl.coreservices.core.AService;

/**
 * ...
 * @author Aris Kostakos
 */
class Comms extends AService implements IComms
{

	public function new(p_kernel:IKernel) 
	{
		super(p_kernel);
		
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init Comms Dummy Service...");
	}
	
}