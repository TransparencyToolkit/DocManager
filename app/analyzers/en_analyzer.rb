module ENAnalyzer
  def self.analyzerSettings
    # Settings
    return {
      index: {
        number_of_shards: 1,
        analysis: {
          filter: {
            english_stop: {
              type: 'stop',
              stopwords: '_english_'
            },
            english_stemmer: {
              type: 'stemmer',
              language: 'english'
            },
            english_possessive_stemmer: {
              type: 'stemmer',
              language: 'possessive_english'
            }
          },       
          analyzer: {
            custom_en_analyzer: {
            type: 'custom',
            tokenizer: 'standard',
            filter: [
                     "english_possessive_stemmer",
                     "lowercase",
                     "english_stop",
                     "english_stemmer",
                     "asciifolding"
                    ]
            },
          },
        },
      },
    }.freeze
  end
end
