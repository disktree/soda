package soda;

import js.Browser.document;
import js.Browser.window;
import js.html.DivElement;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.Uint8Array;
import js.html.Float32Array;

class Spectrum {

    public var canvas(default,null) : CanvasElement;

    var ctx : CanvasRenderingContext2D;

    public function new( canvas : CanvasElement ) {
        this.canvas = canvas;
        ctx = canvas.getContext2d();
    }

    public function resize( width : Int, height : Int ) {
        canvas.width = width;
        canvas.height = height;
        //ctx.lineWidth = 1;
        //ctx.fillStyle = color;
        //ctx.strokeStyle = color;
    }

    public function draw( frequency : Uint8Array, waveform : Float32Array ) {

        ctx.clearRect( 0, 0, canvas.width, canvas.height );

        var bw = canvas.width / waveform.length;
        var px = 0.0;

        ///// Draw waveform

        ctx.strokeStyle = 'rgb(90,90,90)';
        ctx.beginPath();

        for( i in 0...waveform.length ) {
            var py = waveform[i] * canvas.height / 2 + (canvas.height/2);
            if( i == 0) {
                ctx.moveTo( px, py );
            } else {
                ctx.lineTo( px, py );
            }
            px += bw;
        }

        ctx.lineTo( canvas.width, canvas.height/2 );
        ctx.stroke();

        ///// Draw frequency

        bw = Std.int( canvas.width / frequency.length );
        px = 0.0;

        var bh : Float;

        ctx.beginPath();
        ctx.fillStyle = 'rgb(230,230,230)';

        for( i in 0...frequency.length ) {
            bh = canvas.height * (frequency[i] / canvas.height);
            ctx.fillRect( i * (bw + 1), canvas.height - bh, bw, bh );
        }
    }

}
