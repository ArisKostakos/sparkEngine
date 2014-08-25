/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

package tools.spark.sliced.services.std.display.logicalspace.interfaces;

/**
 * Logical space stands to ‘reality’, the existence and non-existence of states of affairs (TLP 2.05), as the potential to the actual. 
 * The term conveys the idea that logical possibilities form a ‘logical scaffolding’ (TLP 3.42), a systematic manifold akin to a coordinate system. 
 * The world is the ‘facts in logical space’ (TLP 1.13), since the contingent existence of states of affairs is embedded in an a priori order of possibilities.
 * @author Aris Kostakos
 */
interface ILogicalCamera extends ILogicalPositionable
{
	var fieldOfView( default, default ):Int;
}