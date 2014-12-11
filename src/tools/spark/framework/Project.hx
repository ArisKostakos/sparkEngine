/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2014
 */

package tools.spark.framework;
import tools.spark.framework.config.ENodeType;
import tools.spark.framework.assets.Module;

/**
 * ...
 * @author Aris Kostakos
 */
class Project
{
	public static var name( default, default ):String;
	public static var version( default, default ):String;
	public static var type( default, default ):ENodeType;
	public static var executeModules( default, null ):Array< String>;
	public static var sliced( default, null ):Map< ENodeType, String>;
	public static var paths( default, null ):Map< String, Map < String, String > >; //Location, Type, Url
	public static var modules( default, null ):Map< String, Module>;
	
	public static function init():Void
	{
		executeModules = new Array< String>();
		sliced = new Map< ENodeType, String>();
		paths = new Map< String, Map < String, String > >();
		modules = new Map< String, Module>();
	}
	
	public static function setPath(p_location:String, p_type:String, p_url):Void
	{
		if (paths[p_location] == null) paths[p_location] = new Map<String, String>();
		
		paths[p_location][p_type] = p_url;
	}
	
	public static function getPath(p_location: String, p_type:String):String
	{
		if (paths[p_location] == null) return null;
		
		return paths[p_location][p_type];
	}
}