# spider

Quickly generate a HTML5 site structure

## Building, Testing, and Installation

You'll need the following dependencies to build:
* meson
* valac

Run `meson build` to configure the build environment and run `ninja` to build:

```Bash
meson build --prefix=/usr
cd build
ninja
```

To install, use `ninja install`, then execute with `spider`:

```Bash
sudo ninja install
spider [options?] FOLDER_NAME
```

**The Site structure:**

```
index.html
styles/
  index.css
js/
  index.js
```

To include the css and js files into your site, please add -c and -j flags to the command respecitvely.

For example, to produce a site with html, js and css already setup, perform the following command:

```Bash
spider -c -j FOLDER_NAME
```
