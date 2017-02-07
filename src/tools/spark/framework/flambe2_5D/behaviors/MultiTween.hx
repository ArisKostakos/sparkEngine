package tools.spark.framework.flambe2_5D.behaviors;

import flambe.animation.Behavior;
import flambe.animation.Ease;
import flambe.animation.Tween;

//Tweens to the 'to' value, then back to the 'from' value, using Easing for both tweens.
//the accelerationPercent is 0 to 1, and when its 1, it means 0.5*duration
class MultiTween
    implements Behavior
{
    public var elapsed (default, null) :Float;

    //public function new (from :Float, to :Float, seconds :Float, ?easing :EaseFunction)
	public function new (from :Float, to :Float, seconds :Float, accelerationPercent:Float, easeIn:EaseFunction, easeOut:EaseFunction)
    {
        _from = from;
        _to = to;
        _duration = seconds;
        elapsed = 0;
		
		_tweenIn = new Tween(from, to, seconds / 2 * accelerationPercent, easeIn);
		_tweenIn = new Tween(to, from, seconds / 2 * accelerationPercent, easeOut);
    }

    public function update (dt :Float) :Float
    {
        elapsed += dt;
		
		
		
		return;
        if (elapsed >= _duration) {
            return _to;
        } else {
            return _from + (_to - _from)*_easeIn(elapsed/_duration);
        }
    }

    public function isComplete () :Bool
    {
        return elapsed >= _duration;
    }

    private var _from :Float;
    private var _to :Float;
    private var _duration :Float;
	
	private var _tweenIn :Tween;
	private var _tweenOut :Tween;
}
