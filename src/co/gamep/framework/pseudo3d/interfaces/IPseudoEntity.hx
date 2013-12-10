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
interface IPseudoEntity
{
	var x( default, default ):Int;
	var y( default, default ):Int;
	var z( default, default ):Int;
	var yaw( default, default ):Int;
	var pitch( default, default ):Int;
	var roll( default, default ):Int;
	
	var realObject( default, default ):Dynamic;
	
	function validate():Void;
	
	/*
	var x( default, default ):Int;
	var y( default, default ):Int;
	var rotation( default, default ):Int;
	var scale( default, default ):Float;
	var distanceFromCamera( default, default ):Int;
	var insideFieldOfView( default, default ):Bool;
	*/
}