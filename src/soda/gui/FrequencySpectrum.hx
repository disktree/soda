package soda.gui;

import js.Browser.document;
import js.Browser.window;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.Uint8Array;
import om.Time;

class FrequencySpectrum {

    public var canvas(default,null) : CanvasElement;
    public var color(default,null) : String;
    //public var delay(default,null) : Float;

    var ctx : CanvasRenderingContext2D;
    var dataMax : Uint8Array;
    var dataHistory : Array<Uint8Array>;
    var dataHistoryDelay : Int; // frames

    public function new( color = '#fff', dataHistoryDelay = 60 ) {

        this.color = color;
        this.dataHistoryDelay = dataHistoryDelay;

        dataHistory = [];

        canvas = cast document.getElementById( 'canvas' );
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;

        ctx = canvas.getContext2d();

        resize( window.innerWidth, window.innerHeight );
    }

    public function resize( width : Int, height : Int ) {
        canvas.width = width;
        canvas.height = height;
        ctx.lineWidth = 1;
        ctx.fillStyle = color;
        ctx.strokeStyle = color;
    }

    public function draw( data : Uint8Array ) {

        ctx.clearRect( 0, 0, canvas.width, canvas.height );

        if( dataMax == null ) {
            dataMax = new Uint8Array( data.length );
            for( i in 0...data.length ) {
                dataMax[i] = data[i];
            }
        } else {
            for( i in 0...data.length ) {
                var va = data[i];
                var vb = dataMax[i];
                if( va > vb ) dataMax[i] = va;
            }
        }

        drawSpectrum( dataMax, '#1f1f1f' );

        var dataCopy = new Uint8Array( data );
        dataHistory.push( dataCopy );
        if( dataHistory.length >= dataHistoryDelay ) dataHistory.shift();
        drawSpectrum( dataHistory[0], '#586E75' );

        drawSpectrum( data, 'rgba(255,255,255,1)' );
    }

    function drawSpectrum( data : Uint8Array, color : String ) {

        var bw = Std.int( canvas.width / data.length );

        for( i in 0...data.length ) {

            var val = data[i];
            var bx = i * (bw + 1);
            var bh = canvas.height * (val / canvas.height);
            var by = canvas.height - bh;

            ctx.beginPath();
            ctx.fillStyle = color;
            ctx.fillRect( bx, by, bw, bh );
        }
    }

}
