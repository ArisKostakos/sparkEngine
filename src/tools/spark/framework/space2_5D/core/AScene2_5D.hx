/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.core;

import flambe.math.Rectangle;
import tools.spark.framework.space2_5D.interfaces.ICamera2_5D;
import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IScene2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.framework.layout.containers.Group;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.core.Sliced;

/**
 * ...
 * @author Aris Kostakos
 */
class AScene2_5D extends AInstantiable2_5D implements IScene2_5D
{
	private var _tempX:Float;
	private var _tempY:Float;
	private var _scaleX:Float;
	private var _scaleY:Float;
	
	private function new(p_gameEntity:IGameEntity) 
	{
		_tempX = 0;
		_tempY = 0;
		_scaleX = 1;
		_scaleY = 1;
		
		super(p_gameEntity);
	}
	
	override public function createInstance (p_view2_5D:IView2_5D):Dynamic
	{
		return super.createInstance(p_view2_5D);
	}
	
	override private function _createChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D, p_index:Int=-1):Void
	{
		if (p_childEntity.gameEntity.getState('layoutable') == true)
		{
			if (p_index==-1)
				p_view2_5D.group.children.push(p_childEntity.groupInstances[p_view2_5D]);
			else
				p_view2_5D.group.children.insert(p_index,p_childEntity.groupInstances[p_view2_5D]);
		}
		
		p_childEntity.parentScene = this;
	}
	
	override private function _removeChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D):Void
	{
		if (p_childEntity.gameEntity.getState('layoutable') == true)
			p_view2_5D.group.children.remove(p_childEntity.groupInstances[p_view2_5D]);
	}
	
	public function updateCamera(p_view:IView2_5D, p_camera:ICamera2_5D):Void
	{
		var l_rect:Rectangle = _getCaptureRect(p_view, p_camera);
		
		//Console.error("UPDATING CAMERAAAAAAA");
		//if camera x is whatever and y whatever and size whatever and view width, x, y, whatever, then.... scene's instance x and y must be : X, Y
		
		var l_requestedWidthScale:Float = p_view.gameEntity.getState('feedbackWidth') / l_rect.width;
		var l_requestedHeightScale:Float = p_view.gameEntity.getState('feedbackHeight') / l_rect.height;
		
		//Haven't thought this thouroughly, but i think to maintain that we keep both width and height in sight, we need to respect the scale
		//of the dimension that requires as to do the smaller scale..
		var l_scale = Math.min(l_requestedWidthScale,l_requestedHeightScale);
		
		//after calculations, store them somewhere privately and let the overriding function actually do it (good enough for now..:/)
		//set scale
		_scaleX = _scaleY = l_scale;
		
		//set pos
		_tempX = -l_rect.x * l_scale;
		_tempY = -l_rect.y * l_scale;
	}


/*
		<State><Id>percX</Id><Type>Decimal</Type><Value>0</Value></State>
		<State><Id>percY</Id><Type>Decimal</Type><Value>0</Value></State>

		<State><Id>useScenePercentage</Id><Type>Boolean</Type><Value>false</Value></State>
		<State><Id>respectSceneBounds</Id><Type>Boolean</Type><Value>false</Value></State>
		*/
		
	private static var _rect = new Rectangle(); //to minimize object creation
	private function _getCaptureRect(p_view:IView2_5D, p_camera:ICamera2_5D):Rectangle
	{
		var l_view:IGameEntity = p_view.gameEntity;
		//Display.error("View Name: " + view.getState('name'));
		//CAMERA
		var l_camera:IGameEntity = p_camera.gameEntity;
		
		//x
		var l_x:Float = l_camera.getState('x'); 
		//y
		var l_y:Float = l_camera.getState('y'); 
		//width
		var l_width:Float = l_camera.getState('width')*l_camera.getState('zoom'); 
		//height
		var l_height:Float = l_camera.getState('height')*l_camera.getState('zoom'); 
		//minBoundsWidthRatio
		var l_minBoundsWidthRatio:Float = l_camera.getState('minBoundsWidthRatio'); 
		//minBoundsHeightRatio
		var l_minBoundsHeightRatio:Float = l_camera.getState('minBoundsHeightRatio'); 
		//minBoundsHorizontalAlign
		var l_minBoundsHorizontalAlign:String = l_camera.getState('minBoundsHorizontalAlign'); 
		//minBoundsVerticalAlign
		var l_minBoundsVerticalAlign:String = l_camera.getState('minBoundsVerticalAlign'); 
		
		var l_minBoundsWidth:Float = l_width*l_minBoundsWidthRatio;
		var l_minBoundsHeight:Float = l_height*l_minBoundsHeightRatio;

		var l_viewWidth:Float = l_view.getState('feedbackWidth');
		var l_viewHeight:Float = l_view.getState('feedbackHeight');
		//Display.error("View Width: " + viewWidth);
		//Display.error("View Height: " + viewHeight);
		
		
		var l_viewAspectRatio:Float = l_viewWidth/l_viewHeight;
		//Display.error("viewAspectRatio: " + viewAspectRatio);
		_rect.x = 0;
		_rect.y = 0;
		_rect.width =0;
		_rect.height =0;
		
		/*
		//if (scale between 4:3 and 16:9)
		if (viewAspectRatio>1.777) //16:9
		{
			Display.error("SHIT! View is to looongish");
			//For now, Assume 1.777
			viewAspectRatio = 1.777;
		}
		else if (1.333>viewAspectRatio) //4:3
		{
			Display.error("SHIT! View is to squarish");
			//For now, Assume 1.333
			viewAspectRatio = 1.333;
		}
		*/
		

		//check if ratio is bigger or smaller than 3:2 (1.5)
		if (l_viewAspectRatio>1.5) //if bigger
		{
			//Display.error("GOOD! glueing HEIGHT");
			//glue minBoundsHeight
			_rect.height = l_minBoundsHeight;
			_rect.width = Math.round(_rect.height*l_viewAspectRatio);
			
		}
		else //if smaller or equal
		{
			//Display.error("GOOD! glueing WIDTH");
			//glue minBoundsWidth (this case)
			_rect.width = l_minBoundsWidth;
			_rect.height = Math.round(_rect.width/l_viewAspectRatio);
		}
			
			
		
		//Later on if we assumed 1.333 or 1.777, instead do letterboxing like so:
		//if we failed the test above we'll need to do letterboxing too
		//after we're done we'll do letterbox centering (other options too later)
		

		//and at some point, we align..
		//Horizontal Align
		if (l_minBoundsHorizontalAlign=="Left")
			_rect.x = l_x;
		else if (l_minBoundsHorizontalAlign=="Center")
			_rect.x = l_x + (l_width - _rect.width)/2;
		else if (l_minBoundsHorizontalAlign=="Right")
			_rect.x = l_x + (l_width - _rect.width);
		
		//Vertical Align
		if (l_minBoundsVerticalAlign=="Top")
			_rect.y = l_y;
		else if (l_minBoundsVerticalAlign=="Middle")
			_rect.y = l_y + (l_height - _rect.height)/2;
		else if (l_minBoundsVerticalAlign=="Bottom")
			_rect.y = l_y + (l_height - _rect.height);
		
		return _rect;
	}
}