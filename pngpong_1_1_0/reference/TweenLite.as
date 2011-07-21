/*
VERSION: 5.6
DATE: 11/27/2007
ACTIONSCRIPT VERSION: 2.0 (AS3 version is also available)
UPDATES & MORE DETAILED DOCUMENTATION AT: http://www.TweenLite.com 
DESCRIPTION:
	Tweening. We all do it. Most of us have learned to avoid Adobe's Tween class in favor of a more powerful, 
	less code-heavy engine (Tweener, Fuse, MC Tween, etc.). Each has its own strengths & weaknesses. A few years back, 
	I created TweenLite because I needed a very compact tweening engine that was fast and efficient (I couldn't 
	afford the file size bloat that came with the other tweening engines). It quickly became integral to my work flow.

	Since then, I've added new capabilities while trying to keep file size way down (2K). TweenFilterLite extends 
	TweenLite and adds the ability to tween filters including ColorMatrixFilter effects like saturation, contrast, 
	brightness, hue, and even colorization but it only adds about 3k to the file size. Same syntax as TweenLite. 
	There are AS2 and AS3 versions of both of the classes.

	I know what you're thinking - "if it's so 'lightweight', it's probably missing a lot of features which makes 
	me nervous about using it as my main tweening engine." It is true that it doesn't have the same feature set 
	as the other tweening engines, but I can honestly say that after using it on almost every project I've worked 
	on over the last few years, it has never let me down. I never found myself needing some other functionality. 
	You can tween any property (including a MovieClip's volume and color), use any easing function, build in delays, 
	callback functions, pass arguments to that callback function, and even tween arrays all with one line of code. 
	You very well may require a feature that TweenLite (or TweenFilterLite) doesn't have, but I think most 
	developers will use the built-in features to accomplish whatever they need and appreciate the streamlined 
	nature of the class(es).

	Just the other week (a few years after I created the original TweenLite), I stumbled upon the Tweener class 
	from Zeh Fernando, Nate Chatellier, and others (they did a great job by the way) which is remarkably similar 
	syntax-wise, so if you're a Tweener user, it should be very easy to get your brain around using TweenLite.

	I haven't been able to find a faster tween engine either. The syntax is simple and the class doesn't rely on 
	complicated prototype alterations that can cause problems with certain compilers. TweenLite is simple, very 
	fast, and more lightweight than any other popular tweening engine.

PARAMETERS:
	1) $target: Target MovieClip (or other object) whose properties we're tweening
	2) $duration: Duration (in seconds) of the tween
	3) $vars: An object containing the end values of all the properties you'd like to have tweened (or if you're using the 
	          TweenLite.from() method, these variables would define the BEGINNING values). For example:
					  _alpha: The alpha (opacity level) that the target object should finish at (or begin at if you're 
							  using TweenLite.from()). For example, if the target_obj._alpha is 100 when this script is 
					  		  called, and you specify this argument to be 50, it'll transition from 100 to 50.
					  _x: To change a MovieClip's x position, just set this to the value you'd like the MovieClip to 
					      end up at (or begin at if you're using TweenLite.from()). 
				  SPECIAL PROPERTIES:
				  	  delay: Amount of delay before the tween should begin (in seconds).
					  ease: You can specify a function to use for the easing with this variable. For example, 
					        mx.transitions.easing.Elastic.easeOut. The Default is Regular.easeOut.
					  autoAlpha: Same as changing the _alpha property but with the additional feature of toggling the _visible 
				  			 	 property to false if the _alpha ends at 0. It will also toggle _visible to true before the tween 
								 starts if the value of autoAlpha is greater than zero.
					  volume: To change a MovieClip's volume, just set this to the value you'd like the MovieClip to
					          end up at (or begin at if you're using TweenLite.from()).
					  mcColor: To change a MovieClip's color, set this to the hex value of the color you'd like the MovieClip
					  		   to end up at(or begin at if you're using TweenLite.from()). An example hex value would be 0xFF0000. 
							   If you'd like to remove the color from a MovieClip, just pass null as the value of mcColor.
					  onStart: If you'd like to call a function as soon as the tween begins, pass in a reference to it here.
					  		   This is useful for when there's a delay. 
					  onStartParams: An array of parameters to pass the onStart function. (this is optional)
					  onUpdate: If you'd like to call a function every time the property values are updated (on every frame during
								the time the tween is active), pass a reference to it here.
					  onUpdateParams: An array of parameters to pass the onUpdate function (this is optional)
					  onComplete: If you'd like to call a function when the tween has finished, use this. 
					  onCompleteParams: An array of parameters to pass the onComplete function (this is optional)
					  overwrite: If you do NOT want the tween to automatically overwrite any other tweens that are 
					             affecting the same target, make sure this value is false.
	

EXAMPLES: 
	As a simple example, you could tween the _alpha to 50% and move the _x position of a MovieClip named "clip_mc" 
	to 120 and fade the volume to 0 over the course of 1.5 seconds like so:
	
		gs.TweenLite.to(clip_mc, 1.5, {_alpha:50, _x:120, volume:0});
		
	To set up a sequence where we fade a MovieClip to 50% opacity over the course of 2 seconds, and then slide it down
	to _y coordinate 300 over the course of 1 second:
	
		import gs.TweenFilterLite;
		TweenFilterLite.to(clip_mc, 2, {_alpha:50});
		TweenFilterLite.to(clip_mc, 1, {_y:300, delay:2, overwrite:false});
	
	If you want to get more advanced and tween the clip_mc MovieClip over 5 seconds, changing the _alpha to 50%, 
	the _x to 120 using the "easeOutBack" easing function, delay starting the whole tween by 2 seconds, and then call
	a function named "onFinishTween" when it has completed and pass in a few parameters to that function (a value of
	5 and a reference to the clip_mc), you'd do so like:
		
		import gs.TweenLite;
		import mx.transitions.easing.Back;
		TweenLite.to(clip_mc, 5, {_alpha:50, _x:120, ease:Back.easeOut, delay:2, onComplete:onFinishTween, onCompleteParams:[5, clip_mc]});
		function onFinishTween(argument1_num:Number, argument2_mc:MovieClip):Void {
			trace("The tween has finished! argument1_num = " + argument1_num + ", and argument2_mc = " + argument2_mc);
		}
	
	If you have a MovieClip on the stage that is already in it's end position and you just want to animate it into 
	place over 5 seconds (drop it into place by changing its _y property to 100 pixels higher on the screen and 
	dropping it from there), you could:
		
		import gs.TweenLite;
		import mx.transitions.easing.Elastic;
		TweenLite.from(clip_mc, 5, {_y:"-100", ease:Elastic.easeOut});		
	

NOTES:
	- This class will add about 2.75kb to your Flash file.
	- Putting quotes around values will make the tween relative to the current value. For example, if you do
	  TweenLite.to(mc, 2, {x:"-20"}); it'll move the mc.x to the left 20 pixels which is the same as doing
	  TweenLite.to(mc, 2, {x:mc.x - 20});
	- You can tween the volume of any MovieClip using the tween property "volume", like:
	  TweenLite.to(myClip_mc, 1.5, {volume:0});
	- You can tween the color of a MovieClip using the tween property "mcColor", like:
	  TweenLite.to(myClip_mc, 1.5, {mcColor:0xFF0000});
	- To tween an array, just pass in an array as a property (it doesn't matter what you name it) like:
	  var myArray_array = [1,2,3,4];
	  TweenLite.to(myArray_array, 1.5, {end_array:[10,20,30,40]});
	- You can kill all tweens for a particular object (usually a MovieClip) anytime with the 
	  TweenLite.killTweensOf(myClip_mc); function.
	- You can kill all delayedCalls to a particular function using TweenLite.killDelayedCallsTo(myFunction_func);
	  This can be helpful if you want to preempt a call.
	- Use the TweenLite.from() method to animate things into place. For example, if you have things set up on 
	  the stage in the spot where they should end up, and you just want to animate them into place, you can 
	  pass in the beginning _x and/or _y and/or _alpha (or whatever properties you want).
	  
CHANGE LOG:
	5.6:
		- Removed a line of code that could (very rarely) cause TweenFilterLite tweens to not complete.
	5.3:
		- Added onUpdate and onUpdateParams features
		- Finally removed extra/duplicated (deprecated) constructor parameters that had been left in for almost a year simply for backwards compatibility.

CODED BY: Jack Doyle, jack@greensock.com
Copyright 2007, GreenSock (This work is subject to the terms in http://www.greensock.com/terms_of_use.html.)
*/

