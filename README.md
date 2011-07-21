## Description

PNGPong is an open source solution to display transparent PNGs in IE, Firefox, and Safari without the use of filters or complicated JavaScript and CSS.


## Issues

IE versions 5.5 - 6.x has issues handling PNG alpha channels. The solution that is available from Microsoft is to use the AlphaImageLoader filter. Now IE 7 is suppose to support this natively ([IE 7 Checklist](http://blogs.msdn.com/ie/archive/2005/04/26/412263.aspx) and [IE7 Transparent PNG Implementation](http://blogs.msdn.com/ie/archive/2005/04/26/412263.aspx)), but still uses filters to handle the alpha channel. I feel that the filter solutions are still not very clean since Microsoft’s implementation is something that is not supported in the other major browsers like Firefox and Safari.

Here is a quote from a msdn blog post "[IE7 Transparent PNG Implementation](http://blogs.msdn.com/ie/archive/2005/04/26/412263.aspx)” that lists “a couple of limitations worth mentioning":

> * *Certain filters may not behave as expected due to how filters are implemented. Filters work by rendering the content of their attached element to their work surface and then modifying that surface before compositing it to the output surface. Because of this, alpha blending of a transparent PNG with non-binary transparency may lead to unexpected results. For example, applying a BasicImage filter with an opacity attribute to an IMG element with a transparent PNG will fill the work surface with the transparent PNG alpha alpha blended with a solid gray background. The work surface will then be alpha blended at the specified opacity level with whatever is under the filter.*
> * *MSTime does not support non-binary transparency for PNGs. This is because MSTime doesn’t understand anything other than binary index-based alpha. Because of this, transparent PNGs in MSTime elements are expected to continue to render as they do in previous versions of IE.*

Adobe’s Flash Player version 6,0,65,0 (win) or 6,0,67,0 (mac) and higher have support for movies with a transparent background ([Adobe TechNote](http://www.adobe.com/cfusion/knowledgebase/index.cfm?id=tn_14201)). Now the only problem with this is that Safari is not supported.


## Solution

Here are the two outstanding issues we face:

* IE lacks native support for alpha channels in PNGs without the use of filters.
* Safari lacks support for Flash movies with transparent background.

With the release of Flash Player 8 we received the ability to use `loadMovie()` to load a SWF, progressive JPEG, non-animated GIF, or PNG file into a MovieClip in Flash Player while the original SWF file is playing.

What we do is combine the best aspects of the two issues listed above with Flash Player 8’s ability to dynamically load PNGs. This leaves us with a cross-browser solution where we use Flash Player to display transparent PNGs in IE and use native `<img>` support for alpha channels in PNGs for all other browsers.

We take an empty SWF with a bit of ActionScript in order to handle the dynamic loading of the PNG and add functionality to handle image swaps, button states, and onPress handlers. This solution gives us the freedom to have one image asset for Safari, Firefox, and, IE with a single line of JavaScript code.

## Version Info

Version 1.0.0 of PNGPong consists of 1 JavaScript file and 1 swf file and utilizes [Geoff Stearns SWFObject](http://blog.deconcept.com/swfobject/) to write the object/embed tags for Flash.

Version 1.1.0 of PNGPong consists of 1 JavaScript file and 1 swf file. The dependency for SWFObject has been removed.

## Tested Browsers

* IE 6.x (win)
* IE 7.x (win)
* Firefox 1.5 – 2.x (win)
* Firefox 1.5 – 2.x (mac x86, PPC)
* Safari 2.x (mac x86, PPC)
* Camino 1.x (mac x86, PPC)


## License

[MIT License](http://www.opensource.org/licenses/mit-license.php)