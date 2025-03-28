defmodule Functional do
  use Application

  def start(_type, _args) do
    Functional.main()
    Supervisor.start_link([], strategy: :one_for_one)
  end

  def main do
    splitIntoSentences("Tommy is my best friend")
  end

  def splitIntoSentences(text) do
    splitIntoSentences(text, String.length(text), [], "")
  end

  def splitIntoSentences(text, remChars, sentences, currentWord) do
    if remChars == 0 do
      sentences
    else
      case String.at(text, 0) do
        "." -> ^sentences = sentences ++ [currentWord]
        "?" -> ^sentences = sentences ++ [currentWord]
        "!" -> ^sentences = sentences ++ [currentWord]
        _ -> ^currentWord = String.at(text, 0) + currentWord
      end
      text = String.slice(text, 1..String.length(text))
      splitIntoSentences(text, remChars-1, sentences, currentWord)
    end
  end

  def countSentences(text) do
    length(String.split(text, ~r{[?.!]}))-1
  end

  def countWords(text) do
    IO.inspect(String.split(text, ~r{[\W]+}))-1
  end
end
