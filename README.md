# TVHeadend Home Assistant Add-On

[![GitHub Release][releases-shield]][releases]
![Project Stage][project-stage-shield]
[![License][license-shield]](LICENSE.md)

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armv7 Architecture][armv7-shield]

[![Github Actions][github-actions-shield]][github-actions]
![Project Maintenance][maintenance-shield]
[![GitHub Activity][commits-shield]][commits]
[![Community Forum][forum-shield]][forum]

TVHeadend is a TV streaming server and recorder.

## About

TVHeadend is a TV streaming server and recorder supporting:
DVB-S, DVB-S2, DVB-C, DVB-T, DVB-T2, ATSC, ISDB-T, IPTV, SAT>IP and HDHomeRun
as input sources.
TVHeadend offers the HTTP (VLC, MPlayer), HTSP (Kodi, Movian) and SAT>IP streaming.

Multiple EPG sources are supported such as
over-the-air DVB and ATSC including OpenTV DVB extensions, XMLTV, PyXML.

![TVHeadend](images/screenshot.png)

As TVHeadend stopped to create releases in 2017, this addon-on builds TVHeadend from
the master branch.

This add-on has the following additional software preinstalled:

- [picons][picons]: Channel icons
- [Comskip][comskip]: A tool to mark commercials in recordings (autoskipped in Kodi)
- [Comchap & Comcut][comchap]: Utilities to add chapters or cut commercials based on detected commercials from Comskip
- [StreamLink][streamlink]
- [WebGrab++][wg++]: A XMLTV EPG grabber for many sites. Useful in case OTA EPG is not sufficient.

[:books: Read the full add-on documentation][docs]

## Support

Got questions?

Please start a [discussion][discussions] or create an [issue][issues] on Github

## Contributing

This is an active open-source project. We are always open to people who want to
use the code or contribute to it.

We have set up a separate document containing our
[contribution guidelines](CONTRIBUTING.md).

Thank you for being involved! :heart_eyes:

## Authors & contributors

This repository was intially cloned from [GauthamVarmaK][gautham]'s
[addon-tvheadend][original-repository]. repository. As the original
[gautham/addon-tvheaded][original-repository] is no longer maintained, I [Daniel Figus][dfigus] took
it over.

This has been possible thanks to the community add-ons initiative by [Frenck]

For a full list of all authors and contributors,
check [the contributor's page][contributors].

## License

MIT License

Copyright (c) 2023-2025 Daniel Figus

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

[contributors]: https://github.com/dfigus/addon-tvheadend/graphs/contributors
[docs]: https://github.com/dfigus/addon-tvheadend/blob/main/tvheadend/DOCS.md
[forum-shield]: https://img.shields.io/badge/community-forum-brightgreen.svg
[picons]: https://github.com/picons/picons
[comskip]: https://github.com/erikkaashoek/Comskip
[comchap]: https://github.com/BrettSheleski/comchap
[streamlink]: https://streamlink.github.io/
[wg++]: http://www.webgrabplus.com/
[forum]: https://community.home-assistant.io/
[gautham]: https://github.com/GauthamVarmaK
[dfigus]: https://github.com/dfigus
[frenck]: https://github.com/frenck
[github-actions-shield]: https://github.com/dfigus/addon-tvheadend/workflows/CI/badge.svg
[github-actions]: https://github.com/dfigus/addon-tvheadend/actions
[issues]: https://github.com/dfigus/addon-tvheadend/issues
[discussions]: https://github.com/dfigus/addon-tvheadend/discussions
[license-shield]: https://img.shields.io/github/license/dfigus/addon-tvheadend.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2025.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-production%20ready-brightgreen.svg
[releases-shield]: https://img.shields.io/github/release/dfigus/addon-tvheadend.svg
[releases]: https://github.com/dfigus/addon-tvheadend/releases
[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[original-repository]: https://github.com/GauthamVarmaK/addon-tvheadend
[commits-shield]: https://img.shields.io/github/commit-activity/y/dfigus/addon-tvheadend.svg
[commits]: https://github.com/dfigus/addon-tvheadend/commits/main
