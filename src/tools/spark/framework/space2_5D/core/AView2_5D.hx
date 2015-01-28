/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.core;

import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.framework.space2_5D.interfaces.IScene2_5D;
import tools.spark.framework.space2_5D.interfaces.ICamera2_5D;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.framework.space2_5D.layout.core.GroupSpace2_5D;

/**
 * ...
 * @author Aris Kostakos
 */
class AView2_5D extends ABase2_5D implements IView2_5D
{
	public var scene( default, set ):IScene2_5D;
	public var camera( default, set ):ICamera2_5D;
	public var group( default, null ):GroupSpace2_5D;
	
	private function new(p_gameEntity:IGameEntity) 
	{
		super(p_gameEntity);
		
		//if (gameEntity.getState('layoutable') == true)
			group = new GroupSpace2_5D("view", null, this);
			
		//do Layout Call??????????????
		//...
	}
	
	public function render():Void
	{
		//override me
	}
	
	private function set_camera( v : ICamera2_5D ) : ICamera2_5D {
        return camera = v;
    }
	
	private function set_scene( v : IScene2_5D ) : IScene2_5D {
        return scene = v;
    }
}