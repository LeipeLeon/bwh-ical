# iCal feeds from various venues in Deventer

> [!INFO]
> Why is the repo private?
> : In a public repository, scheduled workflows are automatically disabled when no repository activity has occurred in 60 days. For information on re-enabling a disabled workflow, see Disabling and enabling a workflow.
If you want acces, [drop me a line!](email:leon@wendbaar.nl)
*See: run on a [schedule](https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows#schedule)*

## Why does this exist?

Merely to scratch my own itch: I just want to have ical feeds from my favorite venues on my phone/desktop/etc w/o checking social media. (And maybe it's **FOMO**? :P)

There are venues who have a proper iCal feed:

- `Meneer de Perifeer`: <https://perifeer.org/events.ics>

The following sites have no proper iCal feeds (yet) so I provide them for you for free, e.g: "Free as in beer"[^free-as-in-beer]

- Burgerweeshuis
  - `JSON` file: <https://leipeleon.github.io/bwh-ical/bwh/events.json>
  - `iCal` file: <https://leipeleon.github.io/bwh-ical/bwh/events.ics>

- Walhalla
  - `JSON` file: <https://leipeleon.github.io/bwh-ical/walhalla/events.json>
  - `iCal` file: <https://leipeleon.github.io/bwh-ical/walhalla/events.ics>


## How it works

### Sitemap BWH

This is a quite hard one: there is no proper sitemap.xml w/ lastmod/changefreq dates so I have to pound the webserver for each event entry in the `sitemap.xml` Just scraping the index page isn't an option either b/c it has an infinite scroll.

- Retreive data from the <https://www.burgerweeshuis.nl/sitemap.xml>
- filter out events URL's (`/events/`)
- visit each url to fetch date / time / other details (the site takes another hit)
- save events to disk as a [`.json`](https://leipeleon.github.io/bwh-ical/bwh/events.json)
- generate an ical feed to disk as a [`.ics`](https://leipeleon.github.io/bwh-ical/bwh/events.json)
- deploy to `GitHub pages` w/ a github action cronjob, every hour

Why don't you use the `/events/rss.xml` feed?
: I discovered the existense of the feed mid project and didn't want to diverge my train of thougts. Maybe we'll use that later when `sitemap.xml` get's too big.


### Events page Walhalla

This site is easier. It's wordpress and uses the <https://theeventscalendar.com/> plugin (I guess) But it hasn't activated any iCal export. Also it has dedicated "upcoming" and history pages so its easier to parse.

- scrape events from the pages
  - <https://www.walhalla-deventer.nl/activiteiten/toekomstig/>
  - <https://www.walhalla-deventer.nl/activiteiten/afgelopen/?action=tribe_list&tribe_paged=1>
  *To backfill my agenda with the past events, so I can see what happened yesterday, I'm also retrieving some history*
- walk through events to extract date / time / other details
- save events to disk as a [`.json`](https://leipeleon.github.io/bwh-ical/walhalla/events.json)
- generate an ical feed to disk as a [`.ics`](https://leipeleon.github.io/bwh-ical/walhalla/events.json)
- deploy to `GitHub pages` w/ a github action cronjob, every hour

## local development

- For your OS:
  - install docker
  - install ruby (3.3.6 or higher)

Then in a terminal:

```shell
# Install dip a.k.a Docer Interaction Program (https://github.com/bibendi/dip)
gem install dip

# Build containers
dip provision

# execute the script
dip reader
```

---

*Origin story:*
> There was a time when the [Burgerweeshuis](https://www.burgerweeshuis.nl) site had an iCal feed to be used in your digital calander, be it on your device, icloud, google calendar, etc. Unfortunately the new site doesn't provide such functionality AFAIK.
>
> This project aimed to fill that gap.

[^free-as-in-beer]:"Free as in beer" free beer is a gift given to you at no cost with no expectations of you. The giver simply needs to pay for the beer and give it to you to enjoy without you needing to do anything. This is the "gratis" part of the phrase meaning "at no cost."

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

