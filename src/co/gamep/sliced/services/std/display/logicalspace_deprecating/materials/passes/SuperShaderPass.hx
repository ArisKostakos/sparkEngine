package co.gamep.sliced.services.std.display.logicalspace.materials.passes;

class SuperShaderPass extends CompiledPass {
	public var colorTransform : Dynamic;
	public var colorTransformMethod : co.gamep.sliced.services.std.display.logicalspace.materials.methods.ColorTransformMethod;
	public var ignoreLights : Bool;
	public var includeCasters : Bool;
	public var numMethods(default,never) : Int;
	public function new():Void {super();}}
