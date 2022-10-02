user_pref("browser.link.open_newwindow.restriction", 0);
user_pref("browser.tabs.closeWindowWithLastTab", false);
user_pref("dom.disable_window_move_resize", true);
user_pref("media.webspeech.synth.enabled", false);
user_pref("reader.parse-on-load.enabled", false);
user_pref("security.dialog_enable_delay", 100);

// enable userChrome
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// required for Firemonkey JS inject
user_pref("security.csp.enable", false);
