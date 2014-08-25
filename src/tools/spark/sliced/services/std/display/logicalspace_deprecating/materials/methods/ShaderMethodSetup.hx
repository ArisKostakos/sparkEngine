package tools.spark.sliced.services.std.display.logicalspace.materials.methods;

class ShaderMethodSetup {
	public var _ambientMethod : BasicAmbientMethod;
	public var _ambientMethodVO : MethodVO;
	public var _colorTransformMethod : ColorTransformMethod;
	public var _colorTransformMethodVO : MethodVO;
	public var _diffuseMethod : BasicDiffuseMethod;
	public var _diffuseMethodVO : MethodVO;
	public var _methods : Dynamic;
	public var _normalMethod : BasicNormalMethod;
	public var _normalMethodVO : MethodVO;
	public var _shadowMethod : ShadowMapMethodBase;
	public var _shadowMethodVO : MethodVO;
	public var _specularMethod : BasicSpecularMethod;
	public var _specularMethodVO : MethodVO;
	public var ambientMethod : BasicAmbientMethod;
	public var colorTransformMethod : ColorTransformMethod;
	public var diffuseMethod : BasicDiffuseMethod;
	public var normalMethod : BasicNormalMethod;
	public var numMethods(default,never) : Int;
	public var shadowMethod : ShadowMapMethodBase;
	public var specularMethod : BasicSpecularMethod;
	public function new():Void {super();}}
