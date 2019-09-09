package soda.gui;

class VolumeBar {

    public var element(default,null) : DivElement;

    public function new() {
        element = document.createDivElement();
        element.classList.add( 'volumebar' );
        element.style.background = '#fff';
    }

    public function setValue( volume : Float ) {
        var v = Std.int( volume * window.innerHeight );
        element.style.height =  Std.int(v)+ 'px';
        element.style.top =  (window.innerHeight - v)+ 'px';
    }
}
