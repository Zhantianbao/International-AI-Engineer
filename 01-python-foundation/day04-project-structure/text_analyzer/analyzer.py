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