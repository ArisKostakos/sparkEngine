/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, December 2013
 */

package co.gamep.framework.pseudo3d.flambe;
import co.gamep.framework.pseudo3d.core.APseudoEntity;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.display.BlendMode;
import co.gamep.framework.Assets;

/**
 * ...
 * @author Aris Kostakos
 */
class FlambeEntity extends APseudoEntity
{
	private var _flambeEntity:Entity;
	
	public function new() 
	{
		super();
		
		_flambeEntityInit();
	}
	
	private inline function _flambeEntityInit():Void
	{
		_flambeEntity = new Entity().add(new ImageSprite(Assets.images.getTexture("ball")));
		
		//var myImage:ImageSprite = new ImageSprite(Assets.images.getTexture("lion"));
		//myImage.setScale(0.1);
		//myImage.blendMode = BlendMode.Copy;
		//myImage.visible = false;
		//_flambeEntity.addChild(new Entity().add(myImage)); // add on top of stage
		
		realObject = _flambeEntity;
		
	}
	
	override public function validate():Void
	{
		var l_sprite:Sprite = _flambeEntity.get(Sprite);
		l_sprite.x._ = x;
		l_sprite.y._ = y;
	}
	
	
	
	/*
	private function _calculateSprite2D(p_logicalEntity:ILogicalEntity, p_logicalScene:ILogicalScene):Void
	{
       // var l_camera:ICamera2D = _cameraPointerSet[p_logicalScene.]
		
		//var l_sprite2D:ISprite2D = _calculateSprite2D(p_logicalEntity, p_logicalScene);
	}
	*/
}