class gs.TweenLite {
	static var version:Number = 5.6;
	private static var _e:MovieClip; //A reference to the empty MovieClip that we use to drive all our onEnterFrame actions.
	private static var _all:Object = new Object(); //Holds references to all our tweens.
	private static var _cnt:Number = -16000;
	private static var _gc:Number; //Interval id for garbage collection
	static var killDelayedCallsTo:Function = killTweensOf;
	private var _active:Boolean; //If true, this tween is active. 
	private var _sound:Sound; //We only use this in cases where the user wants to change the volume of a MovieClip (they pass in a "volume" property in the v)
	private var _endTarget:Object; //End target. It's almost always the same as this.target except for volume and color tweens. It helps us to see what object or MovieClip the tween really pertains to (so that we can killTweensOf() properly and hijack auto-overwritten ones)
	
	var duration:Number; //Duration (in seconds)
	var vars:Object; //Variables (holds things like _alpha or _y or whatever we're tweening)
	var delay:Number; //Delay (in seconds)
	var onComplete:Function; //The function that should be triggered when this tween has completed
	var onCompleteParams:Array; //An array containing the parameters that should be passed to the onComplete function when this tween has finished.
	var onUpdate:Function; //The function that should be triggered when the tween updates values (on each frame)
	var onUpdateParams:Array; //An array containing the parameters that should be passed to the onUpdate function.
	var onStart:Function; //The function that should be triggered when this tween starts (useful for when there's a delay)
	var onStartParams:Array; //An array containing the parameters that should be passed to the onStart function
	var startTime:Number; //Start time
	var initTime:Number; //Time of initialization. Remember, we can build in delays so this property tells us when the frame action was born, not when it actually started doing anything.
	var tweens:Object; //Contains parsed data for each property that's being tweened (each has to have a target, start, change, and an ease).
	var extraTweens:Object; //If we run into a property that's supposed to be tweening but the target has no such property, those tweens get dumped in to this object.
	var target:Object; //Target object (usually a MovieClip)
	var tweenID:String; //Tween ID (a way to identify each tween, i.e. "tw1", "tw2", "tw3")
	var endTargetID:String; //Target ID (a way to identify each end target, i.e. "t1", "t2", "t3")
	var color:Color;
	var colorParts:Object; //rb, gb, and bb
	
