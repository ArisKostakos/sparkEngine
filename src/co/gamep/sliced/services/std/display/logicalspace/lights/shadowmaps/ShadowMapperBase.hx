package co.gamep.sliced.services.std.display.logicalspace.lights.shadowmaps;

class ShadowMapperBase {
	public var _shadowsInvalid : Bool;
	public var autoUpdateShadows : Bool;
	public var depthMap(default,never) : co.gamep.sliced.services.std.display.logicalspace.textures.TextureProxyBase;
	public var depthMapSize : Int;
	public var light : co.gamep.sliced.services.std.display.logicalspace.lights.LightBase;
	public function new():Void {super();}}
