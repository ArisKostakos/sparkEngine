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
interface IPseudoView
{
	var camera( default, default ):IPseudoCamera;
	var scene( default, set ):IPseudoScene;
	var x( default, default ):Int;
	var y( default, default ):Int;
	var width( default, default ):Int;
	var height( default, default ):Int;
	
	function validate():Void;
	function render():Void;
}