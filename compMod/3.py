import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp

# Константы
G = 6.67430e-11  # Гравитационная постоянная, м^3 кг^-1 с^-2
M_sun = 1.989e30  # Масса Солнца, кг
AU = 1.496e11  # Астрономическая единица, м
year = 365.265 * 24 * 3600  # Год в секундах

# Параметры орбиты
a = 1.0 * AU  # Большая полуось, м
e = 0.0167  # Эксцентриситет орбиты Земли

# Начальные условия
r0 = a * (1 - e)  # Начальное расстояние от Солнца, м
v0 = np.sqrt(G * M_sun * (2 / r0 - 1 / a))  # Начальная скорость, м/с

# Дифференциальные уравнения движения
def orbit_equations(t, y):
    r = np.sqrt(y[0]**2 + y[1]**2)
    dxdt = y[2]
    dydt = y[3]
    dvxdt = -G * M_sun * y[0] / r**3
    dvydt = -G * M_sun * y[1] / r**3
    return [dxdt, dydt, dvxdt, dvydt]

# Начальные условия [x, y, vx, vy]
y0 = [r0, 0, 0, v0]

# Время интегрирования (один год)
t_span = (0, year)
t_eval = np.linspace(0, year, 10000)  # Увеличиваем количество точек

# Решение системы дифференциальных уравнений
sol = solve_ivp(orbit_equations, t_span, y0, t_eval=t_eval, method='DOP853', max_step=year/1000)

# Извлечение результатов и перевод в а.е.
x = sol.y[0] / AU  # Переводим x из метров в а.е.
y = sol.y[1] / AU  # Переводим y из метров в а.е.

# Построение орбиты
plt.figure(figsize=(8, 8))
plt.plot(x, y, label="Орбита планеты")
plt.plot(0, 0, 'yo', label="Солнце")
plt.xlabel("x (а.е.)")
plt.ylabel("y (а.е.)")
plt.title("Движение планеты по орбите")
plt.legend()
plt.grid()
plt.axis('equal')
plt.show()

# Проверка третьего закона Кеплера
a_meters = a  # Большая полуось в метрах
T = year  # Период в секундах (один год, как задано в t_span)
T_years = T / year  # Период в годах
a_AU = a_meters / AU  # Большая полуось в астрономических единицах

# Вычисление T^2 / a^3
kepler_ratio = (T_years**2) / (a_AU**3)
print(f"T^2 / a^3 = {kepler_ratio:.6f} (должно быть близко к 1 для выполнения закона Кеплера)")