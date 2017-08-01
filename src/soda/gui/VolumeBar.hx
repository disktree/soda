package soda.gui;

import js.Browser.document;
import js.Browser.window;
import js.html.DivElement;

class VolumeBar {

    public var element(default,null) : DivElement;

    public function new() {

        element = document.createDivElement();
        element.classList.add( 'volumebar' );
        element.style.background = '#fff';

        //element = document.createDivElement();
        //element.classList.add( 'volumebar' );
        //element.style.background = '#0000ff';
    }

    public function setValue( volume : Float ) {
        var v = Std.int( volume * window.innerHeight * 10 );
        element.style.height =  v+ 'px';
        element.style.top =  (window.innerHeight - v)+ 'px';
    }
}