	public function TweenLite($target:Object, $duration:Number, $vars:Object) {
		_cnt++;
		tweenID = "tw" + _cnt;
		endTargetID = getID($target, true);
		if ($vars.overwrite != false && $target != undefined) { 
			delete _all[endTargetID];
			_all[endTargetID] = {info:[$target, endTargetID]}
		}
		_all[endTargetID][tweenID] = this;
		this.vars = $vars;
		this.duration = $duration;
		this.delay = $vars.delay || 0;
		if ($duration == 0) {
			this.duration = 0.001; //Easing equations don't work when the duration is zero.
			if (this.delay == 0) {
				this.vars.runBackwards = true; //The simplest (most lightweight) way to force an immediate render of the target values
			}
		}
		this.target = _endTarget = $target;
		this.onComplete = $vars.onComplete;
		this.onCompleteParams = $vars.onCompleteParams || [];
		this.onUpdate = $vars.onUpdate;
		this.onUpdateParams = $vars.onUpdateParams || [];
		this.onStart = $vars.onStart;
		this.onStartParams = $vars.onStartParams || [];
		if (this.vars.ease == undefined) {
			this.vars.ease = easeOut;
		} else if (typeof(this.vars.ease) != "function") {
			trace("ERROR: You cannot use '" + this.vars.ease + "' for the TweenLite ease property. Only functions are accepted.");
		}
		if (typeof(this.vars.autoAlpha) == "number") {
			this.vars._alpha = this.vars.autoAlpha;
		} else if (typeof(this.vars._autoAlpha) == "number") {
			this.vars._alpha = this.vars.autoAlpha = this.vars._autoAlpha;
		}
		this.tweens = {};
		this.extraTweens = {};
		this.initTime = getTimer();
		if (this.vars.runBackwards == true) {
			initTweenVals();
		}
		_active = false;
		if ($duration == 0 && this.delay == 0) {
			if (typeof($vars.autoAlpha) == "number" && this.target._alpha == 0) {
				this.target._visible = false;
			}
			if (this.onComplete) {
				this.onComplete.apply(null, this.onCompleteParams);
			}
			removeTween(this);
		} else {
			if (_e._visible != false) { //We were running into strange issues back on Flash player 6 in nested SWFs where _e was defined but wasn't valid. As a workaround, we had to test its _visible property to find out if it's really valid. This empty MovieClip will have the onEnterFrame handler attached to it which will call all our activeions.
				if (!_root.tweenLite_mc) { //If this MovieClip is being loaded inside another, there may already be a tweenLite_mc set up in which case we should use that one. Otherwise, set up a new one.
					var l = _root.getNextHighestDepth() || 9999;
					_e = _root.createEmptyMovieClip("tweenLite_mc", l);
					_e.swapDepths(-1); //We shoot this down to level -1 because sometimes developers assume levels at 0 and above are open and just hard-code new MovieClips into those levels without doing a getNextHighestDepth(). We swapDepths just in case there is already a MovieClip on level -1 - that way we don't kill it (replace it).
				} else {
					_e = _root.tweenLite_mc;
				}
				_e._visible = false;
				clearInterval(_gc);
				_gc = setInterval(killGarbage, 2000);
			}
			_e.onEnterFrame = executeAll;
		}
	}
	
