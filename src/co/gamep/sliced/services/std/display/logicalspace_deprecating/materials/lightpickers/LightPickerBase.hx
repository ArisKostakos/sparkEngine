package co.gamep.sliced.services.std.display.logicalspace.materials.lightpickers;

class LightPickerBase extends co.gamep.sliced.services.std.display.logicalspace.library.assets.NamedAssetBase implements co.gamep.sliced.services.std.display.logicalspace.library.assets.IAsset {
	public var allPickedLights(default,never) : Dynamic;
	public var assetType(default,never) : String;
	public var castingDirectionalLights(default,never) : Dynamic;
	public var castingPointLights(default,never) : Dynamic;
	public var directionalLights(default,never) : Dynamic;
	public var lightProbeWeights(default,never) : Dynamic;
	public var lightProbes(default,never) : Dynamic;
	public var numCastingDirectionalLights(default,never) : Int;
	public var numCastingPointLights(default,never) : Int;
	public var numDirectionalLights(default,never) : Int;
	public var numLightProbes(default,never) : Int;
	public var numPointLights(default,never) : Int;
	public var pointLights(default,never) : Dynamic;
	public function new():Void {super();}}
