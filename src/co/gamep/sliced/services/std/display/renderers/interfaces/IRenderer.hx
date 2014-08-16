/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.sliced.services.std.display.renderers.interfaces;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
interface IRenderer
{
	//var viewSet( default, null ):Array<IGameEntity>;
	//-0var uses3DEngine( default, null ):Bool;
	
	function renderView ( p_viewEntity:IGameEntity):Void;
	function addView ( p_viewEntity:IGameEntity):Void;
	function removeView ( p_viewEntity:IGameEntity):Void;
	function validateView ( p_viewEntity:IGameEntity):Void;
	function isViewValidated ( p_viewEntity:IGameEntity):Bool;
	//function update ():Void;
}