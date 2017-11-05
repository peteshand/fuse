# Fuse Framework

## What is Fuse ##
Fuse (Code named Kea during initial development) is a Haxe based hardware accelerated displaylist style 2d rendering library. With a focus on optimization for applications were there are a lot of display objects that are often static. The main goal is to have a super high performant rendering pipeline which is capable of running on low end devices were GPU/CPU power is extremely limited. 

## Goal ##
The goal of Fuse is to create a light weight, highly optimised 2D hardware accelerated engine. In an ideal world this should result in applications that requires a single draw call and uses less that 10% frame budget in it’s main thread. While this may not be possible in every single case, it sets expectations for what my vision of success looks like.