package tools.spark.sliced.services.std.display.logicalspace.loaders.parsers;

class ParserBase {
	public var _fileName : String;
	public var dataFormat(default,never) : String;
	public var dependencies(default,never) : Dynamic;
	public var materialMode : Int;
	public var parsingComplete(default,never) : Bool;
	public var parsingFailure : Bool;
	public var parsingPaused(default,never) : Bool;
	public function new():Void {super();}}
