use nlp
db.Lexiques.createIndex({ mot : 1 })
db.Lexiques.createIndex({ infinitif : 1 })
db.Synonymes.createIndex({ mot : 1 })
