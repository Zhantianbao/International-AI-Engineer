def get_text():
    text = input("Enter an English sentence: ")
    return text


def clean_text(text):
    text = text.lower()

    for symbol in [",", ".", "!", "?"]:
        text = text.replace(symbol, "")

    return text


def count_words(text):
    words = text.split()
    word_counts = {}

    for word in words:
        if word in word_counts:
            word_counts[word] += 1
        else:
            word_counts[word] = 1

    return words, word_counts


def get_word_statistics(words, word_counts):
    total_words = len(words)
    unique_words = len(word_counts)
    return total_words, unique_words


def get_top_words(word_counts, limit):
    sorted_word_counts = sorted(word_counts.items(), key=lambda item: item[1], reverse=True)

    top_words = sorted_word_counts[:limit]

    return top_words


def display_word_statistics(total_words, unique_words):
    print(f"Total words: {total_words}")
    print(f"Unique words: {unique_words}")


def display_word_frequency(word_counts):
    print("\nWord frequency:")
    for word, count in word_counts.items():
        print(f"{word}: {count}")


def display_top_words(top_words, limit):
    print(f"\nTop {limit} words:")
    for word, count in top_words:
        print(f"{word}: {count}")


def main():
    text = get_text()
    text = clean_text(text)
    words, word_counts = count_words(text)
    total_words, unique_words  = get_word_statistics(words, word_counts)
    top_words = get_top_words(word_counts, 5)

    display_word_statistics(total_words, unique_words)
    display_word_frequency(word_counts)
    display_top_words(top_words, 5)


if __name__ == "__main__":
    main()




#AI, AI. AI! Is AI useful?

