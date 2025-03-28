defmodule Functional do
  use Application

  def start(_type, _args) do
    Functional.main()
    Supervisor.start_link([], strategy: :one_for_one)
  end

  def main do
    lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam eu purus luctus, lobortis velit vitae, finibus mauris. Mauris nec mi consequat, luctus orci ac, facilisis turpis. Morbi sed malesuada ipsum. Aenean posuere venenatis orci quis egestas. Nunc ac vulputate ante, pulvinar scelerisque ex. Mauris efficitur, mauris nec placerat commodo, quam est facilisis nisi, id porta elit est ut nisi. In sagittis nulla sit amet leo iaculis, et aliquam lacus dapibus. Maecenas semper tellus sed magna porta interdum. Integer gravida ac eros id venenatis. Curabitur nec elit ex. Interdum et malesuada fames ac ante ipsum primis in faucibus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc finibus lorem leo. Sed laoreet dapibus aliquam. Aliquam consectetur ipsum vitae magna scelerisque dapibus. Mauris ultricies tincidunt pretium. Nunc molestie mollis odio. Praesent suscipit mattis consectetur. Proin diam nisl, efficitur a laoreet sit amet, mollis malesuada risus. Cras et est ut libero varius cursus et nec felis. Quisque tincidunt aliquet ligula, vitae interdum velit efficitur quis. Sed porta eros at vulputate consequat. Nulla lacinia fermentum nisi quis imperdiet. Proin nec nibh tempus, dictum ex sed, vehicula sem. Morbi tristique arcu et tellus semper mollis. Donec interdum est a iaculis fringilla. Duis egestas tellus vel lectus laoreet, sed suscipit lorem fermentum. Suspendisse id nisl eu erat luctus ultrices ut sed est. Nulla sodales ante in varius vulputate. Nullam odio nulla, vulputate at euismod et, placerat ut purus. Nulla rutrum nisl vel ante laoreet, nec hendrerit urna suscipit. Praesent bibendum, lectus id tincidunt congue, velit mauris blandit lectus, vel interdum leo ex id diam. Nullam dignissim nulla at neque fermentum fermentum. In venenatis est ut odio accumsan, a rhoncus mauris ornare. Duis tellus risus, lacinia ac mauris id, fermentum convallis tellus. Phasellus ante orci, lacinia in tellus sit amet, luctus fermentum risus. Nulla nec hendrerit nisi. Nullam maximus ac velit vitae convallis. Quisque nec lectus ac diam sollicitudin lobortis in et eros. Nulla fermentum aliquet risus. Fusce luctus erat non augue vestibulum lobortis. Aliquam ac quam sem. Sed vitae turpis nec mauris laoreet iaculis in vel metus. Aenean scelerisque tincidunt ultricies. Suspendisse consequat pharetra fringilla. Vestibulum vel ipsum vitae quam molestie laoreet. In rhoncus, ante eget eleifend congue, nisl sem sodales felis, sed facilisis tellus purus eget erat. Ut ut dolor lacinia, cursus ipsum ut, convallis arcu. Sed consectetur iaculis felis, eget scelerisque sem rhoncus eget. Nunc egestas magna condimentum felis semper convallis. Fusce eu cursus odio. Vivamus posuere dictum sapien quis interdum. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Integer molestie turpis quis dolor gravida vehicula. Nunc scelerisque sapien bibendum nunc lacinia mattis. Maecenas non consequat magna, sed interdum nulla. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Suspendisse vel enim eu dui consectetur ultrices vel posuere nisi. Cras hendrerit, eros nec feugiat dapibus, mauris nisi maximus erat, a laoreet diam elit nec massa. Proin non elit dictum, egestas tellus quis, ullamcorper turpis. Sed in lorem imperdiet, commodo massa ut."
    countWordsAndSentences(lorem)
  end

  def countWordsAndSentences(text) do

    sentencesList = splitIntoSentences(text)
    numOfSentences = length(sentencesList)

    IO.inspect({sentencesList, numOfSentences})
    IO.puts("")

    wordList = splitWords(text)
    IO.inspect(wordList)
    rankWordFreq(text)


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
        c when c in ~c".!?" ->
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
      <<currentChar::utf8, remaining::binary>> = text
      case currentChar do
        c when c in ~c" .?!" ->
          if (byte_size(currentWord) == 0) do
            splitWords(remaining, remChars-1, wordList, <<>>)
          else
            splitWords(remaining, remChars-1, wordList ++ [currentWord], <<>>)
        end
        _ -> splitWords(remaining, remChars-1, wordList, currentWord <> <<currentChar::8>>)
      end
    end
  end

  def rankWordFreq(text) do
    #I want to do a for loop here for each item in wordList ahhhhhhh
    wordCounts = mapWords(splitWords(text))
    IO.inspect(wordCounts)
    topTen()

  end

  def mapWords(wordList) do
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
          _ -> wordList
        end
    end
  end

  def topTen(wordCount) do
    topTen(wordCount, Map.keys(wordCount), {})
  end

  def topTen(wordCount, allKeys, currentKey, topTenList) do
    if currentKey == length(allKeys) do
      topTenList
    else

    end

  end

  def insertIntoOrderedList(list, i, value) do
    if (list[i] > value) do
      #if we aren't going to add anything to the list
      if (length(list) == i+1) do
        list
      # we need to add stuff into the list, below the current value
      else

      end
    else
      if (list[i] < value ) do
        insertIntoOrderedList(list, i-1, value)
      else
        #The case when they're equal, or
      end
    end
  end
end
