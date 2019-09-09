package soda.app;

class ErrorActivity extends om.app.Activity {

    var error : String;

    public function new( error : String ) {
        super();
        this.error = error;
    }

    override function onCreate() {
        super.onCreate();
        element.classList.add( 'error' );
        element.textContent = 'ERROR: '+error;
    }
}
