/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2013
 */

package tools.spark.framework.pseudo3d.interfaces;
/**
 * ...
 * @author Aris Kostakos
 */
interface IPseudoEntity
{
	var x( default, default ):Float;
	var y( default, default ):Float;
	var z( default, default ):Float;
	var rotationX( default, default ):Float;
	var rotationY( default, default ):Float;
	var rotationZ( default, default ):Float;
	var spriteUrl( default, default ):String;
	var velX( default, default ):Float;
	var velY( default, default ):Float;
	var velZ( default, default ):Float;
	
	var pseudoEntitySet:Array<IPseudoEntity>;
	function addChild(p_pseudoEntity:IPseudoEntity):Void;
	
	/*
	var x( default, default ):Int;
	var y( default, default ):Int;
	var rotation( default, default ):Int;
	var scale( default, default ):Float;
	var distanceFromCamera( default, default ):Int;
	var insideFieldOfView( default, default ):Bool;
	*/
}