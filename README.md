DMT
===
Dynamically Mapping Textures
-----------------------------

Using vector images guarantee image sharpness while scaling, moving, etc - but suffer from poorer performance, which mean low FPS.  
Using bitmap images allows the application to reach higher FPS (using 3rd party libs like starling) - but compromises image quality at scaling.  
The DMT library make the best of both world by providing run-time dynamic (and fast) rasterize vector images to bitmaps and generate the atlases. 

This way, images are optimized for each screen resolution, avoiding ugly stretch marks and pixlezation. Having the display object tree allows you to manipulate each sub object separately (as in flash).

[Basic Tutorial](http://gilamran.blogspot.com/2013/06/dmt-basic-tutorial.html "Basic Tutorial")

DMT is Open Source library, released under [Apache License](http://www.apache.org/licenses/LICENSE-2.0.html "Apache License, Version 2.0").

This library is currently in early alpha state. The API may change.
Nevertheless we already have a production game that uses the library: [Memory Game](http://www.xtdstudios.com/memory-cards.html)

__More information can be found at [XTDStudios](http://www.xtdstudios.com/dmt.html "XTDStudios site") web site.__


Features
--------
1.  Dynamically generated at run-time
2.  Storing the original Display Tree
  * Display Object manipulations is available as in the original Flash Display Object
  This allows you to change any property like alpha, x, y, scaleX, scaleY, and rotation of any children, this also means you have the original PIVOT point and you can listen to events of any child object.
  * Keeping instance name, so getChildByName also works as usual.    
3.  Smart Effects
  * capturing Effects.
  * Scale effect support (Optional) - All the Display Object effects are being scaled to the proportional requested      size
4.  Automatically generates a packaged textures atlas.
  * All textures are being packed into a minimized atlas(s), optimized using bean packing algorithm (To save GPU memory, loading time, and draw calls!)
  * Dynamically packing.
  * Multiple instances of object with the same transformation matrix are treated as the same Texture. (No duplication)
5.  Cache support - generate the device optimized images once, and saved for reuse in later runs. 
  * Save/load all rasterized data to/from cache.
  * Cache contains all rasterized textures (PNG file format) and all Display Tree data, in one file.
6.  Asynchronous support using pseudo thread. (Ready for workers when available on mobile.) 
7.  Rasterize MovieClips.


Follow me on Twitter [@gilamran](https://twitter.com/gilamran) for any news
