package co.gamep.sliced.services.std.display.logicalspace.materials.methods;

class ShadowMapMethodBase extends ShadingMethodBase implements co.gamep.sliced.services.std.display.logicalspace.library.assets.IAsset {
	public var alpha : Float;
	public var assetType(default,never) : String;
	public var castingLight(default,never) : co.gamep.sliced.services.std.display.logicalspace.lights.LightBase;
	public var epsilon : Float;
	public function new():Void {super();}}
