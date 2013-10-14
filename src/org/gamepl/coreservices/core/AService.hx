/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package org.gamepl.coreservices.core;

import awe6.interfaces.IKernel;
import org.gamepl.coreservices.interfaces.IService;

/**
 * ...
 * @author Aris Kostakos
 */
class AService implements IService
{
	private var _kernel:IKernel;
	
	private function new( p_kernel:IKernel ) 
	{
		_kernel = p_kernel;
	}
	
	public function report():String
	{
		return "Service Reporting!";
	}
	
}