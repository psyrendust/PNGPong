/*
 * pngpong is (c) 2007 Larry Lenn Gordon and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * @projectDescription	pngpong: Method to allow the support for transparent
 *                     images in IE by replacing PNG's with PNG embeded swf's. 
 * 
 * @author   Larry Lenn Gordon : Jan 25, 2007 - http://blog.psyrendust.com/pngpong/
 * @version  1.0.0
 */
if(pngpong == "undefined"){var pngpong = new Object();}
pngpong=
{
	swfLocation : function()
	{
		return "/pngpong/pngpong.swf";
	},
	serve : function(inIdName, inName)
	{
		pngpong.util.addpng(inIdName, "", inName);
	},
	serveButtonUrl : function(inIdName, inNameOut, inNameOver, inUrl)
	{
		pngpong.util.addpngButtonUrl(inIdName, "", inNameOut, inNameOver, inUrl);
	},
	serveButtonJs : function(inIdName, inNameOut, inNameOver, inFunction, inParams)
	{
		pngpong.util.addpngButtonJs(inIdName, "", inNameOut, inNameOver, inFunction, inParams);
	},
	swapImage : function(inIdName, inName)
	{
		try{
			if(navigator.appVersion.indexOf("Win") && navigator.appName == "Microsoft Internet Explorer" && pngpong.util.checkIfPng(inName))
				pngpong.util.getNode(inIdName+"_swf").swapImage(inName);
			else
				pngpong.util.swapImage(inIdName+"_img", inName);
		}catch(e){}
	}
}
pngpong.alt=
{
	serve : function(inIdName, inAltName, inName)
	{
		pngpong.util.addpng(inIdName, inAltName, inName);
	},
	serveButtonUrl : function(inIdName, inAltName, inNameOut, inNameOver, inUrl)
	{
		pngpong.util.addpngButtonUrl(inIdName, inAltName, inNameOut, inNameOver, inUrl);
	},
	serveButtonJs : function(inIdName, inAltName, inNameOut, inNameOver, inFunction, inParams)
	{
		pngpong.util.addpngButtonJs(inIdName, inAltName, inNameOut, inNameOver, inFunction, inParams);
	}
}
pngpong.util=
{
	imgArray : Array(),
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
	addpng : function(inIdName, inAltName, inName)
	{
		pngpong.util.preloadImage(pngpong.util.getName(inName));
		if(navigator.appVersion.indexOf("Win") && navigator.appName == "Microsoft Internet Explorer" && pngpong.util.checkIfPng(inName))
		{
			try{
				var so = new SWFObject(pngpong.swfLocation(), inIdName+"_swf", "100%", "100%", "8", "#ffffff", false, "high");
				so.addParam("wmode", "transparent");
				so.addVariable("swfType", "image");
				so.addVariable("pngloc", pngpong.util.getName(inName));
				so.addVariable("divName", inIdName);
				so.write(inIdName);
			} catch(e){}
		}
		else
		{
			try{
				var div = pngpong.util.getNode(inIdName);
				div.style["visibility"] = "hidden";
				div.innerHTML = '<img alt="'+inAltName+'" id="'+inIdName+'_img" name="'+inIdName+'_img" onload="pngpong.util.show(\''+inIdName+'\');" style="visibility:hidden;" src="'+pngpong.util.getName(inName)+'" border="0" />';
			} catch(e){}
		}
	},
	addpngButtonUrl : function(inIdName, inAltName, inNameOut, inNameOver, inUrl)
	{
		pngpong.util.preloadImage(pngpong.util.getName(inNameOut));
		pngpong.util.preloadImage(pngpong.util.getName(inNameOver));
		if(navigator.appVersion.indexOf("Win") && navigator.appName == "Microsoft Internet Explorer" && pngpong.util.checkIfPng(inNameOut) && pngpong.util.checkIfPng(inNameOver))
		{
			try{
				var so = new SWFObject(pngpong.swfLocation(), inIdName+"_swf", "100%", "100%", "8", "#ffffff", false, "high");
				so.addParam("wmode", "transparent");
				so.addVariable("swfType", "button_url");
				so.addVariable("pnglocOut", pngpong.util.getName(inNameOut));
				so.addVariable("pnglocOver", pngpong.util.getName(inNameOver));
				so.addVariable("action", inUrl);
				so.addVariable("divName", inIdName);
				so.write(inIdName);
			} catch(e){}
		}
		else
		{
			try{
				var div = pngpong.util.getNode(inIdName);
				div.style["visibility"] = "hidden";
				if(inUrl == "" || inUrl == "null" || inUrl == "undefined")
					div.innerHTML = '<img alt="'+inAltName+'" id="'+inIdName+'_img" name="'+inIdName+'_img" onload="pngpong.util.show(\''+inIdName+'\');" style=" cursor:pointer; cursor:hand;" src="'+pngpong.util.getName(inNameOut)+'" onMouseOver="pngpong.util.swapImage(\''+inIdName+'_img\', \''+pngpong.util.getName(inNameOver)+'\');" onMouseOut="pngpong.util.swapImage(\''+inIdName+'_img\', \''+pngpong.util.getName(inNameOut)+'\');" border="0" />';
				else
					div.innerHTML = '<img alt="'+inAltName+'" id="'+inIdName+'_img" name="'+inIdName+'_img" onload="pngpong.util.show(\''+inIdName+'\');" style=" cursor:pointer; cursor:hand;" src="'+pngpong.util.getName(inNameOut)+'" onMouseOver="pngpong.util.swapImage(\''+inIdName+'_img\', \''+pngpong.util.getName(inNameOver)+'\');" onMouseOut="pngpong.util.swapImage(\''+inIdName+'_img\', \''+pngpong.util.getName(inNameOut)+'\');" onMouseDown="window.location=\''+inUrl+'\'" border="0" />';
			} catch(e){}
		}
	},
	addpngButtonJs : function(inIdName, inAltName, inNameOut, inNameOver, inFunction, inParams)
	{
		pngpong.util.preloadImage(pngpong.util.getName(inNameOut));
		pngpong.util.preloadImage(pngpong.util.getName(inNameOver));
		if(navigator.appVersion.indexOf("Win") && navigator.appName == "Microsoft Internet Explorer" && pngpong.util.checkIfPng(inNameOut) && pngpong.util.checkIfPng(inNameOver))
		{
			try{
				var so = new SWFObject(pngpong.swfLocation(), inIdName+"_swf", "100%", "100%", "8", "#ffffff", false, "high");
				so.addParam("wmode", "transparent");
				so.addVariable("swfType", "button_js");
				so.addVariable("pnglocOut", pngpong.util.getName(inNameOut));
				so.addVariable("pnglocOver", pngpong.util.getName(inNameOver));
				so.addVariable("action", inFunction);
				so.addVariable("parameters", inParams)
				so.addVariable("divName", inIdName);
				so.write(inIdName);
			} catch(e){}
		}
		else
		{
			try{
				var div = pngpong.util.getNode(inIdName);
				div.style["visibility"] = "hidden";
				if(inFunction == "" || inFunction == "null" || inFunction == "undefined")
					div.innerHTML = '<img alt="'+inAltName+'" id="'+inIdName+'_img" name="'+inIdName+'_img" onload="pngpong.util.show(\''+inIdName+'\');" style="cursor:pointer; cursor:hand;" src="'+pngpong.util.getName(inNameOut)+'" onMouseOver="pngpong.util.swapImage(\''+inIdName+'_img\', \''+pngpong.util.getName(inNameOver)+'\');" onMouseOut="pngpong.util.swapImage(\''+inIdName+'_img\', \''+pngpong.util.getName(inNameOut)+'\');" border="0" />';
				else
					div.innerHTML = '<img alt="'+inAltName+'" id="'+inIdName+'_img" name="'+inIdName+'_img" onload="pngpong.util.show(\''+inIdName+'\');" style="cursor:pointer; cursor:hand;" src="'+pngpong.util.getName(inNameOut)+'" onMouseOver="pngpong.util.swapImage(\''+inIdName+'_img\', \''+pngpong.util.getName(inNameOver)+'\');" onMouseOut="pngpong.util.swapImage(\''+inIdName+'_img\', \''+pngpong.util.getName(inNameOut)+'\');" onMouseDown="pngpong.util.swapImage(\''+inIdName+'_img\', \''+pngpong.util.getName(inNameOut)+'\'); '+inFunction+'(\''+inParams+'\');" border="0" />';
			} catch(e){}
		}
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
	swapImage : function(inIdName, inImage)
	{
		try{
			document[inIdName].src = inImage;
		} catch(e){}
	},
	show : function(inIdName)
	{
		try{
			pngpong.util.getNode(inIdName).style["visibility"] = "visible";
			pngpong.util.getNode(inIdName+"_img").style["visibility"] = "visible";
		} catch(e){}
	}
}