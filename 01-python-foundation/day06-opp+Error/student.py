class Student:
    def __init__(self, name, age, score):
        self.name = name
        self.age = age
        self.score = score

    def __str__(self):
        return f"Student(name={self.name}, age={self.age}, score={self.score})"

    def introduce(self):
        print(f"My name is {self.name} and I am {self.age} years old")

    def is_passed(self):
        return self.score >=60


student1 = Student("Tom", 18, 90)
student2 = Student("Jerry", 19, 55)

student1.introduce()
student2.introduce()
print(student1.is_passed())
print(student2.is_passed())

print(student1)
print(student2)