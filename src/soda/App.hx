package soda;

import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import js.Browser.navigator;
import js.html.DivElement;
import js.html.Uint8Array;
import js.html.Float32Array;
import js.html.audio.AudioContext;
import js.html.audio.AnalyserNode;
import js.html.audio.MediaStreamAudioSourceNode;
import om.audio.VolumeMeter;

/*
typedef Settings = {
    var device : Selection;
    var spectrum = {
        //var fft : IntRange<2,2948>
    };
}
*/

class App implements om.App {

    public static var isMobile(default,null) : Bool;
    public static var audio(default,null) : AudioContext;

    static var microphone : MediaStreamAudioSourceNode;
    static var frequencyAnalyser : AnalyserNode;
    static var waveformAnalyser : AnalyserNode;
    static var frequencyData : Uint8Array;
	static var waveformData : Float32Array;
    static var meter : VolumeMeter;
    //static var recorder : Recorder;

	static var spectrum : Spectrum;
	static var info : DivElement;

    static function update( time : Float ) {

        window.requestAnimationFrame( update );

        frequencyAnalyser.getByteFrequencyData( frequencyData );
        waveformAnalyser.getFloatTimeDomainData( waveformData );

        spectrum.draw( frequencyData, waveformData );

        info.textContent = Std.int( meter.decibel )+'';
    }

    static function handleKeyDown(e) {
        //trace(e.keyCode);
        /*
        switch e.keyCode {
        case 83: // s
            settings.toggle();
        case 27: // esc
            settings.hide();
        }
        */
    }

    static function handleWindowResize(e) {
        spectrum.resize( window.innerWidth, window.innerHeight );
    }

    static function fatalError( info : String ) {

        console.error( info );

        document.body.innerHTML = '';
        var e = document.createDivElement();
        e.id = 'fatal-error';
        e.textContent = info;
    }

    static function init() {

        om.audio.Microphone.get().then( function(stream){

            audio = new AudioContext();

            frequencyAnalyser = audio.createAnalyser();
            frequencyAnalyser.fftSize = 256;
            //analyser.minDecibels = -100;
            //analyser.maxDecibels = -30;
            //frequencyAnalyser.connect( audio.destination );

            waveformAnalyser = audio.createAnalyser();
            waveformAnalyser.fftSize = 2048;
            waveformAnalyser.connect( frequencyAnalyser );

            frequencyData = new Uint8Array( frequencyAnalyser.frequencyBinCount );
            waveformData = new Float32Array( waveformAnalyser.frequencyBinCount );

            microphone = audio.createMediaStreamSource( stream );
            microphone.connect( waveformAnalyser );

            meter = new om.audio.VolumeMeter( audio );
            microphone.connect( meter.processor );

            /*
            var recorder = new Recorder( stream );
            recorder.start();
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

            window.addEventListener( 'resize', handleWindowResize, false );
            window.addEventListener( 'keydown', handleKeyDown, false );

            window.requestAnimationFrame( update );

        }).catchError( function(e){
            var info = e.name;
            if( e.message.length > 0 ) info += ': '+e.message;
            fatalError( info );
        });
    }

    static function main() {

        window.onload = function() {

            document.body.innerHTML = '';

            document.addEventListener( 'contextmenu', function(e) e.preventDefault() );

            isMobile = om.System.isMobile();

            /*
            om.audio.Device.get(function(devices){
                trace(devices);
            });
            */

            spectrum = new Spectrum();
            document.body.appendChild( spectrum.element );

            info = document.createDivElement();
            //info.classList.add( 'info' );
            info.classList.add( 'info' );
            info.textContent = 'SODA';
            document.body.appendChild( info );

            //var settings = new SettingsMenu();
            //document.body.appendChild( settings.element );

            if( isMobile) {
                document.body.addEventListener( 'touchstart', function(e) {
                    document.body.removeEventListener( 'touchstart', init );
                    untyped document.documentElement.webkitRequestFullscreen();
                    init();
                }, false );
            } else init();
        }
    }

}
