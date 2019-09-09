package soda.app;

import js.Browser.document;

class BootActivity extends om.app.Activity {

    override function onCreate() {
        super.onCreate();
    }

    override function onStart() {

        var deviceId = 'default';

        document.title = 'SODA';

        om.audio.Microphone.get( deviceId ).then( function(stream){
            replace( new MainActivity( stream ) );
        }).catchError( e->{
            replace( new ErrorActivity( e ) );
        } );

        return super.onStart();
    }
}