	public function initTweenVals():Void {
		var ndl = this.delay - ((getTimer() - this.initTime) / 1000); //new delay. We need this because reversed (TweenLite.from() calls) need to maintain the delay in any sub-tweens (like for color or volume tweens) but normal TweenLite.to() tweens should have no delay because this function gets called only when the begin!
		var valChange;
		if (this.target instanceof Array) {
			var endArray = [];
			for (var p in this.vars) { //First find an instance of an array in the this.vars to match up with. There should never be more than one.
				if (this.vars[p] instanceof Array) {
					endArray = this.vars[p];
					break;
				}
			}
			for (var i = 0; i < endArray.length; i++) {
				if (this.target[i] != endArray[i] && this.target[i] != undefined) {
					this.tweens[i.toString()] = {o:this.target, s:this.target[i], c:endArray[i] - this.target[i], e:this.vars.ease}; //o: object, s:starting value, c:change in value, e: easing function
				}
			}
		} else {
			for (var p in this.vars) {
				if (p == "volume" && typeof(this.target) == "movieclip") { //If we're trying to change the volume of a MovieClip, then set up a quasai proxy using an instance of a TweenLite to control the volume.
					_sound = new Sound(this.target);
					var volTween = new TweenLite(this, this.duration, {volumeProxy:this.vars[p], ease:easeOut, delay:ndl, overwrite:false, runBackwards:this.vars.runBackwards});
					volTween.endTarget = this.target;
				} else if (p.toLowerCase() == "mccolor" && (typeof(this.target) == "movieclip" || this.target instanceof TextField)) { //If we're trying to change the color of a MovieClip or TextField, then set up a quasai proxy using an instance of a TweenLite to control the color.
					this.color = new Color(this.target);
					this.colorParts = this.color.getTransform();
					var c = this.colorParts;
					var endColor, endA;
					if (this.vars[p] == null || this.vars[p] == "") { //In case they're actually trying to remove the colorization, they should pass in null or "" for the mcColor
						endA = this.vars._alpha || this.target._alpha;
						if (this.vars._alpha != undefined) { //tweening the color transformation affects the _alpha too, so make sure we kill any direct tweening of the _alpha in this TweenLite instance.
							delete this.vars._alpha;
						}
						endColor = {rb:0, gb:0, bb:0, ra:endA, ga:endA, ba:endA, ease:this.vars.ease, delay:ndl, overwrite:false, runBackwards:this.vars.runBackwards};
					} else {
						endColor = {rb:(this.vars[p] >> 16), gb:(this.vars[p] >> 8) & 0xff, bb:(this.vars[p] & 0xff), ra:0, ga:0, ba:0, ease:this.vars.ease, delay:ndl, overwrite:false, runBackwards:this.vars.runBackwards};
					}
					var partsTween = new TweenLite(c, this.duration, endColor);
					var colorTween = new TweenLite(this, this.duration, {colorProxy:1, delay:ndl, overwrite:false, runBackwards:this.vars.runBackwards}); 
					partsTween.endTarget = colorTween.endTarget = this.target;
				} else if (p == "delay" || p == "ease" || p == "overwrite" || p == "onComplete" || p == "onCompleteParams" || p == "runBackwards" || p == "onUpdate" || p == "onUpdateParams" || p == "autoAlpha" || p == "_autoAlpha" || p == "onStart" || p == "onStartParams") {
						
				} else {
					if (this.target[p] != undefined) {
						if (typeof(this.vars[p]) == "number") {
							valChange = this.vars[p] - this.target[p];
						} else {
							valChange = Number(this.vars[p]);
						}
						this.tweens[p] = {o:this.target, s:this.target[p], c:valChange, e:this.vars.ease}; //o: object, p:property, s:starting value, c:change in value, e: easing function
					} else {
						this.extraTweens[p] = {o:this.target, s:0, c:0, e:this.vars.ease, v:this.vars[p]}; //classes that extend this one (like TweenFilterLite) may need it (like for blurX, blurY, and other filter properties)
					}
				}
			}
		}
		if (this.vars.runBackwards == true) {
			var tp;
			for (var p in this.tweens) {
				tp = this.tweens[p];
				tp.s += tp.c;
				tp.c *= -1;
				tp.o[p] = tp.e(0, tp.s, tp.c, this.duration);
			}
			if (this.onUpdate != undefined) {
				this.onUpdate.apply(null, this.onUpdateParams);
			}
		}
		if (typeof(this.vars.autoAlpha) == "number") { 
			this.target._visible = !(this.vars.runBackwards == true && this.target._alpha == 0);
		}
	}
	
