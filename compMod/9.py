import random
import math
import matplotlib.pyplot as plt

def f(x):
    return x ** (2 * (1 / math.tan(x + 2) ) )

def MCint3(f, a, b, n):
    s = 0
    l_values = []
    k_values = []
    for k in range(1, n + 1):
        x = random.uniform(a, b)
        s += f(x)
        l = (float(b - a) / k) * s
        l_values.append(l)
        k_values.append(k)
    return k_values, l_values

a, b = 0.0, 0.4  # Интервал интегрирования
n = 100000

# Вычисление интеграла методом Монте-Карло
k_values, l_values = MCint3(f, a, b, n)

# Построение графика результатов
plt.figure(figsize=(10, 6))
plt.plot(k_values, l_values, label='Аппроксимация методом Монте-Карло')
plt.xlabel('Количество точек (k)')
plt.ylabel('Аппроксимация интеграла')
plt.title('Интегрирование методом Монте-Карло для f(x) = x ** (2 * (1 / math.tan(x + 2) ) )')
plt.legend()
plt.grid(True)
# Вывод приблизительного значения интеграла (последнее значение)
print(f"Примерное значение интеграла: {l_values[-1]:.4f}")
plt.show()