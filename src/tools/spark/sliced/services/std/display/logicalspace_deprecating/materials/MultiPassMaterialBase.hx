package tools.spark.sliced.services.std.display.logicalspace.materials;

class MultiPassMaterialBase extends MaterialBase {
	public var alphaThreshold : Float;
	public var ambient : Float;
	public var ambientColor : Int;
	public var ambientMethod : tools.spark.sliced.services.std.display.logicalspace.materials.methods.BasicAmbientMethod;
	public var diffuseLightSources : Int;
	public var diffuseMethod : tools.spark.sliced.services.std.display.logicalspace.materials.methods.BasicDiffuseMethod;
	public var enableLightFallOff : Bool;
	public var gloss : Float;
	public var normalMap : tools.spark.sliced.services.std.display.logicalspace.textures.Texture2DBase;
	public var normalMethod : tools.spark.sliced.services.std.display.logicalspace.materials.methods.BasicNormalMethod;
	public var numMethods(default,never) : Int;
	public var shadowMethod : tools.spark.sliced.services.std.display.logicalspace.materials.methods.ShadowMapMethodBase;
	public var specular : Float;
	public var specularColor : Int;
	public var specularLightSources : Int;
	public var specularMap : tools.spark.sliced.services.std.display.logicalspace.textures.Texture2DBase;
	public var specularMethod : tools.spark.sliced.services.std.display.logicalspace.materials.methods.BasicSpecularMethod;
	public function new():Void {super();}}
