# TVHeadend Home Assistant Add-On

[TVHeadend][tvheadend] is a TV streaming server and recorder supporting:
DVB-S, DVB-S2, DVB-C, DVB-T, DVB-T2, ATSC, ISDB-T, IPTV, SAT>IP and HDHomeRun
as input sources.
TVHeadend offers the HTTP (VLC, MPlayer), HTSP (Kodi, Movian) and SAT>IP streaming.

Multiple EPG sources are supported such as
over-the-air DVB and ATSC including OpenTV DVB extensions, XMLTV, PyXML.

This add-on has the following additional software preinstalled:

- [picons][picons]: Channel icons
- [Comskip][comskip]: A tool to mark commercials in recordings (autoskipped in Kodi)
- [Comchap & Comcut][comchap]: Utilities to add chapters or cut commercials based on detected commercials from Comskip
- [StreamLink][streamlink]
- [WebGrab++][wg++]: A XMLTV EPG grabber for many sites. Useful in case OTA EPG is not sufficient.

In order to use them, additional TVHeadend configuration need to be done, which are
outlined in here.

## Installation

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Home Assistant add-on.

1. Add this repository to have addons by Daniel Figus:
   [![Home Assistant with repository URL pre-filled][my-ha-shield]][my-ha-repo]
1. Search for the "TVHeadend" add-on in the Supervisor add-on store and install it.
1. Start the "TVHeadend" add-on.
1. Check the logs of the "TVHeadend" to see if everything went well.
1. Click the "OPEN WEB UI" button and start using it.
1. Ready to go!

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

Example add-on configuration:

```yaml
system_packages:
  - ffmpeg
init_commands:
  - echo 'Hello World'
args:
  - --satip_xml  http://192.168.1.1:49000/satipdesc.xml
```

**Note**: _This is just an example, don't copy and paste it! Create your own!_

### Option: `system_packages`

Allows you to specify additional [Alpine packages][alpine-packages] to be
installed to the TVHeadend Addon (e.g., `ffmpeg`, `g++`, etc. ). The list of already installed
packages can be found in the [Dockerfile][dockerfile].

**Note**: _Adding many packages will result in a longer start-up time for the add-on._

### Option: `init_commands`

Customize your TVHeadend environment even more with the `init_commands` option.
Add one or more shell commands to the list, and they will be executed
every single time this add-on starts.

### Option: `args`

Additional startup arguments to be passed to TVHeadend. A list of command line
arguments can be found [here][tvh-args].
The addon itself will use the following arguments, hence do not use them:

- `--http-root`: This will be set to the HA `ingress_path` to enable the HA Ingress feature

If you use a Fritz!Box with integrated DVC-C tuners, you might want to use the
`--satip_xml  http://<your Fritz!BoxIP>:49000/satipdesc.xml` argument.

As the addon-on will be regularily updated to the latest TVHeadend master version, TVHeadend also does
a configuration migration quite often. To avoid the configuration backup (which can easily take 20-30 mins),
you can use `--nobackup`.

### Option: `comskip_ini`

Content that should be used for the `comskip.ini`, which will be stored at `/config/tvheadend/comskip/comskip.ini`.
The `comskip.ini` is required to tell Comskip how to detect commercials in the recording. See also the [Comskip section](Comskip).
It is recommended to edit it in YAML and use the [YAML literal style][yaml-literal] to preserve newline.

### Option: WebGrab+Plus Channels `wg_channels`

A list of channels that shall be used by WebGrab+Plus. Example:

```
wg_channels:
  - country: "Germany"
    site: "tvtoday.de"
    channel: "ard"
  - country: "Germany"
    site: "tvtoday.de"
    channel: "zdf"
```

This will add two channels from the `siteini.pack` folder to the WebGrab+Plus XML config file. The country is translated to the folder name `Germany`, the site is used to find the `tvtoday.de.channels.xml` file and the `channel` is used to find the `<channel site_id="ard">` and `<channel site_id="zdf">` entries. All names are _case-sensitive_. The matching channels are copied over to the default WebGrab+Plus configuration XML (with the dummy channel removed).

### Option: WebGrab+Plus Configuration XML `wg_config`

As a more advanced user you might want to fully customize the WebGrab+Plus configuration file. This allows you to enter your WebGrab+Plus license or use decrypt keys. Do not use this configuration together with the simple `wg_channel` configuration.

## Additional Configuration

### Picons

[Picons][picons] are channel icons that can be included into TVHeadend and are automatically served to Kodi and
other consuming apps. This addon-on includes the following picons:

- `/picons/snp/`: `snp-full.220x132-190x102.light.on.transparent` (symlink)
- `picons/srp`: `srp-full.220x132-190x102.light.on.transparent` (symlink)

