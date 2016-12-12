package soda;

import js.Browser.document;
import js.Browser.window;
import js.Browser.navigator;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.DivElement;
import js.html.Uint8Array;
import js.html.audio.AudioContext;
import js.html.audio.AnalyserNode;
import js.html.audio.MediaStreamAudioSourceNode;
import om.audio.VolumeMeter;

class App {

    static inline var COLOR_VOLUME_QUIET = '#999999';
    static inline var COLOR_VOLUME_OK = '#000000';
    static inline var COLOR_VOLUME_WARN = '#9C27B0';
    static inline var COLOR_VOLUME_LOUD = '#ff0000';

    public static var audio(default,null) : AudioContext;
    public static var analyser(default,null) : AnalyserNode;
    public static var mic(default,null) : MediaStreamAudioSourceNode;

    static var bufferLength : Int;
    static var frequencyData : Uint8Array;
	static var timeDomainData : Uint8Array;
    static var meter : VolumeMeter;

    static var canvas : CanvasElement;
    static var spectrum : CanvasRenderingContext2D;
    static var volume : DivElement;
    static var vol : DivElement;
    static var rms : DivElement;
    static var dec : DivElement;
    static var settings : SettingsMenu;

    static function update( time : Float ) {

        window.requestAnimationFrame( update );

        dec.textContent = Std.int( meter.dec )+'';

        analyser.getByteTimeDomainData( timeDomainData );
        analyser.getByteFrequencyData( frequencyData );

        ///////

        var width = window.innerWidth;
        var height = window.innerHeight;

        //rms.textContent = 'RMS ' + Std.int(meter.rms * 100);
        //vol.textContent = 'VOL ' + Std.int(meter.vol * 100);

        var volumeColor = COLOR_VOLUME_OK;

        if( meter.dec > 0 ) {
            volumeColor = COLOR_VOLUME_LOUD;
        } else if( meter.dec > -1 ) {
            volumeColor = COLOR_VOLUME_WARN;
        }

        //dec.style.color = volumeColor;
        document.body.style.background = volumeColor;

        //var sliceWidth = width * 1.0 / bufferLength;
        //if( canvas.width < bufferLength ) sliceWidth = 1;

        spectrum.clearRect( 0, 0, width, height );
        //spectrum.strokeStyle = volumeColor;

        //////

        /*
        var w = 200;
        var h = 100;
        spectrum.fillRect( 0, 0, w, h );
        spectrum.strokeStyle = '#000';
        */

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

        //////

        /*
        var sw = width * 1.0 / bufferLength;
        if( canvas.width < bufferLength ) sw = 1;

        spectrum.strokeStyle = '#fff';
        spectrum.beginPath();
        var x = 0.0;
        for( i in 0...bufferLength ) {
            var v = frequencyData[i] / 128.0;
            var y = height - (v * height / 2);
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

        /*
        var barWidth = 1; //sliceWidth; //Std.int( width / bufferLength ); // * 2.5;
        var barHeight : Int;
        var x = 0.0;
        //trace(frequencyData[100]);
        for( i in 0...bufferLength ) {
            barHeight = Std.int( frequencyData[i] );
            //spectrum.fillStyle = 'rgb(' + (barHeight) + ',50,50)';
            //spectrum.fillStyle = 'rgb(' + (barHeight) + ',$barHeight,$barHeight)';
            spectrum.fillRect( x, height - barHeight / 2, barWidth, barHeight );
            x += Math.floor( barWidth );
            //x += Math.floor( barWidth + 1 );
        }
        */

        //////

        var offset = Std.int( height - (meter.vol * height) );
        //volume.style.height = offset+'px';
        //volume.style.top = offset+'px';

    }

    static function handleWindowResize(e) {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
    }

    static function handleKeyDown(e) {
        //trace(e.keyCode);
        switch e.keyCode {
        case 83: // s
            settings.toggle();
        case 27: // esc
        }
    }
    static function fatalError( info : String ) {
        document.body.innerHTML = '';
        document.body.classList.add( 'error' );
        document.body.textContent = info;
    }

    static function start() {

        document.body.removeEventListener( 'click', start );
        document.body.removeEventListener( 'touchstart', start );

        volume = cast document.getElementById( 'volume' );

        untyped navigator.getUserMedia( { audio: true, video: false },

            function(stream) {

                audio = new AudioContext();

                analyser = audio.createAnalyser();
                analyser.fftSize = 2048;

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

            canvas = cast document.getElementById( 'canvas' );
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
            document.body.appendChild( canvas );

            spectrum = canvas.getContext2d();
            spectrum.fillStyle = '#fff';
            spectrum.strokeStyle = '#fff';
            spectrum.lineWidth = 1;

            if( om.System.isMobile() ) {
                document.body.addEventListener( 'click', start, false );
                document.body.addEventListener( 'touchstart', start, false );
            } else {
                start();
            }
        }
    }

}
