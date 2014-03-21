package co.gamep.sliced.services.std.display.logicalspace.materials.passes;

class CompiledPass extends MaterialPassBase {
	public var _passes : Dynamic;
	public var _passesDirty : Bool;
	public var ambientMethod : co.gamep.sliced.services.std.display.logicalspace.materials.methods.BasicAmbientMethod;
	public var animateUVs : Bool;
	public var diffuseLightSources : Int;
	public var diffuseMethod : co.gamep.sliced.services.std.display.logicalspace.materials.methods.BasicDiffuseMethod;
	public var enableLightFallOff : Bool;
	public var forceSeparateMVP : Bool;
	public var normalMap : co.gamep.sliced.services.std.display.logicalspace.textures.Texture2DBase;
	public var normalMethod : co.gamep.sliced.services.std.display.logicalspace.materials.methods.BasicNormalMethod;
	public var numDirectionalLights(default,never) : Int;
	public var numLightProbes(default,never) : Int;
	public var numPointLights(default,never) : Int;
	public var preserveAlpha : Bool;
	public var shadowMethod : co.gamep.sliced.services.std.display.logicalspace.materials.methods.ShadowMapMethodBase;
	public var specularLightSources : Int;
	public var specularMethod : co.gamep.sliced.services.std.display.logicalspace.materials.methods.BasicSpecularMethod;
	public function new():Void {super();}}
