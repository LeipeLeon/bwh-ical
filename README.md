# iCal feed from BWH site

There was a time when the [Burgerweeshuis](https://www.burgerweeshuis.nl) site had an iCal feed to be used in your digital calander, be it on your device, icloud, google calendar, etc. Unfortunately the new site doesn't provide such functionality AFAIK.

This project aims to fill that gap.

## ROADMAP

- [x] retrieve sitemap
- [x] walk through all urls
- [x] visit each url to fetch date / time
- [ ] visit each url to fetch otehr details
- [ ] save those details in a sqlite db
- [ ] generate an ical feed to disk
- [ ] deploy to gh-pages
- [ ] cronjob every hour w/ a github action

## update local sources for development

```shell
CURRENT_DATE=$(date "+%Y-%m-%d-%H%M")
curl https://www.burgerweeshuis.nl/ > src/index-${CURRENT_DATE}.html
curl https://www.burgerweeshuis.nl/sitemap.xml > src/sitemap-${CURRENT_DATE}.xml
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
