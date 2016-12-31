package soda;

import js.Browser.document;
import js.Browser.window;
import js.Browser.navigator;
import js.html.DivElement;
import js.html.Uint8Array;
import js.html.audio.AudioContext;
import js.html.audio.AnalyserNode;
import js.html.audio.MediaStreamAudioSourceNode;
import om.audio.VolumeMeter;
import soda.gui.FrequencySpectrum;

class App {

    static inline var COLOR_VOLUME_QUIET = '#999999';
    static inline var COLOR_VOLUME_OK = '#000000';
    static inline var COLOR_VOLUME_WARN = '#9C27B0';
    static inline var COLOR_VOLUME_LOUD = '#ff0000';

    public static var audio(default,null) : AudioContext;
    public static var analyser(default,null) : AnalyserNode;
    public static var mic(default,null) : MediaStreamAudioSourceNode;

    static var isMobile = om.System.isMobile();
    static var bufferLength : Int;
    static var frequencyData : Uint8Array;
	static var timeDomainData : Uint8Array;
    static var meter : VolumeMeter;

    static var frequencySpectrum : FrequencySpectrum;
    static var volume : DivElement;
    static var vol : DivElement;
    static var rms : DivElement;
    static var dec : DivElement;
    static var settings : SettingsMenu;

    static function update( time : Float ) {

        var width = window.innerWidth;
        var height = window.innerHeight;

        window.requestAnimationFrame( update );

        dec.textContent = Std.int( meter.dec )+'';
        //rms.textContent = 'RMS ' + Std.int(meter.rms * 100);
        //vol.textContent = 'VOL ' + Std.int(meter.vol * 100);

        analyser.getByteFrequencyData( frequencyData );
        //analyser.getByteTimeDomainData( timeDomainData );


        var volumeColor = COLOR_VOLUME_OK;

        if( meter.dec > 0 ) {
            volumeColor = COLOR_VOLUME_LOUD;
            dec.textContent += 'DB';
        } else if( meter.dec > -1 ) {
            volumeColor = COLOR_VOLUME_WARN;
        }
        //dec.style.color = volumeColor;
        document.body.style.background = volumeColor;

        frequencySpectrum.draw( frequencyData );

        //var sliceWidth = width * 1.0 / bufferLength;
        //if( canvas.width < bufferLength ) sliceWidth = 1;

/*
        var sw = width * 1.0 / bufferLength;
        var x = 0.0;
        spectrum.beginPath();
        for( i in 0...bufferLength ) {
            var v = timeDomainData[i] / 128.0;
            var y = v * height / 2;
            if( i == 0) {
                spectrum.moveTo( x, y );
            } else {
                spectrum.lineTo( x, y );
            }
            x += sw;
        }
        //spectrum.lineTo( canvas.width, canvas.height / 2 );
        spectrum.stroke();
*/

        var offset = Std.int( height - (meter.vol * height) );
        //volume.style.height = offset+'px';
        //volume.style.top = offset+'px';

    }

    static function handleKeyDown(e) {
        //trace(e.keyCode);
        switch e.keyCode {
        case 83: // s
            settings.toggle();
        case 27: // esc
            settings.hide();
        }
    }

    static function handleWindowResize(e) {
        frequencySpectrum.resize( window.innerWidth, window.innerHeight );
    }

    static function fatalError( info : String ) {
        document.body.innerHTML = '';
        document.body.classList.add( 'error' );
        document.body.textContent = info;
        //document.title += ' - '+info;
    }

    static function init() {

        //document.body.removeEventListener( 'click', init );
        document.body.removeEventListener( 'touchstart', init );

        if( isMobile ) {
            untyped document.documentElement.webkitRequestFullscreen();
        }

        volume = cast document.getElementById( 'volume' );

        untyped navigator.getUserMedia( { audio: true, video: false },

            function(stream) {

                audio = new AudioContext();

                analyser = audio.createAnalyser();
                analyser.fftSize = 256;

                mic = audio.createMediaStreamSource( stream );
                mic.connect( analyser );

                bufferLength = analyser.frequencyBinCount;
                frequencyData = new Uint8Array( bufferLength );
                timeDomainData = new Uint8Array( bufferLength );

                rms = document.getElementById( 'rms' );
                vol = document.getElementById( 'vol' );
                dec = document.getElementById( 'dec' );

                meter = new om.audio.VolumeMeter( audio );
                mic.connect( meter.processor );

                window.addEventListener( 'resize', handleWindowResize, false );
                window.addEventListener( 'keydown', handleKeyDown, false );

                window.requestAnimationFrame( update );
            },

            function(e){
                trace(e);
                var info = e.name;
                if( e.message.length > 0 ) info += ': '+e.message;
                fatalError( info );
            }
        );
    }

    static function main() {

        untyped navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;

        window.onload = function() {

            settings = new SettingsMenu();
            //settings.show();

            frequencySpectrum = new FrequencySpectrum();
            document.body.appendChild( frequencySpectrum.canvas );

            if( om.System.isMobile() ) {
                //document.body.addEventListener( 'click', init, false );
                document.body.addEventListener( 'touchstart', init, false );
            } else {
                init();
            }
        }
    }

}
