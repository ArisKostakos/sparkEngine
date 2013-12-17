package co.gamep.sliced.services.std.display.logicalspace.animators.data;

class AnimationRegisterCache extends co.gamep.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterCache {
	public var colorAddTarget : co.gamep.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var colorAddVary : co.gamep.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var colorMulTarget : co.gamep.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var colorMulVary : co.gamep.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
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
	public var positionAttribute : co.gamep.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var positionTarget : co.gamep.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var rotationRegisters : Dynamic;
	public var scaleAndRotateTarget : co.gamep.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var sourceRegisters : Dynamic;
	public var targetRegisters : Dynamic;
	public var uvAttribute : co.gamep.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var uvTarget : co.gamep.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var uvVar : co.gamep.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var velocityTarget : co.gamep.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var vertexConstantData : Dynamic;
	public var vertexLife : co.gamep.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var vertexOneConst : co.gamep.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var vertexTime : co.gamep.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var vertexTwoConst : co.gamep.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public var vertexZeroConst : co.gamep.sliced.services.std.display.logicalspace.materials.compilation.ShaderRegisterElement;
	public function new():Void {super();}}
