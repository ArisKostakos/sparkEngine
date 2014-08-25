package tools.spark.sliced.services.std.display.logicalspace.materials.methods;

class BasicSpecularMethod extends LightingMethodBase {
	public var _specularB : Float;
	public var _specularG : Float;
	public var _specularR : Float;
	public var gloss : Float;
	public var shadowRegister(never,default) : tools.spark.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var specular : Float;
	public var specularColor : Int;
	public var texture : tools.spark.sliced.services.std.display.logicalspace.textures.Texture2DBase;
	public function new():Void {super();}}