In order to use the picons in TVHeadend, you need to set those paths in the TVHeadend Configuration->General->Base:
![picons-config](https://github.com/dfigus/addon-tvheadend/raw/main/images/picons-config.png)

I might consider adding this to the default configuration for new installations in the future.

In case you already had channels configured earlier, you need to reset the icons via Configuration->Channel/EPG->Channels.
You need to select all channels via `CTRL-A` and afterwards click on `Reset Icon`:
![picons-reset-icons](https://github.com/dfigus/addon-tvheadend/raw/main/images/picons-reset-icons.png)

### Comskip

Comskip is a commercial detector and creates additional files for chapters, that are automatically skipped e.g. via Kodi.
Comskip WILL NOT cut the commercials from your recordings. This can be done via Comcut, included as well. As Comskip also
does not longer create new releases, this add-on comes with a self-compiled version from the current master branch. The Comskip
executable can be found in `/usr/bin/comskip`.

Comskip needs a configuration (ini) file in order to properly
detect the commercial. Those ini files are usually country dependent and can be obtained in the [Comskip Forum][comskip-forum].
You can use the [comskip_ini config option](#option-comskip_ini) to let the addon store the `comskip.ini`.
Afterwards configure Comskip as a recording post-processor command in Configuration->Recording->Digital Video Recorder Profiles, e.g.:
`/usr/bin/comskip --ini=/config/tvheadend/comskip/comskip.ini "%f`

![comskip-config](https://github.com/dfigus/addon-tvheadend/raw/main/images/comskip-config.png)

### Comchap & Comcut

Comchap and Comcut are utility scripts that use the file producted by Comskip to add chapters to the recordings (Comchap) or even cut
them entirely (Comcut) from the recording. The scripts are located in `/usr/bin/comchap` and `/usr/bin/comcut`. Those could be run as a post-processor command after recording.

Further information how to use them can be found [here][comchap].

### WebGrab+Plus

This addon comes with preinstalled WebGrab+Plus, a XMLTV EPG grabber. The TVHeadend integration is already done and the grabber runs every night at 0:00.
In order to enable the WebGrab+Plus grabber, you need to enable it in TVHeadend Configuration -> Channel / EPG -> EPG Grabber Modules:

![tvh_wg++][https://github.com/dfigus/addon-tvheadend/raw/main/images/tvh_wg++.png]

Further information can be found [here][wg++]

### Additional Details

- Config files are stored in `/config/tvheadend/` and will be backed up with the addon-on
- Recording files are stored in `/share/tvheadend/recordings/` and will NOT be backed up with the addon-on,
  but with HA full-backups!
- `/dev/dvb/`, `/dev/dri/` would be respectively mapped to
  `/dev/dvb/`, `/dev/dri/` inside the addon.

## Changelog & Releases

This repository keeps a change log using [GitHub's releases][releases]
functionality.

Releases are based on [Semantic Versioning][semver], and use the format
of `MAJOR.MINOR.PATCH`. In a nutshell, the version will be incremented
based on the following:

- `MAJOR`: Incompatible or major changes.
- `MINOR`: Backwards-compatible new features and enhancements.
- `PATCH`: Backwards-compatible bugfixes and package updates.

## Support

Got questions?

You have several options to get them answered:

- The Home Assistant [Community Forum][forum].
- You could also [open an issue here][issue] GitHub.

## Authors & contributors

This repository is owned and maintained by [Daniel Figus][dfigus].

This has been possible thanks to the community add-ons initiative by [Frenck][frenck]

## License

MIT License

Copyright (c) 2023-2024 Daniel Figus

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[tvh-args]: https://github.com/tvheadend/tvheadend/blob/master/docs/markdown/cmdline_options.md
[yaml-literal]: https://yaml.org/spec/1.2.2/#812-literal-style
[picons]: https://github.com/picons/picons
[comskip]: https://github.com/erikkaashoek/Comskip
[comchap]: https://github.com/BrettSheleski/comchap
[comskip-forum]: https://www.kaashoek.com/comskip/
[streamlink]: https://streamlink.github.io/
[wg++]: http://www.webgrabplus.com/
[tvheadend]: https://tvheadend.org/
[alpine-packages]: https://pkgs.alpinelinux.org/packages
[dockerfile]: https://github.com/dfigus/addon-tvheadend/blob/main/tvheadend/Dockerfile#L172-L206
[forum]: https://community.home-assistant.io/
[frenck]: https://github.com/frenck
[dfigus]: https://github.com/dfigus
[my-ha-shield]: https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg
[issue]: https://github.com/dfigus/addon-tvheadend/issues
[semver]: http://semver.org/spec/v2.0.0.htm
[my-ha-repo]: https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fdfigus%2Fhassio-addons
[releases]: https://github.com/dfigus/addon-tvheadend/releases
