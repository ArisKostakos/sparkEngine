/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, December 2013
 */

package co.gamep.framework.pseudo3d.flambe;
import co.gamep.framework.pseudo3d.core.APseudoView;
import co.gamep.framework.pseudo3d.interfaces.IPseudoCamera;
import co.gamep.framework.pseudo3d.interfaces.IPseudoEntity;
import co.gamep.framework.pseudo3d.interfaces.IPseudoScene;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.display.BlendMode;
import co.gamep.framework.Assets;
import flambe.math.Rectangle;
import flambe.platform.InternalGraphics;

/**
 * ...
 * @author Aris Kostakos
 */
class FlambeView extends APseudoView
{
	private var _flambeGraphics:InternalGraphics;
	private var _flambeView:Entity;
	private var _entityPointerSet:Map<IPseudoEntity,Entity>;
	
	public function new(p_flambeGraphics:InternalGraphics) 
	{
		super();
		
		_flambeGraphics = p_flambeGraphics;
		
		_flambeViewInit();
	}
	
	private inline function _flambeViewInit():Void
	{
		_entityPointerSet = new Map<IPseudoEntity,Entity>();
	}
	
	override public function render():Void
	{
		//calculate positions (update dirty entities)?
		//scene.validate(camera);
		
		//update dirty camera (calculate all positions)?
		
		//render
		Sprite.render(_flambeView, _flambeGraphics);
	}
	
	private inline function _createRealView():Void
	{
		_flambeView = new Entity();
		
		//color  (fix me!)
		var l_bakcgroundColor:Int;
		if (x == 0) l_bakcgroundColor = 0x00ff00;
		else l_bakcgroundColor = 0x0000ff;
		
		var l_viewSprite:FillSprite = new FillSprite(l_bakcgroundColor, width, height);
		l_viewSprite.scissor = new Rectangle(0, 0, width, height);
		_flambeView.add(l_viewSprite);
	}
	
	private inline function _validateRealView():Void
	{
		var l_viewSprite:FillSprite = _flambeView.get(FillSprite);
		l_viewSprite.x._ = x;
		l_viewSprite.y._ = y;
	}
	
	private inline function _createRealEntity(p_pseudoEntity:IPseudoEntity):Void
	{
		_entityPointerSet[p_pseudoEntity] = new Entity().add(new ImageSprite(Assets.images.getTexture("AtomBlue"))); //FIXMENOW //[PROTOTYPE HACK: enable]
		_flambeView.addChild(_entityPointerSet[p_pseudoEntity]);
	}
	
	private inline function _validateRealEntity(p_pseudoEntity:IPseudoEntity):Void
	{
		var l_fov:Float = 100;
		var l_d:Float = 1 / Math.tan(l_fov / 2);
		
		var l_child:ImageSprite	 = _entityPointerSet[p_pseudoEntity].get(ImageSprite);
		
		//translate
		var l_xCamera:Float = p_pseudoEntity.x - camera.x;
		var l_yCamera:Float = p_pseudoEntity.y - camera.y;
		var l_zCamera:Float = p_pseudoEntity.z - camera.z;
		
		//project
		var l_xProj:Float = l_xCamera * l_d / l_zCamera;
		var l_yProj:Float = l_yCamera * l_d / l_zCamera;
		
		//scale
		var l_xScreen:Float = (width / 2) + (width / 2) * -l_xProj;
		var l_yScreen:Float = (height / 2) - (height / 2) * l_yProj;
		
		
		l_child.x._ = l_xScreen - l_child.getNaturalWidth() / 2;
		l_child.y._ = l_yScreen - l_child.getNaturalHeight() / 2;
		//Console.warn("x: " + l_child.x._);
		//Console.warn("y: " + l_child.y._);
		l_child.setScaleXY(l_d / l_zCamera * l_fov, l_d / l_zCamera * l_fov);
		//Console.warn("scale: " + l_d / l_zCamera * l_fov);
		if (_doOnce)
		{
			Console.warn("yo: " + l_d / l_zCamera);
			_doOnce = false;
		}
	}
	
	private var _doOnce:Bool = true;
	
	override public function validate():Void
	{
		//Create View
		if (_flambeView == null)
		{
			_createRealView();
		}
		
		//Validate View
		_validateRealView();
		
		
		if (scene != null && camera != null)
		{
			for (pseudoEntity in scene.pseudoEntitySet)
			{
				//create real entity
				if (_entityPointerSet.exists(pseudoEntity) == false)
				{
					_createRealEntity(pseudoEntity);
				}
				
				//validate real entity
				_validateRealEntity(pseudoEntity);
			}
		}
	}
	
}