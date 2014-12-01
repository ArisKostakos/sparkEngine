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
interface IPseudoCamera
{
	var x( default, default ):Float;
	var y( default, default ):Float;
	var z( default, default ):Float;
	var rotationX( default, default ):Float;
	var rotationY( default, default ):Float;
	var rotationZ( default, default ):Float;
	var fieldOfView( default, default ):Int;
}