defmodule Functional do
  use Application

  def start(_type, _args) do
    Functional.main()
    Supervisor.start_link([], strategy: :one_for_one)
  end

  def main do
    countWordsAndSentences("Tommy is my best friend. We enjoy hanging out. Is that a good reason to be best friends?")
  end

  def countWordsAndSentences(text) do

    sentencesList = splitIntoSentences(text)
    numOfSentences = length(sentencesList)

    IO.inspect({sentencesList, numOfSentences})

  end

  def splitIntoSentences(text) do
    splitIntoSentences(text, byte_size(text), [], <<>>)
  end

  def splitIntoSentences(text, remChars, sentences, currentWord) do
    if remChars == 0 do
      sentences
    else
      <<currentChar::utf8, remText::binary>> = text

      {newSentences, word} = case currentChar do
        ?. ->
          newSentences = sentences ++ [currentWord]   #Using the ?[char] compares the code point, which is what the byte thing did
          {newSentences, <<>>}
        ?? ->
          newSentences = sentences ++ [currentWord]
          {newSentences, <<>>}
        ?! ->
          newSentences = sentences ++ [currentWord]
          {newSentences, <<>>}
        _ ->
          {sentences, currentWord <> <<currentChar::8>> }
      end
      #IO.inspect({remText, remChars-1, newSentences, word}) #For debugging purposes
      splitIntoSentences(remText, remChars-1, newSentences, word)
    end
  end

  def splitWords(text) do
    splitWords(text, byte_size(text), [], <<>>)
  end

  def splitWords(text, remChars, wordList, currentWord) do
    if remChars == 0 do
      wordList
    else
      <<currentChar::int8, remaining::binary>> = text
      case currentChar do
        ?\s ->
          splitWords(remaining, remChars-1, wordList ++ [currentWord], <<>>)
      end
    end
  end
end
