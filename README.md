Debian packaging files for packages maintained by me. Find PPAs (and direct .deb downloads, under "view package details") at https://launchpad.net/~deafmute. 

# Building: 

1. Update `deb-pkg/<PACKAGE>/debian/changlog`.

2. `mkdir -p deb-pkg/<PACKAGE>/debuild/<VERSION>~<SERIES>/pkg && cd package-name/debuild/<VERSION>~<SERIES>`

3. Either wget/curl the upstream tarball for `<VERSION>`, or use `uscan` and `debian/watch` file.
     (For packages with a `src` folder, use this instead of upstream tarball)

4. Extract source into build folder: `tar zxf <UPSTREAM TARBALL> -C deb-pkg/<PACKAGE>/debuild/<VERSION>~<SERIES>/pkg` 

5. Copy source tarball to orig location (if using `src` create with `tar zcf`): `mv <UPSTREAM TARBALL> deb-pkg/<PACKAGE>/debuild/<VERSION>~<SERIES>/<PACKAGE>_<VERSION>~<SERIES>~ppa<COUNT>.orig.tar.gz`

6. Build: `cd deb-pkg/<PACKAGE>/debuild/<VERSION>~<SERIES>/pkg && debuild -S`

7: Upload to launchpad: `dput ppa:deafmute/interception deb-pkg/<PACKAGE>/debuild/<VERSION>~<SERIES>/<PACKAGE>_<VERSION>~<SERIES>~ppa<COUNT>_source.changes`
