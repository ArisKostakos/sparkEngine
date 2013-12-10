/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, December 2013
 */

package co.gamep.framework.pseudo3d.interfaces;

/**
 * ...
 * @author Aris Kostakos
 */
interface IPseudoScene
{
	function addChild(p_pseudoEntity:IPseudoEntity):Void;
	
	var realObject( default, default ):Dynamic;
}