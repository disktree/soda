
using Skulp;
using skulp.ext.Console;
using skulp.ext.LessCSS;
using skulp.ext.Process;

class Build {

    static function App() {

        //Sys.println( 'Building application' );
        //Skulp.print( 'Building application' );

        //Skulp.file( 'res/style/soda.less' ).log();

        Skulp.file( 'res/html/index.html' ).end( 'bin/index.html' );
        Skulp.file( 'res/web/manifest.json' ).end( 'bin/manifest.json' );
        //Skulp.file( 'res/style/soda.less' ).lessc().end('bin/soda.css');
        Skulp.file( 'res/style/soda.less' ).lessc('bin/soda.css').end();
        //Skulp.file( 'res/style/soda.less' ).process('lessc',['-','bin/soda.css']).end( 'bin/soda.css' );
        return;

        /*
        var p = new sys.io.Process( 'lessc -' );
        //var p = new sys.io.Process( 'lessc', ['-','<<<','body {color:red;}','bin/soda.css'] );
        //var p = new sys.io.Process("lessc",['res/style',"bin/soda.css"]); // run ls -l in current directory
        //var bytes = haxe.io.Bytes.ofString('body{color:green;}');
        var f = sys.io.File.read('res/style/soda.less');
        p.stdin.writeInput( f );
    //    trace("process id: " + p.getPid());
        //p.stdin.flush();

        //trace("exitcode: " + p.exitCode());

        // read everything from stderr
        //var error = p.stderr.readAll().toString();
        //trace("stderr:\n" + error);
        // read everything from stdout
        //var stdout = p.stdout.readAll().toString();
        //trace("stdout:\n" + stdout);
        p.close();
        trace( p.stderr.readAll() );
        trace( p.stdout.readAll() );
        */

        /*
        var p = new sys.io.Process( 'lessc - <<< "'+sys.io.File.getContent('res/style/soda.less')+'" bin/soda.css' );
        //var p = new sys.io.Process( 'lessc', ['-','<<<','body {color:red;}','bin/soda.css'] );
        //var p = new sys.io.Process("lessc",['res/style',"bin/soda.css"]); // run ls -l in current directory
        trace("exitcode: " + p.exitCode());
    //    trace("process id: " + p.getPid());
// read everything from stderr
var error = p.stderr.readAll().toString();
trace("stderr:\n" + error);
// read everything from stdout
var stdout = p.stdout.readAll().toString();
trace("stdout:\n" + stdout);
p.close(); // close the process I/O
*/

    }

}
