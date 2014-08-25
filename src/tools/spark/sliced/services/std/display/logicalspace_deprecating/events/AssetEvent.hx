package tools.spark.sliced.services.std.display.logicalspace.events;

class AssetEvent  {
	public var asset(default,never) : tools.spark.sliced.services.std.display.logicalspace.library.assets.IAsset;
	public var assetPrevName(default,never) : String;
	public function new():Void {super();}}
