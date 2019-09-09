package soda.app;

class SettingsActivity extends om.app.Activity {

    override function onCreate() {
        
		super.onCreate();

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
    }

    override function onStart() {
		window.addEventListener( 'keydown', handleKeyDown, false );
        return super.onStart();
    }

	override function onStop() {
		window.removeEventListener( 'keydown', handleKeyDown, false );
		return super.onStop();
	}

	function handleKeyDown(e) {
        //trace(e.keyCode);
        switch e.keyCode {
        case 83: // S
			push( new SettingsActivity() );
        case 27: // ESC
            pop();
        }
    }
}
