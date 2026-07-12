from file_utils import read_file, write_json
from analyzer import clean_text, count_words, get_top_words, get_word_statistics
from display import display_top_words, display_word_statistics, display_word_frequency


def main():
    try:
        text = read_file("input.txt")
    except FileNotFoundError:
        print("File not found")
        return

    text = clean_text(text)
    words, word_counts = count_words(text)
    total_words, unique_words = get_word_statistics(words, word_counts)
    limit = 5
    top_words = get_top_words(word_counts, limit)

    display_word_statistics(total_words, unique_words)
    display_word_frequency(word_counts)
    display_top_words(top_words, limit)

    data = {"total_words": total_words,
            "unique_words": unique_words,
            "top_words": top_words
            }
    write_json("report.json", data)


if __name__ == "__main__":
    main()
