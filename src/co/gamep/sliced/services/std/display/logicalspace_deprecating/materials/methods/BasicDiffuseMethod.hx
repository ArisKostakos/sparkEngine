package co.gamep.sliced.services.std.display.logicalspace.materials.methods;

class BasicDiffuseMethod extends LightingMethodBase {
	public var _totalLightColorReg : co.gamep.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var alphaThreshold : Float;
	public var diffuseAlpha : Float;
	public var diffuseColor : Int;
	public var shadowRegister(never,default) : co.gamep.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var texture : co.gamep.sliced.services.std.display.logicalspace.textures.Texture2DBase;
	public var useAmbientTexture : Bool;
	public function new():Void {super();}}
