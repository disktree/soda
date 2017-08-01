package soda.app;

import js.Browser.document;
import js.Browser.window;
import js.html.DivElement;
import js.html.Float32Array;
import js.html.Uint8Array;
import js.html.audio.AudioContext;
import js.html.audio.AnalyserNode;
import js.html.MediaStream;
import js.html.audio.MediaStreamAudioSourceNode;
import om.audio.VolumeMeter;
import soda.gui.Spectrum;

class MainActivity extends om.Activity {

    var frameId : Int;
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

    public function new( audio : AudioContext, stream : MediaStream ) {

        super();

        frequencyAnalyser = audio.createAnalyser();
        frequencyAnalyser.fftSize = 128;
        //analyser.minDecibels = -100;
        //analyser.maxDecibels = -30;
        //frequencyAnalyser.connect( audio.destination );

        waveformAnalyser = audio.createAnalyser();
        waveformAnalyser.fftSize = 1024;
        //waveformAnalyser.smoothingTimeConstant = 0.1;
        waveformAnalyser.connect( frequencyAnalyser );

        frequencyData = new Uint8Array( frequencyAnalyser.frequencyBinCount );
        //waveformData = new Float32Array( waveformAnalyser.frequencyBinCount );
        waveformData = new Uint8Array( waveformAnalyser.frequencyBinCount );

        microphone = audio.createMediaStreamSource( stream );
        microphone.connect( waveformAnalyser );

        meter = new om.audio.VolumeMeter( audio );
        microphone.connect( meter.processor );
    }

    override function onCreate() {

        super.onCreate();

        spectrum = new Spectrum();
        element.appendChild( spectrum.element );

        volumeBar = new VolumeBar();
        element.appendChild( volumeBar.element );

        info = document.createDivElement();
        info.classList.add( 'info' );
        document.body.appendChild( info );
    }

    override function onStart() {

        super.onStart();

        frameId = window.requestAnimationFrame( update );

        document.addEventListener( 'webkitvisibilitychange', handlePageVisibilityChange, false );
        window.addEventListener( 'resize', handleWindowResize, false );

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

        super.onStop();

        window.cancelAnimationFrame( frameId );

        document.removeEventListener( 'webkitvisibilitychange', handlePageVisibilityChange );
        window.removeEventListener( 'resize', handleWindowResize );
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
