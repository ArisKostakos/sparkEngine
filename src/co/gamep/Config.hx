/* Copyright © Game Plus Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, October 2013
 */

package co.gamep;

/**
 * ...
 * @author Aris Kostakos
 */
class Config
{
	public static var config( default, null ):Map<String,Dynamic>;
	
	//@todo: Validate config.xml before using it, if you decide to
	//not make it loose for flexibility.
	public static function init(p_configString:String):Void
	{
		config = new Map<String,Dynamic>();
		
		if ( ( p_configString != null ) && ( p_configString.substr( 0, 5 ) == "<?xml" ) )
		{
			_traverseElements( Xml.parse( p_configString ).firstElement().elements(), "" );
		}
	}
	
	public static function getConfig( p_id:String ):Dynamic
	{
		return config.exists( p_id ) ? config.get( p_id ) : null;
	}
	
	private static function _traverseElements( p_elements:Iterator<Xml>, p_prefix:String ):Void
	{
		if ( p_prefix.length != 0 )
		{
			p_prefix += ".";
		}
		for ( i in p_elements )
		{
			var l_name:String = p_prefix + i.nodeName;
			if ( i.elements().hasNext() )
			{
				_traverseElements( i.elements(), l_name );
			}
			if ( ( i.firstChild() != null ) && ( i.firstChild().toString().substr( 0, 9 ) == "<![CDATA[" ) )
			{
				i.firstChild().nodeValue = i.firstChild().toString().split( "<![CDATA[" ).join( "" ).split( "]]>" ).join( "" );
			}
			config.set( l_name, i.firstChild() == null ? "" : i.firstChild().nodeValue );
			//trace( l_name + " = " + config.get( l_name ) );
			for ( j in i.attributes() )
			{
				var l_aName:String = l_name + "." + j;
				config.set( l_aName, i.get( j ) );
				//trace( l_aName + " = " + config.get( l_aName ) );
			}
		}
	}
}