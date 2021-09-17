defmodule Chainz do
  def generate_sentences(input_file_path, sentence_count \\ 4) do
    text = File.read!(input_file_path)
    wordlist = build_wordlist(text)
    frequencies = build_frequencies(wordlist)

    1..sentence_count
    |> Enum.map(fn _ -> build_sentence(frequencies) end)
    |> Enum.join("\n")
  end

  defp build_sentence(frequencies) do
    words = frequencies |> Map.keys()
    starting_word = pick_random_starting_word(words)
    build_sentence(starting_word, [starting_word], frequencies)
  end

  defp build_sentence(current_word, words, frequencies) do
    if String.ends_with?(current_word, ".") do
      words |> Enum.join(" ")
    else
      next_word_frequencies = frequencies[current_word]
      next_word = weighted_random_word(next_word_frequencies)
      build_sentence(next_word, words ++ [next_word], frequencies)
    end
  end

  defp weighted_random_word(next_word_frequencies) do
    next_word_frequencies
    |> Enum.flat_map(fn {word, times} -> Enum.map(1..times, fn _ -> word end) end)
    |> Enum.random()
  end

  # pick words starting with capital letter and not ending with a period
  defp pick_random_starting_word(words) do
    words
    |> Enum.filter(fn word -> Regex.match?(~r/^[A-Z][a-z']+$/, word) end)
    |> Enum.random()
  end

  defp build_wordlist(text) do
    String.split(text, ~r/\s+/)
  end

  defp build_frequencies(wordlist) do
    wordlist
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(%{}, fn [current_word, next_word], acc ->
      acc
      |> Map.put_new_lazy(current_word, fn -> %{next_word => 1} end)
      |> update_in([current_word, next_word], fn
        nil -> 1
        val -> val + 1
      end)
    end)
  end
end