	public static function to($target:Object, $duration:Number, $vars:Object):TweenLite {
		return new TweenLite($target, $duration, $vars);
	}
	
	//This function really helps if there are objects (usually MovieClips) that we just want to animate into place (they are already at their end position on the stage for example). 
	public static function from($target:Object, $duration:Number, $vars:Object):TweenLite {
		$vars.runBackwards = true;
		return new TweenLite($target, $duration, $vars);;
	}
	
	public static function delayedCall($delay:Number, $onComplete:Function, $onCompleteParams:Array):TweenLite {
		return new TweenLite($onComplete, 0, {delay:$delay, onComplete:$onComplete, onCompleteParams:$onCompleteParams, overwrite:false});
	}
	
	public static function removeTween($t:TweenLite):Void {
		_all[$t.endTargetID][$t.tweenID] = {active:false};
		delete _all[$t.endTargetID][$t.tweenID];
	}
	
	public static function killTweensOf($tg:Object):Void {
		delete _all[getID($tg, true)];
	}
	
	public static function getID($tg:Object, $lookup:Boolean):String {
		var id:String;
		if ($lookup) {
			var a = _all;
			if (typeof($tg) == "movieclip") {
				if (a[String($tg)] != undefined) {
					return String($tg);
				} else {
					id = String($tg);
					_all[id] = {info:[$tg, id]};
					return id;
				}
			} else {
				for (var p in a) {
					if (a[p].info[0] == $tg) {
						return p;
					}
				}
			}
		}
		_cnt++;
		id = "t" + _cnt;
		_all[id] = {info:[$tg, id]};
		return id;
	}
	
