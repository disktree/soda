package soda;

import js.Browser.document;
import js.Browser.window;

/*
typedef Settings = {
    var device : Selection;
    var spectrum = {
        //var fft : IntRange<2,2948>
    };
}
*/

class App implements om.App {

    public static var isMobile(default,null) = om.System.isMobile();

    static function init() {
        om.Activity.boot( new soda.app.BootActivity() );
    }

    static function main() {

        window.onload = e->{

            document.body.innerHTML = '';

            document.addEventListener( 'contextmenu', e -> e.preventDefault() );

            init();
        }
    }
}
