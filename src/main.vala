[CCode (array_length = false, array_null_terminated = true)]
private static bool version = false;
private static bool include_js = false;
private static bool include_css = false;


private const GLib.OptionEntry[] MAIN_ENTRIES = {
    { "include-js", 'j', OptionFlags.NONE, OptionArg.NONE, ref include_js, "Include CSS File", null },
    { "include-css", 'c', OptionFlags.NONE, OptionArg.NONE, ref include_css, "Include JavaScript file", null },
    { "version", '\0', OptionFlags.NONE, OptionArg.NONE, ref version, "Display version number", null },
    // list terminator
    { }
};

public static int main (string[] args) {
    // For more info, check out: https://valadoc.org/glib-2.0/GLib.OptionContext.html
    var opt_context = new OptionContext ("- Quickly generate a HTML5 site structure");
    try {
        opt_context.set_help_enabled (true);
        opt_context.add_main_entries (MAIN_ENTRIES, null);
        opt_context.parse (ref args);
    } catch (OptionError e) {
        stderr.printf ("error: %s\n", e.message);
        stderr.printf ("Run '%s --help' to see a full list of available command line options.\n", args[0]);
        return 1;
    }

    if (version) {
        stdout.printf ("0.0.1");
        return 0;
    }

    if (args.length == 1) {
        print ("Default action is performed here!\n");
    }

    return 0;
}
