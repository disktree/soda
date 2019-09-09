package soda.gui;

import js.html.Blob;
import js.html.MediaRecorder;
import js.html.MediaStream;
import js.html.audio.AudioNode;

class Recorder {

    public var element(default,null) : DivElement;
    public var recording(default,null) = false;

    var rec : MediaRecorder;
    var chunks : Array<Dynamic>;

    public function new() {
        element = document.createDivElement();
        element.classList.add( 'recorder' );
    }

    public function start( stream : MediaStream ) {
		recording = true;
        chunks = [];
        rec = new MediaRecorder( stream, {
			//mimeType: 'audio/wav'
			//mimeType: 'video/mp4'
		} );
        rec.addEventListener( 'dataavailable', handleDataAvailable );
        rec.start();
    }

    public function stop( callback : Blob->Void, type = 'audio/ogg;' ) {

		recording = false;

        var onStop : js.html.Event->Void;
        onStop = function(e){

            rec.removeEventListener( 'stop', onStop );
       	 	//rec.removeEventListener( 'dataavailable', handleDataAvailable );
			rec = null;

            var blob = new Blob( untyped chunks, { type: type } );
            chunks = [];
            
			callback( blob );

			var player = document.createAudioElement();
			player.src = js.html.URL.createObjectURL(blob);
			player.controls = true;
			element.appendChild( player );

			var ic_delete = document.createElement('i');
			ic_delete.onclick = e -> {
				ic_delete.remove();
				player.remove();
			}
			ic_delete.textContent = 'DEL';
			ic_delete.classList.add( 'ic-delete' );
			element.appendChild( ic_delete );
        }

        rec.addEventListener( 'stop', onStop );
        rec.stop();
    }

    function handleDataAvailable(e) {
        trace(e.data);
        chunks.push( e.data );
    }
}
