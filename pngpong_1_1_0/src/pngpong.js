/*
 * pngpong is (c) 2007-2008 Larry Lenn Gordon and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * @description	pngpong: Method to allow the support for transparent
 *               images in IE by replacing PNG's with PNG embeded swf's. 
 * 
 * @author   Larry Lenn Gordon : Jan 25, 2007 - http://blog.psyrendust.com/pngpong/
 * @version  1.1.0
 */
if(pngpong == "undefined"){var pngpong = new Object();}
pngpong=
{
	loc : String(),
	setLocation : function(inLocation)
	{
		var len = inLocation.length-1;
		var lastChar = inLocation.charAt(len);
		pngpong.loc = inLocation;
		if(lastChar != "/")
			pngpong.loc += "/";
	},
	swfLocation : function()
	{
		return pngpong.loc + "pngpong.swf";
	},
	defaultImage : function()
	{
		return pngpong.loc + "noFlash.gif";
	},
	swapImage : function($target, $image)
	{
		try{
			if (pngpong.util.writeSwf && pngpong.util.checkIfPng($image)) 
				pngpong.util.getNode($target + "_swf").swapImage($image);
			else 
				pngpong.util.swapImage($target + "_img", $image);
		}catch(e){}
	},
	alpha : function($target, $alpha)
	{
		try{
			if(pngpong.util.writeSwf)
				pngpong.util.getNode($target+"_swf").setAlpha($alpha);
			else
				pngpong.util.setAlpha($target, $alpha);
		}catch(e){}
	},
	enabled : function($target, $boolean)
	{
		try{
			if(pngpong.util.writeSwf)
				pngpong.util.getNode($target+"_swf").setEnabled($boolean);
			else
				pngpong.util.setEnabled($target+"_img", $boolean);
		}catch(e){}
	},
	serve : function($target, $vars)
	{
		/*
		$target
		$vars.out
		$vars.over
		$vars.down
		$vars.url
		$vars.method
		$vars.params
		$vars.altName
		$vars.altImg
		*/
		// 1. first figure out if IE or not
		if(pngpong.util.writeSwf && pngpong.util.checkIfPng($vars.out))
		{
			// 2. Is IE, has Flash 8 or higher, and image is a PNG
			var swfNode = "";
			var pairs = "";
			var vars = new Array();
			swfNode = '<object id="'+ $target+'_swf" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="100%" height="100%" >';
			swfNode += '<param name="menu" value="false" />';
			swfNode += '<param name="quality" value="high" />';
			swfNode += '<param name="allowScriptAccess" value="always" />';
			swfNode += '<param name="movie" value="'+ pngpong.swfLocation() +'" />';
			if($vars.out != undefined)
				vars.push("$out="+pngpong.util.getName($vars.out));
			if($vars.over != undefined)
				vars.push("$over="+pngpong.util.getName($vars.over));
			if($vars.down != undefined)
				vars.push("$down="+pngpong.util.getName($vars.down));
			if($vars.url != undefined)
				vars.push("$url="+$vars.url);
			if($vars.browserTarget != undefined)
				vars.push("$browserTarget="+$vars.browserTarget);
			if($vars.method != undefined)
				vars.push("$method="+$vars.method);
			if($vars.params != undefined)
				vars.push("$params="+$vars.params);
			swfNode += '<param name="wmode" value="transparent" />';
			pairs = vars.join("&");
			if(vars.length > 0)
				swfNode += '<param name="flashvars" value="'+ pairs +'" />';
			swfNode += "</object>";
			pngpong.util.getNode($target).innerHTML = swfNode;
		}
		else
		{
			try{
				// 3. serve up an img tag because Flash version is less than 8
				var attachEvents = false;
				var div = pngpong.util.getNode($target);
				div.style["visibility"] = "hidden";
				
				var image = document.createElement("img");
				image.setAttribute("id", $target+"_img");
				image.setAttribute("name", $target+"_img");
				image.setAttribute("style", "visibility:hidden");
				image.setAttribute("border", "0")
				
				if(pngpong.util.browserIsIE && pngpong.util.checkIfPng($vars.out) && $vars.altImg == undefined)
				{
					// 4. If IE, image is a PNG, and altImg is not present
					// embed the default image
					image.setAttribute("src", pngpong.defaultImage());
				}
				else if(pngpong.util.browserIsIE && $vars.altImg != undefined)
				{
					// 5. If IE and altImg is present
					// embed the alternate image
					image.setAttribute("src", pngpong.util.getName($vars.altImg));
					// 6. Attach events and other attributes if $vars.altImg has
					//    correctly been defined
					attachEvents = true;
				}
				else if($vars.out == undefined)
				{
					// 7. $vars.out was not defined
					//    This means the the developer messed up
					// embed the default image
					image.setAttribute("src", pngpong.defaultImage());
				}
				else
				{
					// 8. Image is a PNG and not IE
					//    or
					//    The image is a GIF or JPG and it doesn't
					//    matter what browser you are using
					// just embed the image
					image.setAttribute("src", pngpong.util.getName($vars.out));
					// 9. Attach events and other attributes if $vars.out has
					//    correctly been defined
					attachEvents = true;
				}
				if(attachEvents)
				{
					var imgName = $target + "_img";
					if($vars.over != undefined){
						image.setAttribute("style", "visibility:hidden; cursor:pointer; cursor:hand;");
						pngpong.util.preloadImage(pngpong.util.getName($vars.over));
						image.onmouseover = function(){ pngpong.util.swapImage(imgName, pngpong.util.getName($vars.over)); };
						image.onmouseout  = function(){ pngpong.util.swapImage(imgName, pngpong.util.getName($vars.out)); };
					}
					if($vars.down != undefined){
						image.setAttribute("style", "visibility:hidden; cursor:pointer; cursor:hand;");
						pngpong.util.preloadImage(pngpong.util.getName($vars.down));
						image.onmousedown = function(){ pngpong.util.swapImage(imgName, pngpong.util.getName($vars.down)); };
						image.onmouseup   = function(){ pngpong.util.swapImage(imgName, pngpong.util.getName($vars.over)); };
					}
					if($vars.url != undefined){
						image.setAttribute("style", "visibility:hidden; cursor:pointer; cursor:hand;");
						image.onclick = function(){ window.open($vars.url, (($vars.browserTarget != undefined) ? $vars.browserTarget : "_self")); };
					}
					if($vars.method != undefined){
						image.setAttribute("style", "visibility:hidden; cursor:pointer; cursor:hand;");
						image.onclick = function(){ eval($vars.method).call(this, $vars.params); };						
					}
				}
				if($vars.altName != undefined)
					image.alt = $vars.altName;
				image.onload = function(){pngpong.util.show($target);};				
				div.appendChild(image);				
			} catch(e){alert(e);};
		}
	}
}
//___________________________________________________________________
// private methods
pngpong.util=
{
	//_____________________________________________________
	// 
	imgArray : Array(),
	writeSwf : String(),
	browserIsIE : Boolean(),
	requiredVersion : Array(),
	/**
	 * Initializes the location of pngpong on the server, finds out
	 * if the browser is IE, and checks to see if Flash 8 or higher
	 * is installed
	 * @return {void}
	 */
	init : function()
	{
		pngpong.setLocation("../"); // set the location of pngpong (can be overwritten)
		pngpong.util.setBrowser();  // find out if the browser is IE
		if(pngpong.util.browserIsIE) 
		{
			// if browser is IE then set the required Flash version to 8.0.0
			// check if Flash version 8.0.0 or higher is installed
			pngpong.util.requiredVersion = [8, 0, 0];
			pngpong.util.writeSwf = pngpong.util.isPlayerVersionValid(pngpong.util.requiredVersion);
		}
	},
	/**
	 * Returns an array of ints [major, minor, rev]
	 * modified from swfObject 1.5
	 * @return {Array}
	 */
	getPlayerVersion : function()
	{
		var v = [0,0,0];
		var axo;
		if(navigator.plugins && navigator.mimeTypes.length){
			var x = navigator.plugins["Shockwave Flash"];
			if(x && x.description)
				v = x.description.replace(/([a-zA-Z]|\s)+/, "").replace(/(\s+r|\s+b[0-9]+)/, ".").split(".");
		}
		else if(navigator.userAgent && navigator.userAgent.indexOf("Windows CE") >= 0)
		{
			// if Windows CE
			axo = 1;
			var counter = 3;
			while(axo) {
				try {
					counter++;
					axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash."+ counter);
					v = [counter,0,0];
				} catch (e) {axo = null;}
			}
		}
		else
		{
			// Win IE (non mobile)
			// do minor version lookup in IE, but avoid fp6 crashing issues
			// see http://blog.deconcept.com/2006/01/11/getvariable-setvariable-crash-internet-explorer-flash-6/
			try{
				axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.7");
			}catch(e){
				try {
					axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.6");
					v = [6,0,21];
					axo.AllowScriptAccess = "always"; // error if player version < 6.0.47 (thanks to Michael Williams @ Adobe for this code)
				} catch(e) {
					if(v[0] == 6)
						return v;
				}
				try {
					axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash");
				} catch(e) {}
			}
			if (axo != null)
				v = axo.GetVariable("$version").split(" ")[1].split(",");
		}
		return v;
	},
	/**
	 * Takes an array of ints [major, minor, rev]
	 * modified from swfObject 1.5
	 * @param {Array} required
	 * @return {Boolean}
	 */
	isPlayerVersionValid : function(required){
		var current = pngpong.util.getPlayerVersion();
		if(current[0] < required[0]) return false;
		if(current[0] > required[0]) return true;
		if(current[1] < required[1]) return false;
		if(current[1] > required[1]) return true;
		if(current[2] < required[2]) return false;
		return true;
	},
	/**
	 * Returns a string in the format "9.0.47", for display purposes only
	 * @return {String}
	 */
	getPlayerVersionString: function(){
		return pngpong.util.getPlayerVersion().join(".");
	},
	getNode : function(inElement)
	{
		try{
			if(window.document[inElement])
				return window.document[inElement];
			if(navigator.appName.indexOf("Microsoft Internet")==-1){
				if(document.embeds && document.embeds[inElement])
					return document.embeds[inElement];
				else
					return document.getElementById(inElement);
			} else
				return document.getElementById(inElement);
		} catch(e){}
	},
	setPngpongWH : function(inElement, inW, inH)
	{
		try{
			var element = pngpong.util.getNode(inElement);
			element.style["width"] = inW+"px";
			element.style["height"] = inH+"px";
			var swfElement = pngpong.util.getNode(inElement+"_swf");
			swfElement.style["width"] = inW+"px";
			swfElement.style["height"] = inH+"px";
			delete element;
			delete swfElement;
		} catch(e){}
	},
	getName : function(inName)
	{
		var strArray = inName.split("/");
		var name = strArray[strArray.length-1].split(".")[1];
		if(name == undefined)
			return inName+".png";
		else
			return inName;
	},
	setBrowser : function()
	{
		pngpong.util.browserIsIE = (navigator.appVersion.indexOf("Win") && navigator.appName == "Microsoft Internet Explorer") ? true : false;
	},
	checkIfPng : function(inImage)
	{
		var strArray = pngpong.util.getName(inImage).split("/");
		var name = strArray[strArray.length-1].split(".")[1];
		if(name == "png")
			return true;
		else
			return false;
	},
	preloadImage : function(inImage)
	{
		try{
			pngpong.util.imgArray.push(new Image());
			pngpong.util.imgArray[pngpong.util.imgArray.length-1].src = inImage;
		} catch(e){}
	},
	swapImage : function($target, inImage)
	{
		try{
			document[$target].src = inImage;
		} catch(e){}
	},
	show : function($target)
	{
		try{
			pngpong.util.getNode($target).style["visibility"] = "visible";
			pngpong.util.getNode($target+"_img").style["visibility"] = "visible";
		} catch(e){}
	},
	setAlpha : function($target, $alpha)
	{
		try{
			pngpong.util.getNode($target).style["filter"] = "alpha(opacity="+$alpha+")";
			pngpong.util.getNode($target).style["-moz-opacity"] = $alpha/100;
			pngpong.util.getNode($target).style["opacity"] = $alpha/100;
		} catch(e){alert(e);}
	},
	setEnabled : function($target, inAlpha)
	{
		
	}
}
pngpong.util.init();