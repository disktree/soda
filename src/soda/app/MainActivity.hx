package soda.app;

import js.html.MediaRecorder;
import js.html.MediaStream;
import js.html.audio.AudioContext;
import js.html.audio.AnalyserNode;
import js.html.audio.MediaStreamAudioSourceNode;
import om.audio.VolumeMeter;
import om.audio.WAV;
import om.audio.generator.Noise;
import soda.gui.Recorder;
import soda.gui.Spectrum;
import soda.gui.VolumeBar;

class MainActivity extends om.app.Activity {

    var frameId : Int;

    var stream : MediaStream;
    var audio : AudioContext;
    var microphone : MediaStreamAudioSourceNode;
    var frequencyAnalyser : AnalyserNode;
    var waveformAnalyser : AnalyserNode;
    var frequencyData : Uint8Array;
	var waveformData : Uint8Array;
    var meter : VolumeMeter;

    var info : DivElement;
    var volumeBar : VolumeBar;
    var spectrum : Spectrum;
    //var settings : SettingsMenu;
    //var spectrum3D : soda.gui.Spectrum3D;
	var noise : NoiseGenerator;
	var recorder : Recorder;
	//var rec : MediaRecorder;

    public function new( stream : MediaStream ) {

        super();
        this.stream = stream;

        audio = new AudioContext();

        frequencyAnalyser = audio.createAnalyser();
        //frequencyAnalyser.fftSize = 128;
        //analyser.minDecibels = -100;
        //analyser.maxDecibels = -30;
        //frequencyAnalyser.connect( audio.destination );

        waveformAnalyser = audio.createAnalyser();
        //waveformAnalyser.fftSize = 2048;
        //waveformAnalyser.smoothingTimeConstant = 0.1;
        waveformAnalyser.connect( frequencyAnalyser );

        frequencyData = new Uint8Array( frequencyAnalyser.frequencyBinCount );
        waveformData = new Uint8Array( waveformAnalyser.frequencyBinCount );
		
        microphone = audio.createMediaStreamSource( stream );
        microphone.connect( waveformAnalyser );

        meter = new om.audio.VolumeMeter( audio );
        microphone.connect( meter.processor );

		//noise = new NoiseGenerator( audio );
		//noise.pink = true;
		//noise.brown = true;
		//noise.white = true;
	
		/*
		var noiseBufferSize = 4096;
		 var brownNoise = audio.createScriptProcessor( noiseBufferSize, 1, 1 );
    		brownNoise.onaudioprocess = function(e) {
                Noise.generateBrownNoise( e.outputBuffer.getChannelData(0), noiseBufferSize );
                //dirtySpectrum = true;
            };
		brownNoise.connect( audio.destination  );
    	*/

		/*
		var chunks = [];
		rec = new MediaRecorder( stream );
        rec.addEventListener( 'dataavailable', function(e) {
			trace(e);
			chunks.push( e.data );
		} );
		rec.addEventListener( 'stop', function(e){
			trace(e);

			var blob = new Blob( chunks, { type: 'audio/wav;' } );

			chunks = [];

			//var wav = WAV.encodeAudioBuffer( buf );

			//om.DOM.saveFile( 'test.wav', blob, 'audio/wav' );

			var url = js.html.URL.createObjectURL(blob);
            var player = document.createAudioElement();
            player.src = url;
            player.controls = true;
            player.style.cssText = 'position:fixed; z-index:1000;';
            document.body.appendChild( player );
		} );
        rec.start();
		*/
	
		recorder = new Recorder();
       	element.appendChild( recorder.element );
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
        element.appendChild( info );

		/*
		haxe.Timer.delay( function(){
			recorder.stop( function(blob){
				trace(blob);

				//om.DOM.saveFile( 'test.wav', blob, 'audio/wav' );

				var url = js.html.URL.createObjectURL(blob);

                var player = document.createAudioElement();
                player.src = url;
                player.controls = true;
                player.style.cssText = 'position:fixed; z-index:1000;';
                element.appendChild( player );


			}, 'audio/wav' );
		}, 2000);
		*/

		/*
		haxe.Timer.delay( function(){
			recorder.stop( function(blob) {
				trace(blob); 

				var url = js.html.URL.createObjectURL(blob);

                var player = document.createAudioElement();
                player.src = url;
                player.controls = true;
                player.style.cssText = 'position:fixed; z-index:1000;';
                element.appendChild( player );
			}, 'audio/wav' );
		}, 2000);
		*/
    }

    override function onStart() {

        frameId = window.requestAnimationFrame( update );

        document.addEventListener( 'webkitvisibilitychange', handlePageVisibilityChange, false );
        window.addEventListener( 'resize', handleWindowResize, false );
        window.addEventListener( 'keydown', handleKeyDown, false );

        return super.onStart();

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

        spectrum.draw( frequencyData, waveformData );
        //spectrum3D.draw( frequencyData, waveformData );

        volumeBar.setValue( meter.volume );

        info.textContent = Std.int( meter.decibel ) + 'db';

        document.title = Std.int( meter.decibel ) + 'db';
    }

    function handleKeyDown(e) {
        switch e.keyCode {
        case 82: // R
			if( recorder.recording )
				recorder.stop( function(b){
					/*
					var url = js.html.URL.createObjectURL(b);
					var player = document.createAudioElement();
					player.src = url;
					player.controls = true;
					player.style.cssText = 'position:fixed; z-index:1000;';
					document.body.appendChild( player );
					*/
				}, 'audio/wav' );
			else
				recorder.start( stream );
        case 83: // S
			push( new SettingsActivity() );
        case 27: // ESC
			//
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
