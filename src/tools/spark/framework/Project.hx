/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2014
 */

package tools.spark.framework;
import tools.spark.framework.config.ENodeType;
import tools.spark.framework.assets.Module;
import tools.spark.sliced.core.Sliced;

/**
 * ...
 * @author Aris Kostakos
 */
@:keep class Project
{
	public static var main( default, default ):Project;
	private static var _typeToString:Map<ENodeType,String>; //temp
	
	public var name( default, default ):String;
	public var version( default, default ):String;
	public var type( default, default ):ENodeType;
	public var executeModules( default, null ):Array< String>;
	public var sliced( default, default ):Map< ENodeType, String>;
	public var paths( default, null ):Map< String, Map < String, String > >; //Location, Type, Url
	public var modules( default, null ):Map< String, Module>;
	
	public static function init():Void
	{
		main = new Project(); //Singleton
		_initNodeNamesMap(); //temp
	}
	
	public function new() 
	{
		executeModules = new Array< String>();
		sliced = new Map< ENodeType, String>();
		paths = new Map< String, Map < String, String > >();
		modules = new Map< String, Module>();
	}
	
	public function setPath(p_location:String, p_type:String, p_url):Void
	{
		if (paths[p_location] == null) paths[p_location] = new Map<String, String>();
		
		paths[p_location][p_type] = p_url;
	}
	
	public function getPath(p_location: String, p_type:String):String
	{
		if (paths[p_location] == null) return null;
		
		return paths[p_location][p_type];
	}
	
	public function exportToXml():Xml
	{
		//Client
		var l_xmlClient:Xml = Sliced.logic.xml_createElement(_typeToString[ENodeType.CLIENT]);
		
		//Project
		var l_xmlProject:Xml = Sliced.logic.xml_createElement(_typeToString[ENodeType.PROJECT]);
		l_xmlClient.addChild(l_xmlProject);
		
		//Name
		l_xmlProject.addChild(Sliced.logic.xml_createElement(_typeToString[ENodeType.PROJECT_NAME], name));
		
		//Version
		l_xmlProject.addChild(Sliced.logic.xml_createElement(_typeToString[ENodeType.PROJECT_VERSION], version));
		
		//ExecuteAtLaunch
		var l_xmlExecuteAtLaunch:Xml = Sliced.logic.xml_createElement(_typeToString[ENodeType.EXECUTE_AT_LAUNCH]);
		l_xmlProject.addChild(l_xmlExecuteAtLaunch);
		for (executeModule in executeModules)
			l_xmlExecuteAtLaunch.addChild(Sliced.logic.xml_createElement(_typeToString[ENodeType.EXECUTE_MODULE], executeModule));
			
		//Sliced
		var l_xmlSliced:Xml = Sliced.logic.xml_createElement(_typeToString[ENodeType.SLICED]);
		l_xmlClient.addChild(l_xmlSliced);
		for (slicedKeyEntry in sliced.keys())
			l_xmlSliced.addChild(Sliced.logic.xml_createElement(_typeToString[slicedKeyEntry], sliced[slicedKeyEntry]));
			
		//Paths
		var l_xmlPaths:Xml = Sliced.logic.xml_createElement(_typeToString[ENodeType.PATHS]);
		l_xmlClient.addChild(l_xmlPaths);
		for (pathKeyEntry in paths.keys())
		{
			var f_pathLocation:Map<String,String> = paths[pathKeyEntry];
			
			for (pathLocationKeyEntry in f_pathLocation.keys())
			{
				var l_xmlPath = Sliced.logic.xml_createElement(_typeToString[ENodeType.PATH], f_pathLocation[pathLocationKeyEntry]);
				l_xmlPath.set("location", pathKeyEntry);
				l_xmlPath.set("type", pathLocationKeyEntry);
				l_xmlPaths.addChild(l_xmlPath);
			}
		}
		
		//Assets
		var l_xmlAssets:Xml = Sliced.logic.xml_createElement(_typeToString[ENodeType.ASSETS]);
		l_xmlClient.addChild(l_xmlAssets);
		
		//Modules
		for (module in modules)
		{
			//Module
			var l_xmlModule:Xml = Sliced.logic.xml_createElement(_typeToString[ENodeType.MODULE]);
			l_xmlAssets.addChild(l_xmlModule);
			
			//Id
			l_xmlModule.set("id", module.id);
			
			//Execute Entity
			if (module.executeEntity!=null)
				l_xmlModule.set("executeEntity", module.executeEntity);
				
			//Requires
			if (module.requiresModules.length > 0)
			{
				//Requires Node
				var l_xmlRequires:Xml = Sliced.logic.xml_createElement(_typeToString[ENodeType.REQUIRES]);
				l_xmlModule.addChild(l_xmlRequires);
				
				//Requires Modules
				for (requiresModule in module.requiresModules)
					l_xmlRequires.addChild(Sliced.logic.xml_createElement(_typeToString[ENodeType.REQUIRES_MODULE], requiresModule));
			}
			
			//Asset
			for (asset in module.assets)
			{
				//Asset Xml & Url
				var l_xmlAsset:Xml = Sliced.logic.xml_createElement(_typeToString[ENodeType.ASSET], asset.url);
				l_xmlModule.addChild(l_xmlAsset);
				
				//Asset Properties
				if (asset.id != null)
					l_xmlAsset.set("id", asset.id);
				if (asset.type != null)
					l_xmlAsset.set("type", asset.type);
				if (asset.subtype != null)
					l_xmlAsset.set("subtype", asset.subtype);
				if (asset.location != null)
					l_xmlAsset.set("location", asset.location);
				if (asset.bytes != null)
					l_xmlAsset.set("bytes", asset.bytes);
				if (asset.condition != null)
					l_xmlAsset.set("condition", asset.condition);
				if (asset.forceLoadAsData != null)
					l_xmlAsset.set("forceLoadAsData", asset.forceLoadAsData);
			}
		}
		
		
		
		
		return l_xmlClient;
	}
	
	//Mapping //WARNING... I CLITERALY LIFTED THIS FROM Config.hx because to lazy to access Config.hx..
	//Duplicate mapping!!! Fix it soon pllzzz!
	private static function _initNodeNamesMap():Void
	{
		_typeToString = new Map<ENodeType,String>();
		
		_typeToString[ENodeType.CLIENT] = "Client";
		_typeToString[ENodeType.SERVER] = "Server";
		_typeToString[ENodeType.PROJECT] = "Project";
		_typeToString[ENodeType.SLICED] = "Sliced";
		_typeToString[ENodeType.PATHS] = "Paths";
		_typeToString[ENodeType.ASSETS] = "Assets";
		_typeToString[ENodeType.PROJECT_NAME] = "Name";
		_typeToString[ENodeType.PROJECT_VERSION] = "Version";
		_typeToString[ENodeType.EXECUTE_AT_LAUNCH] = "ExecuteAtLaunch";
		_typeToString[ENodeType.EXECUTE_MODULE] = "ExecuteModule";
		_typeToString[ENodeType.SOUND_SERVICE] = "Sound";
		_typeToString[ENodeType.LOGIC_SERVICE] = "Logic";
		_typeToString[ENodeType.INPUT_SERVICE] = "Input";
		_typeToString[ENodeType.COMMUNICATIONS_SERVICE] = "Comms";
		_typeToString[ENodeType.EVENT_SERVICE] = "Event";
		_typeToString[ENodeType.DISPLAY_SERVICE] = "Display";
		_typeToString[ENodeType.PATH] = "Path";
		_typeToString[ENodeType.MODULE] = "Module";
		_typeToString[ENodeType.ASSET] = "Asset";
		_typeToString[ENodeType.REQUIRES] = "Requires";
		_typeToString[ENodeType.REQUIRES_MODULE] = "RequiresModule";
	}
}