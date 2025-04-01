defmodule Functional do
  use Application

  def start(_type, _args) do
    Functional.main()
    Supervisor.start_link([], strategy: :one_for_one)
  end

  def main do
    #500 words of Lorem ipsum for analysis.
    lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam eu purus luctus, lobortis velit vitae, finibus mauris. Mauris nec mi consequat, luctus orci ac, facilisis turpis. Morbi sed malesuada ipsum. Aenean posuere venenatis orci quis egestas. Nunc ac vulputate ante, pulvinar scelerisque ex. Mauris efficitur, mauris nec placerat commodo, quam est facilisis nisi, id porta elit est ut nisi. In sagittis nulla sit amet leo iaculis, et aliquam lacus dapibus. Maecenas semper tellus sed magna porta interdum. Integer gravida ac eros id venenatis. Curabitur nec elit ex. Interdum et malesuada fames ac ante ipsum primis in faucibus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc finibus lorem leo. Sed laoreet dapibus aliquam. Aliquam consectetur ipsum vitae magna scelerisque dapibus. Mauris ultricies tincidunt pretium. Nunc molestie mollis odio. Praesent suscipit mattis consectetur. Proin diam nisl, efficitur a laoreet sit amet, mollis malesuada risus. Cras et est ut libero varius cursus et nec felis. Quisque tincidunt aliquet ligula, vitae interdum velit efficitur quis. Sed porta eros at vulputate consequat. Nulla lacinia fermentum nisi quis imperdiet. Proin nec nibh tempus, dictum ex sed, vehicula sem. Morbi tristique arcu et tellus semper mollis. Donec interdum est a iaculis fringilla. Duis egestas tellus vel lectus laoreet, sed suscipit lorem fermentum. Suspendisse id nisl eu erat luctus ultrices ut sed est. Nulla sodales ante in varius vulputate. Nullam odio nulla, vulputate at euismod et, placerat ut purus. Nulla rutrum nisl vel ante laoreet, nec hendrerit urna suscipit. Praesent bibendum, lectus id tincidunt congue, velit mauris blandit lectus, vel interdum leo ex id diam. Nullam dignissim nulla at neque fermentum fermentum. In venenatis est ut odio accumsan, a rhoncus mauris ornare. Duis tellus risus, lacinia ac mauris id, fermentum convallis tellus. Phasellus ante orci, lacinia in tellus sit amet, luctus fermentum risus. Nulla nec hendrerit nisi. Nullam maximus ac velit vitae convallis. Quisque nec lectus ac diam sollicitudin lobortis in et eros. Nulla fermentum aliquet risus. Fusce luctus erat non augue vestibulum lobortis. Aliquam ac quam sem. Sed vitae turpis nec mauris laoreet iaculis in vel metus. Aenean scelerisque tincidunt ultricies. Suspendisse consequat pharetra fringilla. Vestibulum vel ipsum vitae quam molestie laoreet. In rhoncus, ante eget eleifend congue, nisl sem sodales felis, sed facilisis tellus purus eget erat. Ut ut dolor lacinia, cursus ipsum ut, convallis arcu. Sed consectetur iaculis felis, eget scelerisque sem rhoncus eget. Nunc egestas magna condimentum felis semper convallis. Fusce eu cursus odio. Vivamus posuere dictum sapien quis interdum. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Integer molestie turpis quis dolor gravida vehicula. Nunc scelerisque sapien bibendum nunc lacinia mattis. Maecenas non consequat magna, sed interdum nulla. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Suspendisse vel enim eu dui consectetur ultrices vel posuere nisi. Cras hendrerit, eros nec feugiat dapibus, mauris nisi maximus erat, a laoreet diam elit nec massa. Proin non elit dictum, egestas tellus quis, ullamcorper turpis. Sed in lorem imperdiet, commodo massa ut."
    countWordsAndSentences(lorem)
  end

  def countWordsAndSentences(text) do

    sentencesList = splitIntoSentences(text)
    numOfSentences = length(sentencesList)

    #IO.inspect({sentencesList, numOfSentences})
    IO.puts("There are " <> Integer.to_string(numOfSentences) <> " sentences. The longest one is: ")

    #Find and print the longest sentence

    #Analyze the word counts,
    totalWordCount = length(splitWords(text))
    IO.puts("There are " <> Integer.to_string(totalWordCount) <> " words in this text sample. The longest one is: ")

    #Find the longest word

    wordFreqMap = mapWords(text)
    uniqueWordCount = length(Map.keys(wordFreqMap))
    IO.puts("There are " <> Integer.to_string(uniqueWordCount) <> " unique words used. The most common are: ")
    IO.inspect(topTen(wordFreqMap))

    #I want to show the words and their count.

    IO.puts("I hope you found this analysis interesting!\n")
    :done
  end

  def splitIntoSentences(text, sentences \\ [], currentWord \\ <<>>) do
    remChars = byte_size(text)
    if remChars == 0 do
      sentences
    else
      <<currentChar::utf8, remText::binary>> = text

      {newSentences, word} = case currentChar do
        c when c in ~c".!?" ->
          newSentences = sentences ++ [currentWord]
          {newSentences, <<>>}
        _ ->
          {sentences, currentWord <> <<currentChar::8>> }
      end
      #IO.inspect({remText, newSentences, word}) #For debugging purposes
      splitIntoSentences(remText, newSentences, word)
    end
  end

  def splitWords(text, wordList \\ [], currentWord \\ <<>>, keepCase \\ false) do

    remChars = byte_size(text)

    if remChars == 0 do
      wordList
    else
      #Split the text, get the first char
      <<currentChar::utf8, remaining::binary>> = text
      case currentChar do
        c when c in ~c" .?!" ->
          #Skip when multiple non-word characters
          if (byte_size(currentWord) == 0) do
            splitWords(remaining, wordList, <<>>)
          #Add the word as a word if this is a character after a word character.
          else
            if keepCase do
              splitWords(remaining, wordList ++ [currentWord], <<>>)
            else
              splitWords(remaining, wordList ++ [String.downcase(currentWord)], <<>>)
            end
        end
        _ -> splitWords(remaining, wordList, currentWord <> <<currentChar::8>>)
      end
    end
  end

  def mapWords(text) do
    wordList = splitWords(text)
    mapWords(wordList, %{})
  end

  def mapWords(wordList, map) do
    if(length(wordList) < 1) do
      map
    else
      [item|list] = wordList
        case Map.fetch(map, item) do
          {:ok, count} ->
            count = count+1
            mapWords(list, Map.put(map, item, count))
          :error ->
            mapWords(list, Map.put(map, item, 1))
        end
    end
  end

  def topTen(wordCounts) do
    #Adds a value with negative count, so will always be less and can be replaced as the function runs
    wordCounts = Map.put(wordCounts, "base counts", -1)
    baseTopTen = ["base counts", "base counts", "base counts", "base counts", "base counts", "base counts", "base counts", "base counts", "base counts","base counts"]
    #IO.puts("Initialized baseTopTen")
    topTenList = topTen(wordCounts, Map.keys(wordCounts), 0, baseTopTen)
    topTenList = List.delete(topTenList, "base counts")
    topTenList = List.delete(topTenList, "base counts")
    topTenList = List.delete(topTenList, "base counts")
    topTenList = List.delete(topTenList, "base counts")
    topTenList = List.delete(topTenList, "base counts")
    topTenList = List.delete(topTenList, "base counts")
    topTenList = List.delete(topTenList, "base counts")
    topTenList = List.delete(topTenList, "base counts")
    topTenList = List.delete(topTenList, "base counts")
    List.delete(topTenList, "base counts")
  end

  def topTen(wordCounts, allKeys, currentKeyIndex, topTenList) do
    if currentKeyIndex == length(allKeys) do
      topTenList
    else
      topTenList = insertIntoOrderedList(topTenList, 9, Enum.at(allKeys, currentKeyIndex), wordCounts)
      topTen(wordCounts, allKeys, currentKeyIndex+1, topTenList)
    end

  end

  def insertIntoOrderedList(list, i, key, dict) do
    #if (i < 15) do
    #  IO.inspect(list)
    #  IO.inspect(i)
    #  IO.inspect(key)
    #end

    if (Map.get(dict, Enum.at(list, i)) > Map.get(dict, key) || key == nil) do
      #if we aren't going to add anything to the list
      if (i+1 >= length(list)) do
        list
      #this is if the current value is less, but it's already a little down the list so it needs to be inserted
      else
        originalKey = Enum.at(list, i+1)
        modifiedList = List.replace_at(list, i+1, key)
        insertIntoOrderedList(modifiedList, i+1, originalKey, dict)
      end
      #This is when the value is bigger, check for a bigger index
    else
      #if the things compared are the same, replace the element under the current element with the compared element
      if (Map.get(dict, Enum.at(list, i)) == Map.get(dict, key)) do
        originalKey = Enum.at(list, i+1)
        modifiedList = List.replace_at(list, i+1, key)
        insertIntoOrderedList(modifiedList, i+1, originalKey, dict)
      else
      #value > Enum.at(list, i]
        if (i == 0) do
          originalKey = Enum.at(list, i)
          modifiedList = List.replace_at(list, i, key)
          insertIntoOrderedList(modifiedList, i, originalKey, dict)

        else
          insertIntoOrderedList(list, i-1, key, dict)
        end
      end
    end
  end
end
