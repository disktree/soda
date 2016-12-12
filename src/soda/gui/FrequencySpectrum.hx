package soda.gui;

import js.Browser.document;
import js.Browser.window;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.Uint8Array;

class FrequencySpectrum {

    public var canvas(default,null) : CanvasElement;
    public var color(default,null) : String;

    var context : CanvasRenderingContext2D;

    public function new( color = '#fff' ) {

        this.color = color;

        canvas = cast document.getElementById( 'canvas' );
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;

        context = canvas.getContext2d();

        resize( window.innerWidth, window.innerHeight );
    }

    public function resize( width : Int, height : Int ) {
        canvas.width = width;
        canvas.height = height;
        context.lineWidth = 1;
        context.fillStyle = color;
        context.strokeStyle = color;
    }

    public function draw( data : Uint8Array ) {

        context.clearRect( 0, 0, canvas.width, canvas.height );

        /*
        var sw = Std.int( canvas.width * 1.0 / data.length );
        var x = 0.0;
        context.beginPath();
        for( i in 0...data.length ) {
            var v = data[i]; // / 128.0;
            var y = v * canvas.height / 100 / 4;
            if( i == 0) {
                context.moveTo( x, y );
            } else {
                context.lineTo( x, y );
            }
            x += sw;
        }
        //context.lineTo( canvas.width, canvas.height / 2 );
        context.stroke();
        */

        var barWidth = Std.int( canvas.width / data.length );
        for( i in 0...data.length ) {
            var v = data[i];
            var percent = v / canvas.height;
            var height = canvas.height * percent;
            var offset = canvas.height - height - 1;
            //var hue = i;
            //context.fillStyle = 'hsl(' + hue + ', 100%, 50%)';
            context.fillRect( i * barWidth, offset, barWidth, height );
        }
    }

}
