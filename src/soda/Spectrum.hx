package soda;

import js.Browser.document;
import js.Browser.window;
import js.html.DivElement;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.Uint8Array;
import js.html.Float32Array;

class Spectrum {

    public var element(default,null) : DivElement;

    var grid : CanvasElement;
    var canvas : CanvasElement;
    var ctx : CanvasRenderingContext2D;

    var frequencyHistory : Array<Uint8Array>;
    //var frequencyMax : Uint8Array;

    public function new() {

        element = document.createDivElement();
        element.classList.add( 'spectrum' );

        grid = document.createCanvasElement();
        grid.classList.add( 'grid' );
        grid.width = window.innerWidth;
        grid.height = window.innerHeight;
        element.appendChild( grid );

        canvas = document.createCanvasElement();
        canvas.classList.add( 'spectrum' );
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
        element.appendChild( canvas );

        ctx = canvas.getContext2d();

        drawGrid( 36 );

        frequencyHistory = [];
    }

    public function resize( width : Int, height : Int ) {
        grid.width = canvas.width = width;
        grid.height = canvas.height = height;
        drawGrid( 36 );
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

        ///// Draw history peaks

        var copy = new Uint8Array( frequency.length );
        for( i in 0...frequency.length ) copy[i] = frequency[i];
        frequencyHistory.push( copy );
        if( frequencyHistory.length > 60 ) frequencyHistory.shift();

        var frequencyMax = new Uint8Array( frequency.length );
        for( freq in frequencyHistory ) {
            for( i in 0...freq.length ) {
                var va = freq[i];
                var vb = frequencyMax[i];
                if( va > vb ) frequencyMax[i] = va;
            }
        }
        drawFrequency( frequencyMax, 'rgba(40,40,40,0.8)' );

        ///// Draw frequency

        drawFrequency( frequency, 'rgb(230,230,230)' );
    }

    function drawFrequency( data : Uint8Array, color : String ) {

        var bw = Std.int( canvas.width / data.length );
        var bh : Float;
        var px = 0.0;

        ctx.beginPath();
        ctx.fillStyle = color;

        for( i in 0...data.length ) {
            bh = canvas.height * (data[i] / canvas.height);
            ctx.fillRect( i * (bw + 1), canvas.height - bh, bw, bh );
        }
    }

    function drawGrid( dd : Int ) {
        var ctx = grid.getContext2d();
        ctx.lineWidth = 1;
        ctx.strokeStyle = 'rgb(20,20,20)';
        for( i in 0...Std.int( canvas.width/dd) ) {
            var px = i * dd;
            ctx.moveTo( px, 0 );
            ctx.lineTo( px, canvas.height );
        }
        for( i in 0...Std.int( canvas.height/dd) ) {
            var py = i * dd;
            ctx.moveTo( 0, py );
            ctx.lineTo( canvas.width, py );
        }
        ctx.stroke();
    }

}
