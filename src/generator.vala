public static void generate_site (GeneratorSettings settings) {
    Gee.Map<string, string> file_contents = new Gee.HashMap<string, string> ();
    try {
        file_contents["html"] = load_resource_data ("/index.html");
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

    } catch (Error e) {
        error ("Error: %s", e.message);
    }
}

static string load_resource_data (string path) throws GLib.Error {
    // Bytes index_file_bytes = resources_lookup_data (path, GLib.ResourceLookupFlags.NONE);
    // string file_contents = (string)index_file_bytes;

    string file_contents;
    FileUtils.get_contents (create_resource_uri (path), out file_contents);
    print ("%s contents:\n", path);
    print (file_contents);
    return file_contents;
}

static void create_asset_files (GeneratorSettings settings,
    Gee.Map<string, string> file_contents) {
    if (file_contents.has_key ("css")) {
        string dir_name = "%s/%s/styles/".printf (
            settings.current_dir,
            settings.folder_name
        );

        File css_file = File.new_build_filename (dir_name, "index.css");
        if (css_file.query_exists (null)) {
            try {
                css_file.create (GLib.FileCreateFlags.REPLACE_DESTINATION);
            } catch (Error e) {
                error ("Error %s", e.message);
            }
        }
    }

    if (file_contents.has_key ("js")) {
        string dir_name = "%s/%s/js/".printf (
            settings.current_dir,
            settings.folder_name
        );

        File css_file = File.new_build_filename (dir_name, "index.js");
        if (css_file.query_exists (null)) {
            try {
                css_file.create (GLib.FileCreateFlags.REPLACE_DESTINATION);
            } catch (Error e) {
                error ("Error %s", e.message);
            }
        }
    }
}

static void create_index_file (GeneratorSettings settings,
    Gee.Map<string, string> file_contents) {

}

static string create_resource_uri (string path) {
    return "resource://" + path;
}
