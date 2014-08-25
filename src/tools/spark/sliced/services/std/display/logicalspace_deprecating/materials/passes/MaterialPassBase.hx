package tools.spark.sliced.services.std.display.logicalspace.materials.passes;

class MaterialPassBase {
	public var _program3Dids : Dynamic;
	public var _program3Ds : Dynamic;
	public var alphaPremultiplied : Bool;
	public var animationRegisterCache : tools.spark.sliced.services.std.display.logicalspace.animators.data.AnimationRegisterCache;
	public var animationSet : tools.spark.sliced.services.std.display.logicalspace.animators.IAnimationSet;
	public var bothSides : Bool;
	public var depthCompareMode : String;
	public var lightPicker : tools.spark.sliced.services.std.display.logicalspace.materials.lightpickers.LightPickerBase;
	public var material : tools.spark.sliced.services.std.display.logicalspace.materials.MaterialBase;
	public var mipmap : Bool;
	public var needFragmentAnimation(default,never) : Bool;
	public var needUVAnimation(default,never) : Bool;
	public var numUsedFragmentConstants(default,never) : Int;
	public var numUsedStreams(default,never) : Int;
	public var numUsedVaryings(default,never) : Int;
	public var numUsedVertexConstants(default,never) : Int;
	public var renderToTexture(default,never) : Bool;
	public var repeat : Bool;
	public var smooth : Bool;
	public var writeDepth : Bool;
	public function new():Void {super();}}
