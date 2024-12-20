# iCal feed from BWH site

There was a time when the [Burgerweeshuis](https://www.burgerweeshuis.nl) site had an iCal feed to be used in your digital calander, be it on your device, icloud, google calendar, etc. Unfortunately the new site doesn't provide such functionality AFAIK.

This project aims to fill that gap.

JSON file: https://leipeleon.github.io/bwh-ical/events.json
iCal file: https://leipeleon.github.io/bwh-ical/events.ics

## How it works

- Retreive events from the <https://www.burgerweeshuis.nl/sitemap.xml>
- filter out events URL's (`/events/`)
- visit each url to fetch date / time / other details
- save events to disk as a [`.json`](https://leipeleon.github.io/bwh-ical/events.json)
- generate an ical feed to disk as a [`.ics`](https://leipeleon.github.io/bwh-ical/events.json)
- deploy to `GitHub pages` w/ a github action cronjob, every hour

Q: Why don't you use the `/events/rss.xml` feed?
A: I discovered the existense of the feed mid project and didn't want to diverge my train of thougts. Maybe we'll use that later when `sitemap.xml` get's too big.

## update local sources for development

```shell
CURRENT_DATE=$(date "+%Y-%m-%d-%H%M")
curl https://www.burgerweeshuis.nl/ > src/index-${CURRENT_DATE}.html
curl https://www.burgerweeshuis.nl/sitemap.xml > src/sitemap-${CURRENT_DATE}.xml
```

## local development

- for your OS:
  - install docker
  - install ruby (3.3.6 or higher)

```shell
# Then in a terminal:
gem install dip
dip provision
dip up
```

## LICENSE

MIT License

Copyright (c) 2024 Leon Berenschot

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
