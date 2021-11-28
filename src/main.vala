private static bool version = false;
private static bool include_js = false;
private static bool include_css = false;
[CCode (array_length = false, array_null_terminated = true)]
private static string[] commands;

private const GLib.OptionEntry[] MAIN_ENTRIES = {
    { "include-css", 'c', OptionFlags.NONE, OptionArg.NONE, ref include_css, "Include JavaScript file", null },
    { "include-js", 'j', OptionFlags.NONE, OptionArg.NONE, ref include_js, "Include CSS File", null },
    { "version", '\0', OptionFlags.NONE, OptionArg.NONE, ref version, "Display version number", null },
    { OPTION_REMAINING, 0, 0, OptionArg.STRING_ARRAY, ref commands, (string)0, "FOLDER_NAME" },
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

    print ("Commands length: %d\n", commands.length);
    if (commands.length == 0) {
        // print ("Default action is performed here!\n");
        print (opt_context.get_help (true, null));
        return 1;
    }

    if (commands.length > 1) {
        print (
            "Too many args." +
            "Run '%s --help' to see a full list of" +
            "available command line options.",
            args[0]
        );

        return 1;
    }

    var generator_settings = GeneratorSettings () {
        folder_name = commands[0],
        include_css = include_css,
        include_js = include_js,
        current_dir = Environment.get_current_dir ()
    };

    Generator generator = new Generator (generator_settings);
    generator.generate_site ();

    return 0;
}
