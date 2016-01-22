#/bin/bash

mongoimport --db nlp --collection Lexiques --type csv --headerline --file ../lib/core/lexique/Lexique380.csv
mongoimport --db nlp --collection Synonymes --type csv --headerline --file ../lib/core/lexique/thes_fr.csv
mongo < mongodb_lexiques.js
