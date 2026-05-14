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

# Install the Arial→Liberation Sans alias
COPY fonts/arial-alias.conf /etc/fonts/conf.d/30-arial-alias.conf

# Register any manually added fonts from fonts/ (e.g. real Arial TTFs)
COPY fonts/ /usr/share/fonts/custom/

RUN fc-cache -f
