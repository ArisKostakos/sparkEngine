/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, September 2013
 */

package org.gamepl.coreservices.services.std.input.core;

import org.gamepl.coreservices.core.Game;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.EEventType;
import awe6.interfaces.EKey;
import awe6.interfaces.IKernel;
import org.gamepl.coreservices.interfaces.IInput;
import org.gamepl.coreservices.core.AService;

/**
 * ...
 * @author Aris Kostakos
 */
class Input extends AService implements IInput
{
	private var _convertKeycodeToEKeyOptimized:Map<Int,EKey>;
	private var _keysDown:Array<EKey>;
	private var _keysUp:Array<EKey>;

	public function new(p_kernel:IKernel) 
	{
		super(p_kernel);
		
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init Input std Service...");
		
		_initConvertKeycodeToEKeyOptimizedMap();
		_keysDown = new Array<EKey>();
		_keysUp = new Array<EKey>();
	}
	
	public function registerKeyEvent(p_keyCode:Int, p_keyDown: Bool):Void
	{
		var key:EKey = _convertKeycodeToEKeyOptimized[p_keyCode];
		
		if (key == null)
			Console.warn('Key with keycode: $p_keyCode was detected but was not recognized!');
		
		if (p_keyDown)
		{
			_keysDown.push(key);
		}
		else
		{
			_keysUp.push(key);
		}
	}
	
	public function update():Void
	{
		while (_keysDown.length>0)
		{
			Game.event.raiseEvent(EEventType.KEY_PRESSED, _keysDown.pop());
		}
		
		while (_keysUp.length>0)
		{
			Game.event.raiseEvent(EEventType.KEY_RELEASED, _keysUp.pop());
		}
	}
	
	public function isKeyPressed( type:EKey ):Bool
	{
		return _kernel.inputs.keyboard.getIsKeyPress(type);
	}

	public function isKeyReleased( type:EKey ):Bool
	{
		return _kernel.inputs.keyboard.getIsKeyRelease(type);
	}
	
