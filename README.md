# Fuse Framework - (Prerelease)

## Disclaimer ##
This library is currently in a prerelease stage of development. As a result APIs may change or even be removed without warning. 

## What is Fuse (CodeName) ##
Fuse is a Haxe based hardware accelerated displaylist style 2d rendering library and application framework. With a focus on real world performance, particularly when dealing with applications were there are a lot of display objects that are often static.

## Features ##

### Context Aware Real-time Texture Packing / Atlas Buffers ###
This is an extremely powerful tool. Not only does it allow texture memory to be saved, it also removes the need for the end user to create texture atlases and additionally allows textures that are rendered sequentially to be baked into the same texture atlas, which in turn reduces draw calls.

### Layer Buffers - Currently Disabled###
Cache Layers takes this a step further and bakes static content into a single texture. This is particularly helpful when there is a lot of static content which requires a high number of draw calls or involve a lot of overdraw. This feature does however consume additional texture memory and requires CPU execution to work out the optimal layering.

### Texture Upload Queueing System ###
Progressive texture upload. One of the most common reasons for dropped frames is multiple synchronous textures uploads carried out in a single frame. To combat this Fuse places synchronous texture into a texture upload que and will only upload as many as possible without exceeding the fsp frame budget. Until the texture has finished being uploaded a default transparent texture is used. This feature can be disabled at a per texture level.

### Texture Batching ###
Up to 8 Textures are able to be drawn within a single draw call. This is accomplished by setting a texture index in each quads vertex data and then isolating the appropriate texture in the fragment shader.

### Limited Draw Calls ###
Coupling Atlas Buffering and Texture Batching it becomes very easy to achieve single draw call frames. The only exception is when new or updated textures are being drawn into the Atlas Buffers or when a Layer Buffer is being updated.

### Lightweight Alpha Masking ###
Masking has been implemented within the base fuse fragment shader. This enables image to display object alpha masking with no additional draw calls and at almost no extra performance hit.

----------

## Conclusion ##
The features outlined above enable unprecedented performance in particular circumstances and often only require a single draw call for simple scenes. These features do however come at a cost, for example the library will perform fairly poorly with brute force stress tests. 

## Supported Platforms ##
There are plans to support the following platforms with the possibilities of adding more in the future:

- Windows CPP
- AIR Desktop
- AIR Mobile
- HTML5
- Electron
