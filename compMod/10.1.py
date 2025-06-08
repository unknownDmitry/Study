import numpy as np
import matplotlib.pyplot as plt

# Функция интенсивности λ(t)
def lambda_t(t):
    if 0 <= t <= 30:
        return 0.6
    elif 30 < t <= 70:
        return 0.1
    elif 70 < t <= 100:
        return 0.5
    return 0

# Максимальная интенсивность
lambda_max = 0.6

# Моделирование с помощью метода прореживания
#np.random.seed(42)  # Для воспроизводимости
T = 100  # Длина отрезка
times = []
t = 0
while t < T:
    t += np.random.exponential(1 / lambda_max)  # Генерируем время следующего события
    if t > T:
        break
    u = np.random.uniform(0, lambda_max)  # Генерируем случайную величину для прореживания
    if u <= lambda_t(t):  # Принимаем событие с вероятностью λ(t)/λ_max
        times.append(t)

# Визуализация
plt.figure(figsize=(10, 6))

# События
plt.eventplot(times, orientation='horizontal', colors='black', lineoffsets=1, linelengths=0.5)

# График интенсивности (масштабируем для наглядности)
t_vals = np.linspace(0, 100, 1000)
lambda_vals = [lambda_t(t) for t in t_vals]
plt.plot(t_vals, [val * 2 for val in lambda_vals], 'r-', label='Интенсивность λ(t) (масштабированная)')

plt.title('Нестационарный пуассоновский поток')
plt.xlabel('Время')
plt.xlim(0, 100)
plt.yticks([0, 1], ['События', ''])
plt.ylabel('')
plt.legend()

plt.savefig('poisson_process.png')