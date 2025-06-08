import numpy as np
import matplotlib.pyplot as plt

# Интенсивности переходов (lambda_ij)
lambda_matrix = {
    (0, 1): 0.5,  # S0 -> S1: поток на обработку
    (1, 0): 0.7,  # S1 -> S0: поток завершения обработки
    (0, 2): 0.2,  # S0 -> S2: поток на переналадку
    (2, 1): 0.4,  # S2 -> S1: поток возврата с переналадки
    (1, 3): 0.1,  # S1 -> S3: поток отказов
    (3, 0): 0.3   # S3 -> S0: поток восстановления
}

# Параметры визуализации
state_colors = {
    0: 'skyblue',    # S0: исправен, свободен
    1: 'limegreen',  # S1: исправен, занят
    2: 'gold',       # S2: исправен, переналадка
    3: 'salmon'      # S3: неисправен, ремонт
}
state_labels = {
    0: 'S0: Исправен, свободен',
    1: 'S1: Исправен, занят',
    2: 'S2: Исправен, переналадка',
    3: 'S3: Неисправен, ремонт'
}

# Временной интервал
T = 100
np.random.seed(42)

# Симуляция
current_state = 0  # Начальное состояние S0
t = 0
states = [current_state]
times = [t]

while t < T:
    # Суммарная интенсивность выхода из текущего состояния
    total_rate = sum(lambda_matrix.get((current_state, j), 0) for j in range(4))
    if total_rate == 0:
        break
    # Время до следующего события (экспоненциальное распределение)
    dt = np.random.exponential(1 / total_rate)
    t += dt
    if t > T:
        break
    # Выбор следующего состояния
    r = np.random.uniform(0, total_rate)
    cumulative = 0
    next_state = current_state
    for j in range(4):
        rate = lambda_matrix.get((current_state, j), 0)
        cumulative += rate
        if r <= cumulative:
            next_state = j
            break
    states.append(next_state)
    times.append(t)
    current_state = next_state

# Визуализация
plt.figure(figsize=(12, 6))
for i in range(len(times) - 1):
    plt.plot([times[i], times[i + 1]], [states[i], states[i]],
             lw=4, color=state_colors[states[i]],
             label=state_labels[states[i]] if states[i] not in [states[j] for j in range(i)] else "")
plt.xlabel('Время', fontsize=12)
plt.ylabel('Состояние', fontsize=12)
plt.title('Временная диаграмма работы станка', fontsize=14, pad=15)
plt.yticks(range(4), ['S0', 'S1', 'S2', 'S3'], fontsize=10)
plt.grid(True, linestyle='--', alpha=0.7)
plt.legend(loc='upper right', fontsize=10, title='Состояния', title_fontsize=12)
plt.xlim(0, T)
plt.ylim(-0.5, 3.5)
plt.tight_layout()
plt.savefig('markov_simulation.png')

# Вывод траектории
print("Траектория переходов:")
for t, s in zip(times, states):
    print(f"Время: {t:.2f}, Состояние: {state_labels[s]}")