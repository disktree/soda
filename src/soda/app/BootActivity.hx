package soda.app;

import js.Browser.document;

class BootActivity extends om.app.Activity {

    override function onCreate() {
        super.onCreate();
    }

    override function onStart() {

        var deviceId = 'default';

        document.title = 'SODA';

        /*
        var select = document.createSelectElement();
        om.audio.Device.get().then( (devices:Array<Dynamic>)->{
            trace(devices);
            for( dev in devices ) {
                trace(dev);
                switch dev.kind {
                case 'audioinput':
                    var opt = document.createOptionElement();
                    opt.textContent = dev.label;
                    select.appendChild( opt );
                }
            }
        });
        select.onchange = function(e){
            trace(e);
        }
        element.appendChild( select );
        */

        om.audio.Microphone.get( deviceId ).then( function(stream){
            replace( new MainActivity( stream ) );
        }).catchError( e->{
            replace( new ErrorActivity( e ) );
        } );

        return super.onStart();
    }
}
