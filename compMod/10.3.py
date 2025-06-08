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

# Максимальная интенсивность поступлений
alpha_max = 0.6

# Генерация поступлений
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

# Симуляция СМО с ожиданием
queue = []  # Очередь (накопитель)
server_busy = False
service_end = 0
events = []  # (время, длина очереди)
served = 0
current_queue = 0

for arrival in arrivals:
    # Проверяем завершение обслуживания до текущего поступления
    while server_busy and service_end <= arrival and service_end <= T:
        events.append((service_end, current_queue))
        if queue:
            next_arrival = queue.pop(0)
            current_queue -= 1
            service_duration = np.random.exponential(1 / mu_t(service_end))
            service_end = service_end + service_duration
            served += 1
            events.append((service_end, current_queue))
        else:
            server_busy = False

    # Новое поступление
    if not server_busy:
        service_duration = np.random.exponential(1 / mu_t(arrival))
        service_end = arrival + service_duration
        server_busy = True
        served += 1
        events.append((arrival, current_queue))
    else:
        queue.append(arrival)
        current_queue += 1
        events.append((arrival, current_queue))

# Завершение оставшихся обслуживаний
while server_busy and service_end <= T:
    events.append((service_end, current_queue))
    if queue:
        next_arrival = queue.pop(0)
        current_queue -= 1
        service_duration = np.random.exponential(1 / mu_t(service_end))
        service_end = service_end + service_duration
        served += 1
        events.append((service_end, current_queue))
    else:
        server_busy = False

# Визуализация
plt.figure(figsize=(10, 6))
for start, end in [(e[0], e[0] + 1e-5) for e in events if e[1] == 0]:
    plt.plot([start, end], [1, 1], 'b-', lw=2)  # Обслуживание (упрощённо)
plt.eventplot(arrivals, orientation='horizontal', colors='r', lineoffsets=0.5, linelengths=0.5)

# Длина очереди
times, lengths = zip(*events)
plt.step(times, [l + 2 for l in lengths], 'k-', where='post', label='Длина очереди')

plt.title('Одноканальная СМО с ожиданием')
plt.xlabel('Время')
plt.xlim(0, 100)
plt.yticks([0.5, 1, 2], ['Поступления', 'Обслуживание', ''])
plt.grid(True)

# Интенсивности
t_vals = np.linspace(0, 100, 1000)
alpha_vals = [alpha_t(t) for t in t_vals]
mu_vals = [mu_t(t) for t in t_vals]
plt.plot(t_vals, [val * 5 for val in alpha_vals], 'g-', label='α(t) (масштаб)')
plt.plot(t_vals, [val * 0.1 for val in mu_vals], 'm-', label='μ(t) (масштаб)')
plt.legend()

plt.savefig('queue_waiting_simulation.png')
print(f"Обслужено: {served}")
for time, length in events:
    print(f"Время: {time:.2f}, Длина очереди: {length}")