	public function render(t:Number):Void {
		var time = (t - this.startTime) / 1000;
		if (time > this.duration) {
			time = this.duration;
		}
		var tp:Object;
		for (var p in this.tweens) {
			tp = this.tweens[p];
			tp.o[p] = tp.e(time, tp.s, tp.c, this.duration);
			//trace(tp.o+"."+p+" = "+tp.o[p]);
		}
		if (this.onUpdate != undefined) {
			this.onUpdate.apply(null, this.onUpdateParams);
		}
		if (time == this.duration) { //Check to see if we're done
			if (typeof(this.vars.autoAlpha) == "number" && this.target._alpha == 0) {
				this.target._visible = false;
			}
			if (this.onComplete) {
				this.onComplete.apply(null, this.onCompleteParams);
			}
			removeTween(this);
		}
	}
	
	public static function executeAll():Void {
		var a = _all;
		var t = getTimer();
		var tw;
		for (var p in a) {
			for (var twp in a[p]) {
				tw = a[p][twp];
				if (tw.active) {
					tw.render(t);
				}
			}
		}
	}
	
	public static function killGarbage():Void {
		if (_e.onEnterFrame != null) {
			var a = _all;
			var tw, p, twp;;
			var tg_cnt = 0;
			var tw_cnt = 0;
			for (p in a) {
				tw_cnt = 0;
				for (twp in a[p]) {
					tw = a[p][twp];
					if (tw.tweens == undefined) {
						delete tw;
					} else {
						tw_cnt++;
					}
				}
				if (tw_cnt == 0) {
					delete a[p];
				} else {
					tg_cnt++;
				}
			}
			if (tg_cnt == 0) {
				_e.onEnterFrame = null;
			}
		}
	}
	
	//Default ease function for tweens other than _alpha (Regular.easeOut)
	private static function easeOut($t:Number, $b:Number, $c:Number, $d:Number):Number {
		return -$c * ($t /= $d) * ($t - 2) + $b;
	}
	
//---- GETTERS / SETTERS ----------------------------------------------------------------------------------------------------------
	
	public function get active():Boolean {
		if (_active) {
			return true;
		} else if ((getTimer() - this.initTime) / 1000 > this.delay) {
			_active = true;
			this.startTime = this.initTime + (this.delay * 1000);
			if (this.vars.runBackwards != true) {
				initTweenVals();
			} else if (typeof(this.vars.autoAlpha) == "number") {
				this.target._visible = true;
			}
			if (this.duration == 0.001) { //In the constructor, if the duration is zero, we shift it to 0.001 because the easing functions won't work otherwise. We need to offset the startTime_num to compensate too.
				this.startTime -= 1;
			}
			if (this.onStart != undefined) {
				this.onStart.apply(null, this.onStartParams);
			}
			return true;
		} else {
			return false;
		}
	}
	
	public function set endTarget($t:Object):Void { //To swap the end target (for things like color tweens and volume tweens, etc.)
		_all[endTargetID][tweenID] = {active:false};
		delete _all[endTargetID][tweenID];
		endTargetID = getID($t, true);
		_endTarget = $t;
		_all[endTargetID][tweenID] = this;
	}
	
	public function set volumeProxy($n:Number):Void { //Used as a proxy of sorts to control the volume of the target MovieClip.
		_sound.setVolume($n);
	}
	
	public function get volumeProxy():Number { //Used as a proxy of sorts to get the volume of the target MovieClip.
		return _sound.getVolume();
	}
	
	public function set colorProxy($n:Number):Void { //It doesn't matter what value is passed in - this is just a way of forcing the color to update itself
		this.color.setTransform(this.colorParts);
	}
	public function get colorProxy():Number {
		return 0;
	}
	/* If you want to be able to set or get the progress of a Tween, uncomment these getters/setters. 0 = beginning, 0.5 = halfway through, and 1 = complete
	public function get progress():Number {
		return ((getTimer() - this.startTime) / 1000) / this.duration || 0;
	}
	public function set progress(n:Number):Void {
		var t = getTimer() - ((this.duration * n) * 1000);
		this.initTime = t - (this.delay * 1000);
		var s = this.active; //Just to trigger all the onStart stuff.
		this.startTime = t;
		render(getTimer());
	}
	*/
}