/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2015
 */

package tools.spark.framework.layout.managers;
import flambe.display.Sprite;
import flambe.math.Rectangle;
import tools.spark.framework.layout.containers.Group;
import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.core.Sliced;

/**
 * ...
 * @author Aris Kostakos
 */
class LayoutManager
{
	public var validated (default, default):Bool;
	public var rootLayoutElement (default, null):Group;
	
	public function new (p_rootLayoutElement)
	{
		rootLayoutElement = p_rootLayoutElement;
		validated = false;
	}
	
	public function validate():Void
	{
		if (!validated)
		{
			Console.error("VALIDATING LAYOUT...");
			measure(rootLayoutElement);
			//logPreffered(rootLayoutElement);
			updateDisplayList(rootLayoutElement);
			//log(rootLayoutElement);
			updateRealObjects(rootLayoutElement);
			validated = true;
		}
	}
	
	public function getViewGroupByGameEntity(p_gameEntity:IGameEntity, ?p_Group:Group):Group
	{
		if (p_Group == null)
			p_Group = rootLayoutElement;
		
		if (p_Group.layoutableEntity == p_gameEntity)
			return p_Group;
			
		for (f_child in p_Group.children)
		{
			if (f_child.layoutableInstanceType != "Entity")
			{
				var l_found:Group = getViewGroupByGameEntity(p_gameEntity, f_child);
				if (l_found != null)
					return l_found;
			}
		}
		
		return null;
	}
	
	public function updateRealObjects(p_Group:Group, p_parentsX:Float=0, p_parentsY:Float=0, p_parentView:IView2_5D=null):Void
	{
		var l_view2_5D:IView2_5D = p_parentView;
		
		//up here cause it's top to bottom
		if (p_Group.layoutableInstanceType == "View")
		{
			//@todo: Here's the problem. Away3d view instances are not IView2_5Ds yet.. fix this..
			if (p_Group.layoutableEntity.getState('renderer') == '3D')
			{
				var l_view3D:Dynamic = p_Group.layoutableInstance;
				l_view3D.x = p_Group.x + p_parentsX;
				l_view3D.y = p_Group.y + p_parentsY;
				l_view3D.width = p_Group.width;
				l_view3D.height = p_Group.height;
				//NEXT....
				//THIS DOESNT DO ANYTHING. SO START YOUR RESEARCH FROM HERE
				//MAYBE ITS TIME TO GET THE NEWEST VRSION OF AWAYJS ON!
				//why Im struggling to get 3d to work?
				//1) impressive results
				//2) its easier to understand how views, scenes and cameras will work here
				//because in away3d they already work properly (or should work properly..)
				//in 2d, i dont have the concept of viewports implemented yet..
				//so im scared to do it there..
				//why is this important for level editor?
				//because level editor must have a concept of viewports and real game stage, etc, etc..
				//BUT 2d physics, also impressive.. do spark machines!
				//Console.error('View3d x: ' + l_view3D.x  + ', y: ' + l_view3D.y + ', width: ' + l_view3D.width + ', height: ' + l_view3D.height);
			}
			else
			{
				l_view2_5D = p_Group.layoutableInstance;
				l_view2_5D.setPosSize(p_Group.x + p_parentsX, p_Group.y + p_parentsY, p_Group.width, p_Group.height);
			}
		}
		else if (p_Group.layoutableInstanceType == "Entity")
		{
			var l_entity2_5D:IEntity2_5D = p_Group.layoutableInstance;
			l_entity2_5D.setPosSize(p_Group.x, p_Group.y, p_Group.width, p_Group.height, l_view2_5D);
		}
		
		for (f_child in p_Group.children)
		{
			updateRealObjects(f_child, p_Group.x+p_parentsX,p_Group.y+p_parentsY, l_view2_5D);
		}
	}
	
	public function log(p_group:Group, p_deepCount:Int=0):Void
	{
		var logStr:String = "";
		var i:Int = 0;
		while (i < p_deepCount)
		{
			logStr += "***";
			i++;
		}
		
		Console.error(logStr + p_group.layoutableEntity.getState('name') 
							+ ", x: " + p_group.x
							+ ", y: " + p_group.y
							+ ", w: " + p_group.width
							+ ", h: " + p_group.height);

		for (f_child in p_group.children)
		{
			log(f_child, p_deepCount+1);
		}
	}
	
	public function logPreffered(p_group:Group, p_deepCount:Int=0):Void
	{
		var logStr:String = "";
		var i:Int = 0;
		while (i < p_deepCount)
		{
			logStr += "***";
			i++;
		}
		
		Console.error(logStr + p_group.layoutableEntity.getState('name') 
							+ ", Prf Width: " + p_group.preferredWidth
							+ ", Prf Height: " + p_group.preferredHeight);

		for (f_child in p_group.children)
		{
			logPreffered(f_child, p_deepCount+1);
		}
	}
		
	public function measure(p_Group:Group):Void
	{
		for (f_child in p_Group.children)
		{
			measure(f_child);
		}
		
		//down here cause it's bottom-up
		//only measure if explicit not set?
		p_Group.measure();
	}
	
	public function updateDisplayList(p_Group:Group):Void
	{
		//up here cause it's top to bottom
		p_Group.updateDisplayList(p_Group.preferredWidth, p_Group.preferredHeight);
		
		for (f_child in p_Group.children)
		{
			updateDisplayList(f_child);
		}
	}
	
}