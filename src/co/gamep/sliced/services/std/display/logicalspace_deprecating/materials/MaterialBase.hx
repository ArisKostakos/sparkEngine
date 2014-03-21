package co.gamep.sliced.services.std.display.logicalspace.materials;

class MaterialBase extends co.gamep.sliced.services.std.display.logicalspace.library.assets.NamedAssetBase implements co.gamep.sliced.services.std.display.logicalspace.library.assets.IAsset {
	public var _classification : String;
	public var _depthPassId : Int;
	public var _renderOrderId : Int;
	public var _uniqueId : Int;
	public var alphaPremultiplied : Bool;
	public var assetType(default,never) : String;
	public var blendMode : String;
	public var bothSides : Bool;
	public var depthCompareMode : String;
	public var extra : Dynamic;
	public var lightPicker : co.gamep.sliced.services.std.display.logicalspace.materials.lightpickers.LightPickerBase;
	public var mipmap : Bool;
	public var numPasses(default,never) : Int;
	public var owners(default,never) : Dynamic;
	public var repeat : Bool;
	public var requiresBlending(default,never) : Bool;
	public var smooth : Bool;
	public var uniqueId(default,never) : Int;
	public function new():Void {super();}}
