package co.gamep.sliced.services.std.display.logicalspace.lights;

class LightBase extends co.gamep.sliced.services.std.display.logicalspace.entities.Entity {
	public var _ambientB : Float;
	public var _ambientG : Float;
	public var _ambientR : Float;
	public var _diffuseB : Float;
	public var _diffuseG : Float;
	public var _diffuseR : Float;
	public var _specularB : Float;
	public var _specularG : Float;
	public var _specularR : Float;
	public var ambient : Float;
	public var ambientColor : Int;
	public var castsShadows : Bool;
	public var color : Int;
	public var diffuse : Float;
	public var shadowMapper : co.gamep.sliced.services.std.display.logicalspace.lights.shadowmaps.ShadowMapperBase;
	public var specular : Float;
	public function new():Void {super();}}
