package tools.spark.sliced.services.std.display.logicalspace.lights.shadowmaps;

class ShadowMapperBase {
	public var _shadowsInvalid : Bool;
	public var autoUpdateShadows : Bool;
	public var depthMap(default,never) : tools.spark.sliced.services.std.display.logicalspace.textures.TextureProxyBase;
	public var depthMapSize : Int;
	public var light : tools.spark.sliced.services.std.display.logicalspace.lights.LightBase;
	public function new():Void {}}
