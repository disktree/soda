package soda.app;

import js.html.audio.GainNode;
import js.Browser.document;
import js.Browser.window;
import js.html.DivElement;
import js.html.MediaStream;
import js.html.audio.AudioContext;
import js.html.audio.AnalyserNode;
import js.html.audio.MediaStreamAudioSourceNode;
import js.lib.Float32Array;
import js.lib.Uint8Array;
import om.audio.VolumeMeter;
import om.audio.generator.Noise;
import soda.gui.Spectrum;
import soda.gui.VolumeBar;

class MainActivity extends om.app.Activity {

    var frameId : Int;

    var audio : AudioContext;
    var gain : GainNode;
    var microphone : MediaStreamAudioSourceNode;
    var frequencyAnalyser : AnalyserNode;
    var waveformAnalyser : AnalyserNode;

    var frequencyData : Uint8Array;
	var waveformData : Uint8Array;
	//var waveformData : Float32Array;

    var meter : VolumeMeter;

    var info : DivElement;
    var volumeBar : VolumeBar;
    var spectrum : Spectrum;
    //var settings : SettingsMenu;
    //var spectrum3D : soda.gui.Spectrum3D;

	var noiseGenerator : NoiseGenerator;

    public function new( stream : MediaStream ) {

        super();

        audio = new AudioContext();

		gain = audio.createGain();
        gain.gain.value = 0.5;
        gain.connect( audio.destination );

        frequencyAnalyser = audio.createAnalyser();
        //frequencyAnalyser.fftSize = 128;
        //analyser.minDecibels = -100;
        //analyser.maxDecibels = -30;
        frequencyAnalyser.connect( gain );

        waveformAnalyser = audio.createAnalyser();
        waveformAnalyser.fftSize = 2048;
        //waveformAnalyser.smoothingTimeConstant = 0.1;
        waveformAnalyser.connect( frequencyAnalyser );

        frequencyData = new Uint8Array( frequencyAnalyser.frequencyBinCount );
        //waveformData = new Float32Array( waveformAnalyser.frequencyBinCount );
        waveformData = new Uint8Array( waveformAnalyser.frequencyBinCount );
		
        microphone = audio.createMediaStreamSource( stream );
        microphone.connect( waveformAnalyser );

        meter = new om.audio.VolumeMeter( audio );
        microphone.connect( meter.processor );

		//noiseGenerator = new NoiseGenerator( audio );
		//noiseGenerator.pink = true;
		//noiseGenerator.brown = true;
		//noiseGenerator.white = true;
	/*
		var noiseBufferSize = 4096;
		 var brownNoise = audio.createScriptProcessor( noiseBufferSize, 1, 1 );
    		brownNoise.onaudioprocess = function(e) {
                Noise.generateBrownNoise( e.outputBuffer.getChannelData(0), noiseBufferSize );
                //dirtySpectrum = true;
            };
		brownNoise.connect( audio.destination  );
    */

	}

    override function onCreate() {

        super.onCreate();

        spectrum = new Spectrum();
        element.appendChild( spectrum.element );

       // spectrum3D = new soda.gui.Spectrum3D();
       // element.appendChild( spectrum3D.canvas );

        volumeBar = new VolumeBar();
        element.appendChild( volumeBar.element );

        info = document.createDivElement();
        info.classList.add( 'info' );
        document.body.appendChild( info );
    }

    override function onStart() {


        frameId = window.requestAnimationFrame( update );

        document.addEventListener( 'webkitvisibilitychange', handlePageVisibilityChange, false );
        window.addEventListener( 'resize', handleWindowResize, false );

        return super.onStart();

        /*
        //var noise = new NoiseGenerator( audio );
        //document.body.appendChild( noise.element );
        //noise.brown = true;
        //noise.brown = false;
        //noise.white = true;
        */

        /*
        recorder = new Recorder();
        document.body.appendChild( recorder.element );
        recorder.start( stream );
        haxe.Timer.delay( function(){
            recorder.stop( function(rec){
                trace(rec);
                var url = js.html.URL.createObjectURL(rec);
                var player = document.createAudioElement();
                player.src = url;
                player.controls = true;
                player.style.cssText = 'position:fixed; z-index:1000;';
                document.body.appendChild( player );
            });
        },1000);
        */
    }

    override function onStop() {

        window.cancelAnimationFrame( frameId );

        document.removeEventListener( 'webkitvisibilitychange', handlePageVisibilityChange );
        window.removeEventListener( 'resize', handleWindowResize );
        
		return super.onStop();
    }

    function update( time : Float ) {

        frameId = window.requestAnimationFrame( update );

        frequencyAnalyser.getByteFrequencyData( frequencyData );
        waveformAnalyser.getByteTimeDomainData( waveformData );
        //waveformAnalyser.getFloatTimeDomainData( waveformData );

        spectrum.draw( frequencyData, waveformData );
        //spectrum3D.draw( frequencyData, waveformData );

        volumeBar.setValue( meter.volume );

        info.textContent = Std.int( meter.decibel ) + '';

        document.title = Std.int( meter.decibel ) + 'db';
    }

    function handleKeyDown(e) {
        //trace(e.keyCode);
        switch e.keyCode {
        case 83: // S
            //settings.toggle();
        case 27: // ESC
            //settings.hide();
        }
    }

    function handleContextMenu( e ) {
        e.preventDefault();
    }

    function handlePageVisibilityChange( e ) {
        ///trace(document.hidden);
        //document.body.style.display = (document.hidden) ? 'none' : 'block';
    }

    function handleWindowResize( e ) {
        spectrum.resize( window.innerWidth, window.innerHeight );
    }

}
