import numpy as np
import matplotlib.pyplot as plt

N = 100  # Количество узлов по радиусу
R = 1.0  # Радиус шара
dr = R / N  # Шаг по радиусу
dt = 0.002  # шаг по времени - 0.003
a = 0.01  # Температуропроводность
T0 = 500.0  # Начальная температура шара
T1 = 20.0  # Температура окружающей среды

alpha_liquid = 30.0  # Коэффициент теплоотдачи для жидкости
alpha_gas = 2.0  # Коэффициент теплоотдачи для газа

time_steps_liquid = 5000  # Количество шагов для жидкости
time_steps_gas = 5000  # Увеличенное количество шагов для газа (продление)

# Инициализация температуры
T = np.full(N, T0)  # Начальная температура шара
T_new = np.copy(T)

# Массивы для хранения данных
surface_temp = []
center_temp = []

# Функция расчета температуры
def calculate_temperature(T, T_new, alpha):
    for i in range(1, N-1):
        r = i * dr
        if r == 0:
            continue  # Пропуск центра, чтобы избежать деления на ноль

        # Конечные разности
        d2T_dr2 = (T[i+1] - 2*T[i] + T[i-1]) / dr**2
        dT_dr = (T[i+1] - T[i-1]) / (2 * dr)

        # Уравнение теплопроводности
        T_new[i] = T[i] + a * dt * (d2T_dr2 + 2/r * dT_dr)

    # Граничные условия
    T_new[0] = T_new[1]  # Центр шара (симметрия)
    T_new[-1] = T_new[-2] - alpha * (T_new[-2] - T1) * dr  # Поверхность шара

    return T_new

# Этап 1: Охлаждение в жидкости
for t_step in range(time_steps_liquid):
    T_new = calculate_temperature(T, T_new, alpha_liquid)
    T = np.copy(T_new)
    surface_temp.append(T[-1])
    center_temp.append(T[0])

# Изменение коэффициента теплоотдачи при переходе в газ
alpha_liquid = alpha_gas

# Этап 2: Охлаждение в газе (продленный этап)
for t_step in range(time_steps_gas):
    T_new = calculate_temperature(T, T_new, alpha_gas)
    T = np.copy(T_new)
    surface_temp.append(T[-1])
    center_temp.append(T[0])

# Графики
times = np.arange(len(surface_temp)) * dt

# Создание двух графиков
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(8, 10))

# График температуры на поверхности
ax1.plot(times, surface_temp, label='Температура на поверхности', color='blue')
ax1.set_xlabel('Время')
ax1.set_ylabel('Температура')
ax1.set_title('Температура на поверхности шара')
ax1.legend()
ax1.grid(True)

# График температуры в центре
ax2.plot(times, center_temp, label='Температура в центре', color='red')
ax2.set_xlabel('Время')
ax2.set_ylabel('Температура')
ax2.set_title('Температура в центре шара')
ax2.legend()
ax2.grid(True)

# Отображение графиков
plt.tight_layout()
plt.show()