import matplotlib.pyplot as plt
import numpy as np
import os

# Параметры
a = 1.0
R = 4.0
N_0 = 100.0
b_values = [0.1, 0.2, 0.24, 0.4, 0.6, 2.0, 10.0]  # Значения b для тестирования

# Конфигурация для каждого b: (количество поколений, максимум по оси y)
b_configs = {
    0.1: {'generations': 50, 'y_max': 400},
    0.2: {'generations': 50, 'y_max': 400},
    0.24: {'generations': 300, 'y_max': 400},
    0.4: {'generations': 200, 'y_max': 600},
    0.6: {'generations': 200, 'y_max': 600},
    2.0: {'generations': 200, 'y_max': 600},
    10.0: {'generations': 200, 'y_max': 600}
}

# Функция для вычисления следующего размера популяции
def next_population(N, R, a, b):
    denominator = 1 + (a * N) ** b
    if denominator == 0:  # Предотвращение деления на ноль
        return 0
    return (N * R) / denominator

# Симуляция и построение графика для каждого b
for b in b_values:
    config = b_configs[b]
    generations = config['generations']
    y_max = config['y_max']

    # Симуляция популяции
    N = np.zeros(generations)
    N[0] = N_0
    for t in range(generations - 1):
        N[t + 1] = next_population(N[t], R, a, b)
        # Проверка на недопустимые значения
        if not np.isfinite(N[t + 1]):
            print(f"Предупреждение: Недопустимое значение популяции при b={b}, t={t+1}. Остановка симуляции.")
            N[t + 1:] = np.nan
            break

    # Проверка валидности данных
    if np.all(np.isnan(N)):
        print(f"Ошибка: Нет валидных данных для b={b}. Пропуск графика.")
        continue

    # Создание нового графика
    plt.figure(figsize=(8, 6))
    plt.plot(range(generations), N, label=f'b = {b}', color='blue')

    # Настройка графика
    plt.title(f'Динамика популяции для b = {b} (a=1, R=4, N_0=100)')
    plt.xlabel('Поколение (t)')
    plt.ylabel('Размер популяции (N_t)')
    plt.ylim(0, y_max)
    plt.legend()
    plt.grid(True)

    # Сохранение графика
    filename = f'population_dynamics_b_{b}.png'
    plt.savefig(filename)
    print(f"График сохранен как: {os.path.abspath(filename)}")

    # Отображение графика
    plt.show()

    # Закрытие графика
    plt.close()

print("Все симуляции и графики завершены.")