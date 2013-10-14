/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, September 2013
 */

 package org.gamepl.awe6.core;

/**
 * ...
 * @author	Aris Kostakos
 */
#if awe6DriverRemap
typedef InputKeyboard = haxe.macro.MacroType<[ awe6.core.Macros.driverRemap( "InputKeyboard" ) ]>;
#elseif cpp
typedef InputKeyboard = org.gamepl.awe6.core.drivers.openfl.native.InputKeyboard;
#elseif flash
typedef InputKeyboard = org.gamepl.awe6.core.drivers.flash.InputKeyboard;
#elseif js
typedef InputKeyboard = org.gamepl.awe6.core.drivers.openfl.html5.InputKeyboard;
#else
typedef InputKeyboard = org.gamepl.awe6.core.drivers.AInputKeyboard;
#end