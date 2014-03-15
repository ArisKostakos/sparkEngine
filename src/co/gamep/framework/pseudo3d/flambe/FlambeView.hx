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
import nape.geom.Vec2;

import flambe.System;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;


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
	
	private var space:SpaceComponent;
	private inline function _createRealView():Void
	{
		_flambeView = new Entity();

		//color  (fix me!)
		var l_bakcgroundColor:Int;
		l_bakcgroundColor = 0xffffff;
		
		var l_viewSprite:FillSprite = new FillSprite(l_bakcgroundColor, width, height);
		l_viewSprite.scissor = new Rectangle(0, 0, width, height);
		_flambeView.add(l_viewSprite);
		
		
		//Physics test
        space = new SpaceComponent(_flambeView);
        //var world = new Entity()
          //  .add(space)
          //  .add(new FillSprite(0xf0f0f0, width, height));
       // _flambeView.addChild(world);
	   _flambeView.add(space);

        // Since the box and ball images aren't in a texture atlas in this demo, put each type of
        // body in its own layer to make the drawing order more batch-friendly for GPU renderers
        
        //_flambeView.addChild(boxLayer);
		
		
        //_flambeView.addChild(ballLayer);
		
		
		addFloor(_flambeView, 0, -10, 640, 10); //up
		//addFloor(_flambeView, 0, 480, 640, 10); //down
		addFloor(_flambeView, -10, 0, 10, 480); //left
		addFloor(_flambeView, 640, 0, 10, 480); //right
		
		System.root.addChild(_flambeView);
		
		// On a tap, create a new box or ball
        System.pointer.down.connect(function (event) 
		{
            mouseDown = true;
			mouseEvent = event;
        });
		
		// On a tap, create a new box or ball
        System.pointer.up.connect(function (event) 
		{
            mouseDown = false;
        });
	}
	
	private var mouseDown:Bool = false;
	private var mouseEvent:Dynamic;
	
	
    private function addFloor (world :Entity,myX:Int,myY:Int,myWidth:Int,myHeight:Int)
    {
       // var padX = 100;
        //var padY = 30;
        //var x = padX;
        //var y = height - padY;
        //var mywidth = width - 2*padX;
        //var myheight = 10;

        var space = world.get(SpaceComponent);
        var floorBody = new Body(BodyType.STATIC);
        floorBody.shapes.add(new Polygon(Polygon.rect(myX, myY, myWidth, myHeight)));
        space.addBody(floorBody);

        var floorEntity = new Entity();
            //.add(new FillSprite(0x202020, myWidth, myHeight).setXY(myX, myY));
        world.addChild(floorEntity);
    }
	
	private inline function _validateRealView():Void
	{
		var l_viewSprite:FillSprite = _flambeView.get(FillSprite);
		l_viewSprite.x._ = x;
		l_viewSprite.y._ = y;
	}
	
	private inline function _createRealEntity(p_pseudoEntity:IPseudoEntity):Void
	{
		trace("sprite url: " + p_pseudoEntity.spriteUrl);

		if (p_pseudoEntity.spriteUrl != "Default")
		{
			if (p_pseudoEntity.spriteUrl == "Ball.png")
			{
				_entityPointerSet[p_pseudoEntity] = space.addBall(p_pseudoEntity.x, p_pseudoEntity.y , p_pseudoEntity);
			}
			else if (p_pseudoEntity.spriteUrl == "Brick.png")
			{
				_entityPointerSet[p_pseudoEntity] = space.addBox(p_pseudoEntity.x, p_pseudoEntity.y , p_pseudoEntity);
			}
			else if (p_pseudoEntity.spriteUrl == "Paddle.png")
			{
				_entityPointerSet[p_pseudoEntity] = space.addBoxKinetic(p_pseudoEntity.x, p_pseudoEntity.y , p_pseudoEntity);
			}
			else 
			{
				_entityPointerSet[p_pseudoEntity] = new Entity();
				_entityPointerSet[p_pseudoEntity].add(new ImageSprite(Assets.getTexture("assets/images/" + p_pseudoEntity.spriteUrl)));
				
				var l_child:ImageSprite	 = _entityPointerSet[p_pseudoEntity].get(ImageSprite);
				
				l_child.x._ = p_pseudoEntity.x;
				l_child.y._ = p_pseudoEntity.y;
			}
			
		}
		else
		{
			_entityPointerSet[p_pseudoEntity] = new Entity();
		}
		_flambeView.addChild(_entityPointerSet[p_pseudoEntity]);
		
		
	}
	
	private inline function _validateRealEntity(p_pseudoEntity:IPseudoEntity):Void
	{
		if (p_pseudoEntity.spriteUrl == "Paddle.png")
		{
			if (mouseDown == true)
			{
				if (mouseEvent.viewX < _entityPointerSet[p_pseudoEntity].get(ImageSprite).x._-25)
				{
					p_pseudoEntity.napeBody.velocity = new Vec2(-400, 0);
				}
				else if (mouseEvent.viewX > _entityPointerSet[p_pseudoEntity].get(ImageSprite).x._+25)
				{
					p_pseudoEntity.napeBody.velocity = new Vec2(400, 0);
				}
				else
				{
					p_pseudoEntity.napeBody.velocity = new Vec2(0, 0);
				}
			}
			else
			{
				p_pseudoEntity.napeBody.velocity = new Vec2(p_pseudoEntity.velX, p_pseudoEntity.velY);
			}
			
		}
			
		return;
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
			//Console.warn("yo: " + l_d / l_zCamera);
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