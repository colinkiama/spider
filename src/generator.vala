public static void generate_site (GeneratorSettings settings) {
    Gee.Map<string, string> file_contents = new Gee.HashMap<string, string> ();
    file_contents["html"] = load_resource_data ("/templates/index.html");
    if (settings.include_css) {

        file_contents["css"] = load_resource_data ("/templates/index.css");
        file_contents["css-ref"] = load_resource_data ("/references/css-ref.html");
    }

    if (settings.include_js) {
        file_contents["js"] = load_resource_data ("/templates/index.js");
        file_contents["js-ref"] = load_resource_data ("/references/js-ref.html");
    }

    create_asset_files (settings, file_contents);
    create_index_file (settings, file_contents);
}

static string load_resource_data (string path) {
    string file_contents;
    try {
        Bytes index_file_bytes = resources_lookup_data (path, GLib.ResourceLookupFlags.NONE);
        file_contents = (string)index_file_bytes.get_data ();
        print ("%s contents:\n", path);
        print (file_contents);

    } catch (Error e) {
        error (e.message);
    }

    return file_contents;
}

static void create_asset_files (GeneratorSettings settings,
    Gee.Map<string, string> file_contents) {
    if (file_contents.has_key ("css")) {
        string dir_name = "%s/%s/styles/".printf (
            settings.current_dir,
            settings.folder_name
        );

        File css_file = try_create_file (dir_name, "index.css", "");
        // TODO: fill CSS File with it's CSS Content. Replace template strings
        // with actual values. (You could do this using a method)
        // Fastest way is to use Regex.replace_eval: https://valadoc.org/glib-2.0/GLib.Regex.replace_eval.html
    }

    if (file_contents.has_key ("js")) {
        string dir_name = "%s/%s/js/".printf (
            settings.current_dir,
            settings.folder_name
        );

        File js_file = File.new_build_filename (dir_name, "index.js");
        try {
            js_file.create (GLib.FileCreateFlags.REPLACE_DESTINATION);
        } catch (Error e) {
            error ("Error %s", e.message);
        }

    }
}

static void create_index_file (GeneratorSettings settings,
    Gee.Map<string, string> file_contents) {

}

static File try_create_file (string dir_name, string name, string contents) {
    File dir = File.new_for_path (dir_name);

    try {
        dir.make_directory_with_parents ();
    } catch (Error e) {
        error (e.message);
    }

    File file = File.new_build_filename (dir_name, "index.css");
    if (!file.query_exists (null)) {
        try {
            file.create (GLib.FileCreateFlags.REPLACE_DESTINATION);
        } catch (Error e) {
            error (e.message);
        }
    }

    return file;
}
