package tools.spark.sliced.services.std.display.logicalspace.animators.data;

class AnimationRegisterCache extends tools.spark.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterCache {
	public var colorAddTarget : tools.spark.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var colorAddVary : tools.spark.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var colorMulTarget : tools.spark.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var colorMulVary : tools.spark.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var fragmentConstantData : Dynamic;
	public var hasBillboard : Bool;
	public var hasColorAddNode : Bool;
	public var hasColorMulNode : Bool;
	public var hasUVNode : Bool;
	public var needFragmentAnimation : Bool;
	public var needUVAnimation : Bool;
	public var needVelocity : Bool;
	public var numFragmentConstant(default,never) : Int;
	public var numVertexConstant(default,never) : Int;
	public var positionAttribute : tools.spark.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var positionTarget : tools.spark.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var rotationRegisters : Dynamic;
	public var scaleAndRotateTarget : tools.spark.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var sourceRegisters : Dynamic;
	public var targetRegisters : Dynamic;
	public var uvAttribute : tools.spark.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var uvTarget : tools.spark.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var uvVar : tools.spark.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var velocityTarget : tools.spark.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var vertexConstantData : Dynamic;
	public var vertexLife : tools.spark.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var vertexOneConst : tools.spark.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var vertexTime : tools.spark.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var vertexTwoConst : tools.spark.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var vertexZeroConst : tools.spark.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public function new():Void {super();}}
