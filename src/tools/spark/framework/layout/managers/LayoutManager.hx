/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2015
 */

package tools.spark.framework.layout.managers;
import flambe.display.Sprite;
import flambe.math.Rectangle;
import tools.spark.framework.layout.containers.Group;
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
			measure(rootLayoutElement);
			logPreffered(rootLayoutElement);
			updateDisplayList(rootLayoutElement);
			log(rootLayoutElement);
			//updateRealObjects(rootLayoutElement);
			validated = true;
		}
	}
	
	public function updateRealObjects(p_Group:Group):Void
	{
		//up here cause it's top to bottom
		if (p_Group.layoutableInstanceType == "View")
		{
			var skata:Sprite = p_Group.layoutableInstance;
			skata.setXY(rootLayoutElement.children[0].x,rootLayoutElement.children[0].y);
		}
		
		for (f_child in p_Group.children)
		{
			updateRealObjects(f_child);
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