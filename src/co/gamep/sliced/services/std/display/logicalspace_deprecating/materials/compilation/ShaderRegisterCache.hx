package co.gamep.sliced.services.std.display.logicalspace.materials.compilation;

class ShaderRegisterCache {
	public var fragmentConstantOffset : Int;
	public var fragmentOutputRegister(default,never) : ShaderRegisterElement;
	public var numUsedFragmentConstants(default,never) : Int;
	public var numUsedStreams(default,never) : Int;
	public var numUsedTextures(default,never) : Int;
	public var numUsedVaryings(default,never) : Int;
	public var numUsedVertexConstants(default,never) : Int;
	public var varyingsOffset : Int;
	public var vertexAttributesOffset : Int;
	public var vertexConstantOffset : Int;
	public function new():Void {super();}}
