// =================================================================================================
//
//	Starling Framework - Particle System Extension
//	Copyright 2012 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

// Poorly implmemented port of the Starling particle system.
// Currently uses the standard fuse displaylist for rendering so performance is very bad

package fuse.particles;

import openfl.display3D.Context3DBlendFactor;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Vector;
import fuse.core.render.Context3DBlendMode;
import fuse.display.Sprite;
import fuse.texture.BaseTexture;
import fuse.display.Image;
import fuse.display.BlendMode;

class ParticleSystem extends Sprite
{
    inline public static var MAX_NUM_PARTICLES:Int = 2000;
    
    private var _particles:Vector<Particle>;
    private var _frameTime:Float;
    private var _numParticles:Int = 0;
    private var _emissionRate:Float; // emitted particles per second
    private var _emissionTime:Float;
    private var _emitterX:Float;
    private var _emitterY:Float;
    var _emissionCount:Int = 0;

    private var _blendFactorSource:Context3DBlendFactor;
    private var _blendFactorDestination:Context3DBlendFactor;
    
    @:isVar public var texture(default, set):BaseTexture;
    @:isVar public var capacity(get, set):Int = 0;
    @:isVar var blendMode(default, set):BlendMode = BlendMode.NONE;

    public function new(texture:BaseTexture=null)
    {
        super();

        _particles = new Vector<Particle>(0);
        _frameTime = 0.0;
        _emitterX = _emitterY = 0.0;
        _emissionTime = 0.0;
        _emissionRate = 10;
        _blendFactorSource = Context3DBlendFactor.ONE;
        _blendFactorDestination = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
        
        //this.capacity = 128;
        this.texture = texture;

        updateBlendMode();
    }

    function set_texture(texture:BaseTexture):BaseTexture
    {
        return this.texture = texture;
    }

    private function updateBlendMode():Void
    {
        blendMode = Context3DBlendMode.findBlendMode(_blendFactorSource, _blendFactorDestination);
    }
    
    function set_blendMode(value:BlendMode):BlendMode
    {
        blendMode = value;
        for (i in 0..._particles.length){
            _particles[i].blendMode = blendMode;
        }
        return value;
    }
    
    private function createParticle():Particle
    {
        _numParticles++;
        var particle = new Particle(texture);
        particle.blendMode = blendMode;
        return particle;
    }
    
    private function initParticle(particle:Particle):Void
    {
        particle.blendMode = blendMode;
        particle.x = _emitterX;
        particle.y = _emitterY;
        particle.currentTime = 0;
        particle.totalTime = 1;
        particle.color = Std.int(Math.random() * 0xffffff);
        addChild(particle);
    }

    private function advanceParticle(particle:Particle, passedTime:Float):Void
    {
        particle.y += passedTime * 250;
        particle.alpha = 1.0 - particle.currentTime / particle.totalTime;
        particle.currentTime += passedTime;
    }

    /** Starts the emitter for a certain time. @default infinite time */
    public function start(duration:Float=1.79e+308):Void
    {
        if (_emissionRate != 0)
            _emissionTime = duration;
    }
    
    /** Stops emitting new particles. Depending on 'clearParticles', the existing particles
        *  will either keep animating until they die or will be removed right away. */
    public function stop(clearParticles:Bool=false):Void
    {
        _emissionTime = 0.0;
        if (clearParticles) clear();
    }
    
    public function clear():Void
    {
        _numParticles = 0;
    }
    
