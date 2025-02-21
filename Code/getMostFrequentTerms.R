#Pre-processing methods
removeURL <- function(x)
  gsub('http\\S+\\s*','', x)
removeHashTag <- function(x)
  gsub('#\\S+\\s*','', x)
removeReference <- function(x)
  gsub('@\\S+\\s*', '', x)

#get most frequent terms
getTermFrequencyList <- function(vectorSource) {
  myCorpus <- Corpus(vectorSource)
  myCorpus <- tm_map(myCorpus,
                     content_transformer(function(x)
                       iconv(x, to = 'UTF-8', sub = 'byte')),
                     mc.cores = 1)
  myCorpus <- tm_map(myCorpus, content_transformer(removeURL), lazy = T)
  myCorpus <- tm_map(myCorpus, content_transformer(removeReference), lazy = T)
  myCorpus <- tm_map(myCorpus, content_transformer(removeHashTag), lazy = T)
  
  myCorpus <- tm_map(myCorpus, removePunctuation, lazy = T)
  myCorpus <- tm_map(myCorpus, stripWhitespace, lazy = T)
  myCorpus <- tm_map(myCorpus, removeWords, stopwords("en"), lazy = T)
  
  myCorpus <- tm_map(myCorpus, content_transformer(tolower), lazy = T)
  
  dtm <- DocumentTermMatrix(myCorpus)
  
  dtm2 <- as.matrix(dtm)
  frequency <- colSums(dtm2)
  frequency <- sort(frequency, decreasing = TRUE)
  head(frequency)
  
  #top_frequency_terms <- frequency[1:500]
  top_frequency_terms <- subset(frequency, frequency >= 15)
  top_frequency_terms <- as.list(rownames(as.matrix(top_frequency_terms)))
  
  return (top_frequency_terms)
}

