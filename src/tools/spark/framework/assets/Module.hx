package tools.spark.framework.assets;

/**
 * ...
 * @author Aris Kostakos
 */
class Module
{
	public var requiresModules( default, null ):Array<String>;
	public var assets( default, null ):Map< String, Asset>;
	public var id(default, null):String;
	public var executeEntity(default, default):String;
	
	public function new(p_id:String) 
	{
		id = p_id;
		_init();
	}
	
	private inline function _init():Void
	{
		requiresModules = new Array<String>();
		assets = new Map< String, Asset>();
	}
}