    public function advanceTime(passedTime:Float):Void
    {
        var maxNumParticles:Int = capacity;
        
        // advance existing particles
        
        for (i in 0..._numParticles){
            var particle:Particle = _particles[i];
            if (particle.currentTime < particle.totalTime) {
                particle.visible = true;
                advanceParticle(particle, passedTime);
            } else {
                particle.visible = false;
                particle.currentTime = 0;
                //--_numParticles;
            }
        }

        // create and advance new particles
        
        if (_emissionTime > 0)
        {
            var timeBetweenParticles:Float = 1.0 / _emissionRate;
            _frameTime += passedTime;
            
            //if (_numParticles > 0) {
                while (_frameTime > 0)
                {
                    
                    //if (_numParticles < maxNumParticles)
                    //{
                        var index:Int = (_emissionCount++) % (maxNumParticles);
                        var particle:Particle = _particles[index];
                        initParticle(particle);
                        
                        // particle might be dead at birth
                        if (particle.totalTime > 0.0)
                        {
                            advanceParticle(particle, _frameTime);
                            //++_numParticles;
                        }
                    //}
                    
                    _frameTime -= timeBetweenParticles;
                }
            //}
            
            if (_emissionTime != 1.79e+308)
                _emissionTime = _emissionTime > passedTime ? _emissionTime - passedTime : 0.0;

            //if (_numParticles == 0 && _emissionTime == 0)
            //    dispatchEventWith(Event.COMPLETE);
        }

        // update vertex data
        
        #if 0
        var vertexID:Int = 0;
        var rotation:Float;
        var x:Float, y:Float;
        var offsetX:Float, offsetY:Float;
        #end
        var pivotX:Float = texture != null ? texture.width  / 2 : 5;
        var pivotY:Float = texture != null ? texture.height / 2 : 5;
        
        for (i in 0..._numParticles) {
            var vertexID = i * 4;
            var particle = _particles[i];
            if (particle == null){
                trace(i);
            }
            var rotation = particle.rotation;
            var offsetX = pivotX * particle.scale;
            var offsetY = pivotY * particle.scale;
            var x = particle.x;
            var y = particle.y;

            /*_vertexData.fastColorize_premultiplied(particle.color, particle.alpha, vertexID, 4);

            if (rotation != 0)
            {
                var cos:Float  = Math.cos(rotation);
                var sin:Float  = Math.sin(rotation);
                var cosX:Float = cos * offsetX;
                var cosY:Float = cos * offsetY;
                var sinX:Float = sin * offsetX;
                var sinY:Float = sin * offsetY;
                
                _vertexData.fastSetPosition(vertexID,   x - cosX + sinY, y - sinX - cosY);
                _vertexData.fastSetPosition(vertexID+1, x + cosX + sinY, y + sinX - cosY);
                _vertexData.fastSetPosition(vertexID+2, x - cosX - sinY, y - sinX + cosY);
                _vertexData.fastSetPosition(vertexID+3, x + cosX - sinY, y + sinX + cosY);
            }
            else 
            {
                // optimization for rotation == 0
                _vertexData.fastSetPosition(vertexID,   x - offsetX, y - offsetY);
                _vertexData.fastSetPosition(vertexID+1, x + offsetX, y - offsetY);
                _vertexData.fastSetPosition(vertexID+2, x - offsetX, y + offsetY);
                _vertexData.fastSetPosition(vertexID+3, x + offsetX, y + offsetY);
            }*/
        }
        //_vertexData.tinted = true;
    }

    /** Initialize the <code>ParticleSystem</code> with particles distributed randomly
        *  throughout their lifespans. */
    public function populate(count:Int):Void
    {
        trace("populate: " + count);
        var maxNumParticles:Int = capacity;
        count = Std.int(Math.min(count, maxNumParticles - _numParticles));
        
        var p:Particle;
        for (i in 0 ... count)
        {
            p = _particles[_numParticles+i];
            initParticle(p);
            advanceParticle(p, Math.random() * p.totalTime);
        }
        
        _numParticles += count;
    }

    
    private function get_capacity():Int { return capacity; }
    private function set_capacity(value:Int):Int
    {
        var oldCapacity:Int = capacity;
        var newCapacity:Int = value > MAX_NUM_PARTICLES ? MAX_NUM_PARTICLES : value;
        for (i in oldCapacity ... newCapacity)
        {
            _particles[i] = createParticle();
        }

        trace("oldCapacity = " + oldCapacity);
        trace("newCapacity = " + newCapacity);
        

        if (newCapacity < oldCapacity)
        {
            var j:Int = oldCapacity;
            while (j > newCapacity){
                if (_particles[j] != null){
                    if (_particles[j].parent != null){
                        _particles[j].parent.removeChild(_particles[j]);
                    }
                }
                j--;
            }
            _particles.splice(newCapacity, oldCapacity - newCapacity);
        }

        capacity = newCapacity;
        return capacity;
    }

    public var isEmitting(get, never):Bool;
    private function get_isEmitting():Bool { return _emissionTime > 0 && _emissionRate > 0; }
    public var numParticles(get, never):Int;
    private function get_numParticles():Int { return _numParticles; }
    
    public var emissionRate(get, set):Float;
    private function get_emissionRate():Float { return _emissionRate; }
    private function set_emissionRate(value:Float):Float { return _emissionRate = value; }
    
    public var emitterX(get, set):Float;
    private function get_emitterX():Float { return _emitterX; }
    private function set_emitterX(value:Float):Float { return _emitterX = value; }
    
    public var emitterY(get, set):Float;
    private function get_emitterY():Float { return _emitterY; }
    private function set_emitterY(value:Float):Float { return _emitterY = value; }
    
    public var blendFactorSource(get, set):Context3DBlendFactor;
    private function get_blendFactorSource():Context3DBlendFactor { return _blendFactorSource; }
    private function set_blendFactorSource(value:Context3DBlendFactor):Context3DBlendFactor
    {
        _blendFactorSource = value;
        updateBlendMode();
        return value;
    }
    
    public var blendFactorDestination(get, set):Context3DBlendFactor;
    private function get_blendFactorDestination():Context3DBlendFactor { return _blendFactorDestination; }
    private function set_blendFactorDestination(value:Context3DBlendFactor):Context3DBlendFactor
    {
        _blendFactorDestination = value;
        updateBlendMode();
        return value;
    }
}
