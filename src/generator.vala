public class Generator: Object {
    public HashTable<string, string> template_string_table;
    public GeneratorSettings settings { get; construct; }
    public Generator (GeneratorSettings settings) {
        Object (
            settings: settings
        );
    }

    public void run () {
        // HashTable<string, string> template_string_table = new HashTable<string, string>(str_hash, str_equal);
        Gee.Map<string, string> file_contents = new Gee.HashMap<string, string> ();
        file_contents["html"] = load_resource_data ("/templates/index.html");
        if (settings.include_css) {

            file_contents["css"] = load_resource_data ("/templates/index.css");
            file_contents["css-ref"] = load_resource_data (
                "/references/css-ref.html"
            ).strip ();
        }

        if (settings.include_js) {
            file_contents["js"] = load_resource_data ("/templates/index.js");
            file_contents["js-ref"] = load_resource_data (
                "/references/js-ref.html"
            ).strip ();
        }

        template_string_table = create_template_string_table (settings, file_contents);

        create_asset_files (settings, file_contents);
        create_html_file (settings, file_contents);
    }

    static HashTable<string, string> create_template_string_table (
        GeneratorSettings settings, Gee.Map<string, string> file_contents) {
        var table_to_return = new HashTable<string, string> (str_hash, str_equal);

        table_to_return.insert ("${CSS_REF}", settings.include_css ?
            file_contents["css-ref"] :
            ""
        );

        table_to_return.insert ("${JS_REF}", settings.include_js ?
            file_contents["js-ref"]
            : ""
        );

        table_to_return.insert ("${SITE_NAME}", "My Website");
        return table_to_return;
    }

    string load_resource_data (string path) {
        string file_contents;
        try {
            Bytes index_file_bytes = resources_lookup_data (path, GLib.ResourceLookupFlags.NONE);
            file_contents = (string)index_file_bytes.get_data ();
        } catch (Error e) {
            error (e.message);
        }

        return file_contents;
    }

    void create_asset_files (GeneratorSettings settings,
        Gee.Map<string, string> file_contents) {
        if (file_contents.has_key ("css")) {
            string dir_name = "%s/%s/styles/".printf (
                settings.current_dir,
                settings.folder_name
            );

            File css_file = try_create_file (dir_name, "index.css");
            try {
                FileUtils.set_contents (css_file.get_path (), file_contents["css"]);
            } catch (Error e) {
                error (e.message);
            }
        }

        if (file_contents.has_key ("js")) {
            string dir_name = "%s/%s/js/".printf (
                settings.current_dir,
                settings.folder_name
            );

            File js_file = try_create_file (dir_name, "index.js");
            try {
                FileUtils.set_contents (js_file.get_path (), file_contents["js"]);
            } catch (Error e) {
                error ("Error %s", e.message);
            }
        }
    }

    void create_html_file (GeneratorSettings settings,
        Gee.Map<string, string> file_contents) {
        string html_file_contents = replace_template_strings (file_contents["html"]);
        string dir_name = "%s/%s/".printf (
            settings.current_dir,
            settings.folder_name
        );

        File html_file = try_create_file (dir_name, "index.html");
        try {
            FileUtils.set_contents (html_file.get_path (), html_file_contents);
        } catch (Error e) {
            error ("Error %s", e.message);
        }
    }

    File try_create_file (string dir_name, string name) {
        File dir = File.new_for_path (dir_name);

        try {
            dir.make_directory_with_parents ();
        } catch (Error e) {
            if (e is GLib.IOError.EXISTS == false) {
                error (e.message);
            }
        }

        File file = File.new_build_filename (dir_name, name);
        try {
            file.create (GLib.FileCreateFlags.REPLACE_DESTINATION);
        } catch (Error e) {
            error (e.message);
        }

        return file;
    }

    string replace_template_strings (string original_string) {

        // try {
        //     Regex regex = new Regex ("\\${(.+?)\\}", 0, 0);
        //     return regex.replace_eval (original_string, -1, 0, 0 , eval_cb);
        // } catch (Error e) {
        //     error (e.message);
        // }
        StringBuilder sb = new StringBuilder ();
        string[] string_lines = original_string.split ("\n");

        foreach (unowned string line in string_lines) {
            try {
                Regex regex = new Regex ("\\${(.+?)\\}", 0, 0);
                string replacement_line = regex.replace_eval (line, -1, 0, 0, eval_cb);
                if (replacement_line.strip () != "") {
                    sb.append_printf ("%s\n", replacement_line);
                }
                // else {
                //     sb.append ("\n");
                // }

            } catch (Error e) {
                error (e.message);
            }
        }

        return sb.str;
    }

    bool eval_cb (MatchInfo match_info, StringBuilder result) {
        var match = match_info.fetch (0);
        string replacement = template_string_table.lookup (match);
        result.append (replacement);
        if (replacement == "") {
            result.truncate (2);

        }

        return false;
    }
}
