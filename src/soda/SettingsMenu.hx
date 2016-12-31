package soda;

import js.Browser.document;
import js.Browser.window;
import js.html.Element;
import js.html.DivElement;

class SettingsMenu {

    var element : Element;

    public function new() {
        element = document.getElementById( 'settings' );
    }

    public function isVisible() {
        return element.classList.contains( 'show' );
    }

    public function show() {
        element.classList.remove( 'hide' );
        element.classList.add( 'show' );
    }

    public function hide() {
        element.classList.remove( 'show' );
        element.classList.add( 'hide' );
    }

    public function toggle() {
        trace(isVisible());
        isVisible() ? hide() : show();
    }


}