	private function _initConvertKeycodeToEKeyOptimizedMap():Void
	{
		_convertKeycodeToEKeyOptimized = new Map<Int,EKey>();
		
		_convertKeycodeToEKeyOptimized[144] = NUM_LOCK;
		_convertKeycodeToEKeyOptimized[12] = CLEAR;
		_convertKeycodeToEKeyOptimized[47] = HELP;
		_convertKeycodeToEKeyOptimized[18] = ALT;
		_convertKeycodeToEKeyOptimized[8] = BACKSPACE;
		_convertKeycodeToEKeyOptimized[20] = CAPS_LOCK;
		_convertKeycodeToEKeyOptimized[17] = CONTROL;
		_convertKeycodeToEKeyOptimized[46] = DELETE;
		_convertKeycodeToEKeyOptimized[40] = DOWN;
		_convertKeycodeToEKeyOptimized[35] = END;
		_convertKeycodeToEKeyOptimized[13] = ENTER;
		_convertKeycodeToEKeyOptimized[27] = ESCAPE;
		_convertKeycodeToEKeyOptimized[112] = F1;
		_convertKeycodeToEKeyOptimized[121] = F10;
		_convertKeycodeToEKeyOptimized[122] = F11;
		_convertKeycodeToEKeyOptimized[123] = F12;
		_convertKeycodeToEKeyOptimized[124] = F13;
		_convertKeycodeToEKeyOptimized[125] = F14;
		_convertKeycodeToEKeyOptimized[126] = F15;
		_convertKeycodeToEKeyOptimized[113] = F2;
		_convertKeycodeToEKeyOptimized[114] = F3;
		_convertKeycodeToEKeyOptimized[115] = F4;
		_convertKeycodeToEKeyOptimized[116] = F5;
		_convertKeycodeToEKeyOptimized[117] = F6;
		_convertKeycodeToEKeyOptimized[118] = F7;
		_convertKeycodeToEKeyOptimized[119] = F8;
		_convertKeycodeToEKeyOptimized[120] = F9;
		_convertKeycodeToEKeyOptimized[36] = HOME;
		_convertKeycodeToEKeyOptimized[45] = INSERT;
		_convertKeycodeToEKeyOptimized[37] = LEFT;
		_convertKeycodeToEKeyOptimized[96] = NUMPAD_0;
		_convertKeycodeToEKeyOptimized[97] = NUMPAD_1;
		_convertKeycodeToEKeyOptimized[98] = NUMPAD_2;
		_convertKeycodeToEKeyOptimized[99] = NUMPAD_3;
		_convertKeycodeToEKeyOptimized[100] = NUMPAD_4;
		_convertKeycodeToEKeyOptimized[101] = NUMPAD_5;
		_convertKeycodeToEKeyOptimized[102] = NUMPAD_6;
		_convertKeycodeToEKeyOptimized[103] = NUMPAD_7;
		_convertKeycodeToEKeyOptimized[104] = NUMPAD_8;
		_convertKeycodeToEKeyOptimized[105] = NUMPAD_9;
		_convertKeycodeToEKeyOptimized[107] = NUMPAD_ADD;
		_convertKeycodeToEKeyOptimized[110] = NUMPAD_DECIMAL;
		_convertKeycodeToEKeyOptimized[111] = NUMPAD_DIVIDE;
		_convertKeycodeToEKeyOptimized[108] = NUMPAD_ENTER;
		_convertKeycodeToEKeyOptimized[106] = NUMPAD_MULTIPLY;
		_convertKeycodeToEKeyOptimized[109] = NUMPAD_SUBTRACT;
		_convertKeycodeToEKeyOptimized[34] = PAGE_DOWN;
		_convertKeycodeToEKeyOptimized[33] = PAGE_UP;
		_convertKeycodeToEKeyOptimized[39] = RIGHT;
		_convertKeycodeToEKeyOptimized[16] = SHIFT;
		_convertKeycodeToEKeyOptimized[32] = SPACE;
		_convertKeycodeToEKeyOptimized[9] = TAB;
		_convertKeycodeToEKeyOptimized[38] = UP;
		_convertKeycodeToEKeyOptimized[65] = A;
		_convertKeycodeToEKeyOptimized[66] = B;
		_convertKeycodeToEKeyOptimized[67] = C;
		_convertKeycodeToEKeyOptimized[68] = D;
		_convertKeycodeToEKeyOptimized[69] = E;
		_convertKeycodeToEKeyOptimized[70] = F;
		_convertKeycodeToEKeyOptimized[71] = G;
		_convertKeycodeToEKeyOptimized[72] = H;
		_convertKeycodeToEKeyOptimized[73] = I;
		_convertKeycodeToEKeyOptimized[74] = J;
		_convertKeycodeToEKeyOptimized[75] = K;
		_convertKeycodeToEKeyOptimized[76] = L;
		_convertKeycodeToEKeyOptimized[77] = M;
		_convertKeycodeToEKeyOptimized[78] = N;
		_convertKeycodeToEKeyOptimized[79] = O;
		_convertKeycodeToEKeyOptimized[80] = P;
		_convertKeycodeToEKeyOptimized[81] = Q;
		_convertKeycodeToEKeyOptimized[82] = R;
		_convertKeycodeToEKeyOptimized[83] = S;
		_convertKeycodeToEKeyOptimized[84] = T;
		_convertKeycodeToEKeyOptimized[85] = U;
		_convertKeycodeToEKeyOptimized[86] = V;
		_convertKeycodeToEKeyOptimized[87] = W;
		_convertKeycodeToEKeyOptimized[88] = X;
		_convertKeycodeToEKeyOptimized[89] = Y;
		_convertKeycodeToEKeyOptimized[90] = Z;
		_convertKeycodeToEKeyOptimized[48] = NUMBER_0;
		_convertKeycodeToEKeyOptimized[49] = NUMBER_1;
		_convertKeycodeToEKeyOptimized[50] = NUMBER_2;
		_convertKeycodeToEKeyOptimized[51] = NUMBER_3;
		_convertKeycodeToEKeyOptimized[52] = NUMBER_4;
		_convertKeycodeToEKeyOptimized[53] = NUMBER_5;
		_convertKeycodeToEKeyOptimized[54] = NUMBER_6;
		_convertKeycodeToEKeyOptimized[55] = NUMBER_7;
		_convertKeycodeToEKeyOptimized[56] = NUMBER_8;
		_convertKeycodeToEKeyOptimized[57] = NUMBER_9;
		_convertKeycodeToEKeyOptimized[186] = COLON;
		_convertKeycodeToEKeyOptimized[187] = EQUALS;
		_convertKeycodeToEKeyOptimized[189] = HYPHEN;
		_convertKeycodeToEKeyOptimized[191] = SLASH;
		_convertKeycodeToEKeyOptimized[222] = TILDE;
		_convertKeycodeToEKeyOptimized[219] = SQUARELEFT;
		_convertKeycodeToEKeyOptimized[221] = SQUARERIGHT;
		_convertKeycodeToEKeyOptimized[220] = BACKSLASH;
		_convertKeycodeToEKeyOptimized[192] = APOSTROPHE;
		_convertKeycodeToEKeyOptimized[223] = TOPLEFT;
	}
}