import numpy as np
import matplotlib.pyplot as plt

# Интенсивности
def alpha_t(t):
    if 0 <= t <= 30:
        return 0.6
    elif 30 < t <= 70:
        return 0.1
    elif 70 < t <= 100:
        return 0.5
    return 0

def mu_t(t):
    if 0 <= t <= 50:
        return 0.8 * t
    elif 50 < t <= 100:
        return 0.01
    return 0

# Максимальные интенсивности
alpha_max = 0.6
mu_max = 40.0  # Максимум mu_t = 0.8 * 50

# Генерация событий
np.random.seed(42)
T = 100
arrivals = []
t = 0
while t < T:
    t += np.random.exponential(1 / alpha_max)
    if t > T:
        break
    if np.random.uniform(0, alpha_max) <= alpha_t(t):
        arrivals.append(t)

# Симуляция СМО
server_busy = False
service_end = 0
served = 0
rejected = 0
events = []

for arrival in arrivals:
    if not server_busy or arrival >= service_end:
        service_duration = np.random.exponential(1 / mu_t(arrival))
        service_end = arrival + service_duration
        server_busy = True
        served += 1
        events.append((arrival, service_end))
    else:
        rejected += 1
    if service_end >= T:
        server_busy = False

# Визуализация
plt.figure(figsize=(10, 6))
for start, end in events:
    plt.plot([start, end], [1, 1], 'b-', lw=2)  # Обслуживание
plt.eventplot(arrivals, orientation='horizontal', colors='r', lineoffsets=0.5, linelengths=0.5)  # Поступления
plt.title('Одноканальная СМО с отказами')
plt.xlabel('Время')
plt.xlim(0, 100)
plt.yticks([0.5, 1], ['Поступления', 'Обслуживание'])
plt.grid(True)

# Графики интенсивностей (масштабируем для наглядности)
t_vals = np.linspace(0, 100, 1000)
alpha_vals = [alpha_t(t) for t in t_vals]
mu_vals = [mu_t(t) for t in t_vals]
plt.plot(t_vals, [val * 5 for val in alpha_vals], 'g-', label='α(t) (масштаб)')
plt.plot(t_vals, [val * 0.1 for val in mu_vals], 'm-', label='μ(t) (масштаб)')
plt.legend()

plt.savefig('queue_simulation.png')
print(f"Обслужено: {served}, Отказано: {rejected}")