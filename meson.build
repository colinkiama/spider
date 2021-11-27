project('spider', 'vala', 'c',
  version: '0.0.1')

dependencies = [
  dependency('glib-2.0'),
  dependency('gobject-2.0')
]

add_project_arguments(['--enable-experimental'], language: 'vala')

# Include the GNOME module
gnome = import('gnome')

# Tell meson where to find our resources file and to compile it as a GResource
gresource = gnome.compile_resources(
    'gresource',
    'data' / 'gresource.xml',
    source_dir: 'data'
)

subdir('src')
