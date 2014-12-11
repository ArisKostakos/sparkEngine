package tools.spark.framework.assets;

/**
 * ...
 * @author Aris Kostakos
 */
class Asset
{
	public var id(default, null):String;
	public var url(default, default):String;
	public var type(default, default):String;
	public var subtype(default, default):String;
	public var location(default, default):String;
	public var bytes(default, default):String;
	public var condition(default, default):String;
	public var forceLoadAsData(default, default):String;
	
	public function new(p_id:String) 
	{
		id = p_id;
	}
}