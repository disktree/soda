package soda;

import js.Browser.document;
import js.Browser.window;
import om.app.Activity;

class App implements om.App {

	public static var isMobile(default, null) = om.System.isMobile();

	static function init() {
		Activity.boot(new soda.app.BootActivity());
	}

	static function main() {

		window.onload = e -> {
			
			document.body.innerHTML = '';

			document.addEventListener('contextmenu', e -> e.preventDefault());

			init();
		}
	}
}
