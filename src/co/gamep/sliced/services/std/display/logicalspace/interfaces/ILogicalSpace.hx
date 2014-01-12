/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.sliced.services.std.display.logicalspace.interfaces;
import co.gamep.sliced.services.std.display.logicalspace.cameras.Camera3D;
import co.gamep.sliced.services.std.display.logicalspace.containers.Scene3D;

/**
 * Logical space stands to ‘reality’, the existence and non-existence of states of affairs (TLP 2.05), as the potential to the actual. 
 * The term conveys the idea that logical possibilities form a ‘logical scaffolding’ (TLP 3.42), a systematic manifold akin to a coordinate system. 
 * The world is the ‘facts in logical space’ (TLP 1.13), since the contingent existence of states of affairs is embedded in an a priori order of possibilities.
 * @author Aris Kostakos
 */
interface ILogicalSpace
{
	var name( default, default ):String;
	var logicalStage( default, default ):ILogicalStage;
	var logicalSceneSet( default, null ):Map<String,Scene3D>;
	var logicalCameraSet( default, null ):Map<String,Camera3D>;
	//var assets and primitives?????(neccessary for shared objects between scenes and memory conservation)
	
	function setStage( p_stage:ILogicalStage ):Void;
	
	function addScene( p_scene:Scene3D ):Void;
	function removeScene( p_scene:Scene3D ):Void;
	function getScene( p_sceneName:String ):Scene3D;
	
	function addCamera( p_camera:Camera3D ):Void;
	function removeCamera( p_camera:Camera3D ):Void;
	function getCamera( p_cameraName:String ):Camera3D;
}