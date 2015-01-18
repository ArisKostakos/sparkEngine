package tools.spark.sliced.services.std.display.renderers.core.library;

import tools.spark.sliced.services.std.display.renderers.core.dimension.A2_5DRenderer;
import tools.spark.sliced.services.std.display.renderers.interfaces.ILibrarySpecificRenderer;

/**
 * ...
 * @author Aris Kostakos
 */
class ANativeControls2_5DRenderer extends A2_5DRenderer implements ILibrarySpecificRenderer
{

	public function new() 
	{
		super();
		
	}
	
	/* INTERFACE tools.spark.sliced.services.std.display.renderers.interfaces.ILibrarySpecificRenderer */
	
	public function renderView(p_viewEntity:IGameEntity):Void 
	{
		
	}
	
	public function createView(p_viewEntity:IGameEntity):Dynamic 
	{
		
	}
	
	public function createScene(p_sceneEntity:IGameEntity):Dynamic 
	{
		
	}
	
	public function createCamera(p_cameraEntity:IGameEntity):Dynamic 
	{
		
	}
	
	public function createObject(p_objectEntity:IGameEntity):Dynamic 
	{
		
	}
	
	public function addChild(p_parentEntity:IGameEntity, p_childEntity:IGameEntity):Void 
	{
		
	}
	
	public function updateState(p_objectEntity:IGameEntity, p_state:String):Void 
	{
		
	}
	
	public function updateFormState(p_objectEntity:IGameEntity, p_state:String):Void 
	{
		
	}
	
}