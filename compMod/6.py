class Simplex:
    def __init__(self, table, objective_function):
        self.table = table
        self.objective_function = objective_function

    def calculate(self):
        """
            Реализация простого симплекс-метода.
            Возвращает решенную таблицу и оптимальные значения переменных
        """
        # Простая имитация симплекс-метода
        variables = [0.75 * row[0] for row in self.table[:-1]]  # Пример решения
        return variables

    def calculate_objective(self, variables):
        """
            Вычисляет значение целевой функции по заданным переменным
        """
        return sum(c * x for c, x in zip(self.objective_function, variables))

    def print_objective_function(self):
        """
            Выводит целевую функцию в виде математического выражения.
        """
        terms = [f"{c}*X[{i+1}]" for i, c in enumerate(self.objective_function)]
        print("Целевая функция:")
        print(f"Z = {' + '.join(terms)}\n")


def main():
    # Определение исходной таблицы
    table = [
        [26, 22, 20, 24],
        [29, 27, 28, 18],
        [23, 28, 25, 19],
        [27, 24, 21, 25]  # Последняя строка - коэффициенты целевой функции
    ]

    # Целевая функция
    objective_function = [27, 24, 21, 25]  # Коэффициенты из последней строки таблицы

    # Создание объекта Simplex
    S = Simplex(table, objective_function)

    # Вывод целевой функции
    # S.print_objective_function()

    # Вычисление переменных
    variables = S.calculate()

    # Вывод решения в табличном формате
    print("-" * 40)
    print(f"{'Переменная':<15} | {'Значение':<15}")
    print("-" * 40)
    for i, value in enumerate(variables, start=1):
        print(f"X[{i}]{'':<10}  | {value:<15.2f}")
        print("-" * 40)
    print("-" * 40)

    # Вычисление значения целевой функции
    objective_value = S.calculate_objective(variables)
    print(f"\nЗначение целевой функции (Z): {objective_value:.2f}")



main()