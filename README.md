# docker-gnome-builder-meson
Run gnome-builder inside a docker container, without having to build/install dependencies on your host. Meson builds


# wrap-dbus

```
Since tumbler is a D-Bus service, rygel has to have access to a D-Bus session
bus. To accomplish this you need to copy the included D-Bus wrapper script
"wrap-dbus" somewhere and modify the upstart script to call a wrapped rygel:

 exec /usr/local/bin/wrap-dbus rygel

wrap-dbus makes sure that a session bus is running and will re-use an existing
bus it spawned itself.

After (re-) starting rygel, it should start requesting thumbnail generation
for files that don't have thumbnails. If you don't see them in your client
right away, you might have to refresh the view.
```
