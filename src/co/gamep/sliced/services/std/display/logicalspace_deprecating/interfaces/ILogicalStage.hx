/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.sliced.services.std.display.logicalspace.interfaces;
import co.gamep.sliced.services.std.display.logicalspace.containers.View3D;

/**
 * Logical space stands to ‘reality’, the existence and non-existence of states of affairs (TLP 2.05), as the potential to the actual. 
 * The term conveys the idea that logical possibilities form a ‘logical scaffolding’ (TLP 3.42), a systematic manifold akin to a coordinate system. 
 * The world is the ‘facts in logical space’ (TLP 1.13), since the contingent existence of states of affairs is embedded in an a priori order of possibilities.
 * @author Aris Kostakos
 */
interface ILogicalStage
{
	var name( default, default ):String;
	var logicalViewSet( default, null ):Map<String,View3D>;
	var width( default, default ):Int;
	var height( default, default ):Int;
	
	function addView( p_view:View3D):Void;
	function removeView( p_view:View3D):Void;
}