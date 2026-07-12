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