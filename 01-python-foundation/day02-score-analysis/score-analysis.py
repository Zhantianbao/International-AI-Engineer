def get_scores():
    scores = {}

    while True:
        name = input("Enter student's name: ").strip()

        if name.lower() == "done":
            break

        if name == "":
            print("Name cannot be empty.")
            continue

        try:
            score = float(input("Enter student's score: "))
        except ValueError:
            print("Invalid input.txt. Please enter a numeric value.")
            continue

        if score < 0 or score > 100:
            print("Score must be between 0 and 100.")
            continue

        scores[name] = score

    return scores


def calculate_statistics(scores):
    average_score = sum(scores.values()) / len(scores)
    highest_score = max(scores.values())
    lowest_score = min(scores.values())

    return average_score, highest_score, lowest_score


def get_failed_students(scores):
    failed_students = {}
    for name, score in scores.items():
        if score < 60:
            failed_students[name] = score

    return failed_students


def get_ranking(scores):
    sorted_scores = sorted(scores.items(), key=lambda item: item[1], reverse=True)

    return sorted_scores


def display_statistics(average_score, highest_score, lowest_score):
    print(f"Average score: {average_score}")
    print(f"Highest score: {highest_score}")
    print(f"Lowest score: {lowest_score}")


def display_failed_students(failed_students):
    print("\nFailed students:")
    if len(failed_students) == 0:
        print("None")
    else:
        for name, score in failed_students.items():
            print(f"{name}: {score}")


def display_ranking(ranking):
    print("\nRanking:")
    for name, score in ranking:
        print(f"{name}: {score}")


def main():
    scores = get_scores()

    if len(scores) == 0:
        print("No students were entered")
    else:
        average_score, highest_score, lowest_score = calculate_statistics(scores)
        display_statistics(average_score, highest_score, lowest_score)

        failed_students = get_failed_students(scores)
        display_failed_students(failed_students)

        ranking = get_ranking(scores)
        display_ranking(ranking)


if __name__ == "__main__":
    main()

