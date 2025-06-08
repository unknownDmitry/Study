import random
import math

def simulate_buffon_needle(num_trials, needle_length, line_distance):
    intersections = 0

    for _ in range(num_trials):
        # Центр иглы в [-line_distance/2, line_distance/2]
        y0 = random.uniform(-line_distance / 2, line_distance / 2)
        # Угол в [0, π]
        alpha = random.uniform(0, math.pi)
        # Координаты концов иглы
        y1 = y0 + (needle_length / 2) * math.sin(alpha)
        y2 = 2 * y0 - y1
        # Проверка пересечения
        if y1 * y2 < 0:
            intersections += 1

    p = intersections / num_trials if intersections > 0 else 1e-10
    return (2 * needle_length) / (p * line_distance)

# Настройки эксперимента
num_trials = 20000
needle_length = 1.0
line_distance = 2.0

# Запуск симуляции
estimated_pi = simulate_buffon_needle(num_trials, needle_length, line_distance)
print(f"Оценка числа π: {estimated_pi:.6f}")
print(f"Погрешность: {abs(estimated_pi - math.pi):.6f}")
