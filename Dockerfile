FROM pandoc/extra:latest

# pandoc/extra is Alpine-based.
#
# Liberation Sans is metric-identical to Arial (same widths/spacing, free, in Alpine repos).
# A fontconfig alias maps "Arial" → Liberation Sans automatically, so mainfont: Arial in
# shared-meta.yaml works out of the box.
#
# To use real Arial instead: drop Arial.ttf, Arial-Bold.ttf, Arial-Italic.ttf,
# Arial-BoldItalic.ttf into fonts/ and run `docker compose build`. The alias steps
# aside when the real font is present.

RUN apk add --no-cache fontconfig font-liberation

# Extra TeX packages not bundled in pandoc/extra.
RUN tlmgr install ragged2e

# Mermaid diagram support: system Chromium + mermaid-cli (mmdc).
# PUPPETEER_SKIP_CHROMIUM_DOWNLOAD tells mmdc's bundled Puppeteer not to
# download a second Chromium — we point it at the system one instead.
RUN apk add --no-cache chromium nodejs npm
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
RUN npm install -g @mermaid-js/mermaid-cli
RUN printf '{"args":["--no-sandbox","--disable-setuid-sandbox"],"executablePath":"/usr/bin/chromium-browser"}\n' \
    > /etc/mmdc-puppeteer.json

# Install the Arial→Liberation Sans alias
COPY fonts/arial-alias.conf /etc/fonts/conf.d/30-arial-alias.conf

# Register any manually added fonts from fonts/ (e.g. real Arial TTFs)
COPY fonts/ /usr/share/fonts/custom/

RUN fc-cache -f
