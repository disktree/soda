package soda.app;

class BootActivity extends om.Activity {

    override function onCreate() {
        super.onCreate();
        element.textContent = 'Booting ...';
    }

    override function onStart() {

        super.onStart();

        /*
        //TODO
        om.audio.Device.get().then( (devices)->{
            trace(devices);
        });
        */

        var audio = new js.html.audio.AudioContext();

        om.audio.Microphone.get().then( function(stream){
            replace( new MainActivity( audio, stream ) );
        }).catchError( e->{
            replace( new ErrorActivity( e ) );
        } );
    }
}
