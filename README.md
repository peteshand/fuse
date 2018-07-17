# Fuse Framework

## Disclaimer ##
This library is currently in an alpha stage of development. As a result APIs may change or even be removed without warning. 

## What is Fuse ##
Fuse (Code named Kea during initial development) is a Haxe based hardware accelerated displaylist style 2d rendering library and application framework. With a focus on real world performance, particularly when dealing with applications were there are a lot of display objects that are often static.


## Goal ##
The goal of Fuse is to create a lightweight, highly optimised 2D hardware accelerated engine. This results in applications built with Fuse only requiring a single draw call unless textures are being added to the GPU within a given frame. Additionally there is a goal to use less than 15% frame budget in it’s main thread on mid range computers (under average graphics load).

## Features ##

### Context Aware Real-time Texture Packing / Atlas Buffers ###
This is an extremely powerful tool. Not only does it allow texture memory to be saved, it also removes the need for the end user to create texture atlases and additionally allows textures that are rendered sequentially to be baked into the same texture atlas, which in turn reduces draw calls.

### Layer Buffers ###
Cache Layers takes this a step further and bakes static content into a single texture. This is particularly helpful when there is a lot of static content which requires a high number of draw calls or involve a lot of overdraw. This feature does however consume additional texture memory and requires CPU execution to work out the optimal layering.

### Texture Upload Queueing System ###
Progressive texture upload. One of the most common reasons for dropped frames is multiple synchronous texture uploads carried out in a single frame. To combat this Fuse places synchronous texture into a texture upload que and will only upload as many as possible without exceeding the fsp frame budget. Until the texture has finished being uploaded a default transparent texture is used. This feature can be disabled at a per texture level.

### Lightweight Dependency Injection & MVC ###
I’m a big fan of Dependency Injection and MVC frameworks, however unfortunately they can introduce substantial performance costs when mapping/injecting, so I’ve built a very minimalistic Dependency Injection & MVC right into fuse. A majority of the work is done at compile time to reduce runtime overhead.

### Texture Batching ###
Up to 8 Textures are able to be drawn within a single draw call. This is accomplished by set a texture index in each quads vertex data and then isolating the appropriate texture in the fragment shader.

### Limited Draw Calls ###
Coupling Atlas Buffering and Texture Batching it becomes very easy to achieve single draw call frames. The only exception is when new or updated textures are being drawn into the Atlas Buffers or when a Layer Buffers is being updated.

### Lightweight Alpha Masking ###
Masking has been implemented within the base fuse fragment shader. This enables image to image alpha masking with no additional draw calls and at almost no extra performance hit.

## Supported Platforms ##
There are plans to support the following platforms with the possibilities of adding more in the future:

- Windows CPP
- AIR Desktop
- AIR Mobile
- HTML5
- Electron
