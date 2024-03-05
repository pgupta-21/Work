#!bin/bash
# use screen

kraken2-build --standard --threads 72 --db KRAKENDB
# error with downloading plasmid library so the command might quit. in that case, download the remaining libraries separately
# also can check https://benlangmead.github.io/aws-indexes/k2 to download various libraries

kraken2-build --download-library human --db KRAKENDB
# and then continue with
kraken2-build --standard --threads 72 --db KRAKENDB

# using kraken to generate a report
kraken2 --db ../KRAKENDB/ --output kraken_71.txt --report M71.report.txt M071NU_GT600.fasta
