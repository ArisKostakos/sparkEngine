package co.gamep.sliced.services.std.display.logicalspace.materials.compilation;

class LightingShaderCompiler extends ShaderCompiler {
	public var _dirLightFragmentConstants : Dynamic;
	public var _dirLightVertexConstants : Dynamic;
	public var _pointLightFragmentConstants : Dynamic;
	public var _pointLightVertexConstants : Dynamic;
	public var lightVertexConstantIndex(default,never) : Int;
	public var tangentSpace(default,never) : Bool;
	public function new():Void {super();}}
