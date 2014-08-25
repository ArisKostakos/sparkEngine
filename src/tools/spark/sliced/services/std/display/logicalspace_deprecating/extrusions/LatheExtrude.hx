package tools.spark.sliced.services.std.display.logicalspace.extrusions;

class LatheExtrude extends tools.spark.sliced.services.std.display.logicalspace.entities.Mesh {
	public var axis : String;
	public var centerMesh : Bool;
	public var coverAll : Bool;
	public var flip : Bool;
	public var ignoreSides : String;
	public var keepLastProfile : Bool;
	public var lastProfile(default,never) : Dynamic;
	public var materials : tools.spark.sliced.services.std.display.logicalspace.materials.utils.MultipleMaterials;
	public var offsetRadius : Float;
	public var preciseThickness : Bool;
	public var profile : Dynamic;
	public var revolutions : Float;
	public var smoothSurface : Bool;
	public var startRotationOffset : Float;
	public var subdivision : Int;
	public var thickness : Float;
	public var tweek : Dynamic;
	public function new():Void {super();}}
