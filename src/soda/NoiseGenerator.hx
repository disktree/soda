package soda;

import js.html.audio.AudioContext;
import js.html.audio.ScriptProcessorNode;
import om.audio.generator.Noise;

class NoiseGenerator {

    public var brown(default,set) : Bool;
    function set_brown(v:Bool) : Bool {
        if( v ) {
            brownNoise.onaudioprocess = function(e)
                Noise.generateBrownNoise( e.outputBuffer.getChannelData(0), noiseBufferSize );
            brownNoise.connect( audio.destination );
        } else {
            brownNoise.disconnect();
            brownNoise.onaudioprocess = null;
        }
        return v;
    }

    public var pink(default,set) : Bool;
    function set_pink(v:Bool) : Bool {
        if( v ) {
            pinkNoise.onaudioprocess = function(e)
                Noise.generatePinkNoise( e.outputBuffer.getChannelData(0), noiseBufferSize );
            pinkNoise.connect( audio.destination );
        } else {
            pinkNoise.disconnect();
            pinkNoise.onaudioprocess = null;
        }
        return v;
    }

    public var white(default,set) : Bool;
    function set_white(v:Bool) : Bool {
        if( v ) {
            pinkNoise.onaudioprocess = function(e)
                Noise.generateWhiteNoise( e.outputBuffer.getChannelData(0), noiseBufferSize );
            pinkNoise.connect( audio.destination );
        } else {
            pinkNoise.disconnect();
            pinkNoise.onaudioprocess = null;
        }
        return v;
    }

    var audio : AudioContext;
    var noiseBufferSize : Int;
    var brownNoise : ScriptProcessorNode;
    var pinkNoise : ScriptProcessorNode;
    var whiteNoise : ScriptProcessorNode;

    public function new( audio : AudioContext, noiseBufferSize = 4096 ) {

        this.audio = audio;
        this.noiseBufferSize = noiseBufferSize;

        brownNoise = audio.createScriptProcessor( noiseBufferSize, 1, 1 );
        pinkNoise = audio.createScriptProcessor( noiseBufferSize, 1, 1 );
        whiteNoise = audio.createScriptProcessor( noiseBufferSize, 1, 1 );

        brown = pink = white = false;
    }
}
