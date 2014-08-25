package tools.spark.sliced.services.std.display.logicalspace.extrusions;

class PathExtrude extends tools.spark.sliced.services.std.display.logicalspace.entities.Mesh {
	public var alignToPath(never,default) : Bool;
	public var aligntoPath(default,never) : Bool;
	public var centerMesh : Bool;
	public var closePath : Bool;
	public var coverAll : Bool;
	public var coverSegment : Bool;
	public var distribute : Bool;
	public var distributeU : Bool;
	public var endProfile(default,never) : Dynamic;
	public var flip : Bool;
	public var keepExtremes : Bool;
	public var mapFit : Bool;
	public var materials : Dynamic;
	public var path : tools.spark.sliced.services.std.display.logicalspace.paths.IPath;
	public var profile : Dynamic;
	public var rotations : Dynamic;
	public var scales : Dynamic;
	public var smoothScale : Bool;
	public var smoothSurface : Bool;
	public var startProfile(default,never) : Dynamic;
	public var subdivision : Int;
	public var upAxis : Dynamic;
	public function new():Void {super();}}
