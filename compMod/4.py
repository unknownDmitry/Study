import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp

# Параметры системы
g = 9.81  # ускорение свободного падения
l = 1.0   # длина нити подвеса
omega = np.sqrt(g / l)  # частота собственных колебаний

# Начальные условия
theta0 = 0.1  # начальный угол отклонения (в радианах)
x0 = 0.0      # начальная угловая скорость

# Функция для системы дифференциальных уравнений
def pendulum(t, y, eta):
    theta, x = y
    dtheta_dt = x
    dx_dt = -2 * eta * x - omega**2 * theta  # замена sin(theta) на theta
    return [dtheta_dt, dx_dt]

# Время интегрирования
t_span = (0, 20)  # интервал времени
t_eval = np.linspace(t_span[0], t_span[1], 1000)  # точки для вывода результатов

# Коэффициенты трения для исследования
eta_values = [0.1, 1.0, 2.0, omega]  # различные значения коэффициента трения

# Построение графиков для разных значений eta
plt.figure(figsize=(10, 6))

for eta in eta_values:
    sol = solve_ivp(pendulum, t_span, [theta0, x0], args=(eta,), t_eval=t_eval, method='RK45')
    plt.plot(sol.t, sol.y[0], label=f'η = {eta}')

plt.title('Влияние трения на малые колебания маятника')
plt.xlabel('Время, t')
plt.ylabel('Угол отклонения, θ')
plt.legend()
plt.grid(True)
plt.show()

# Поиск критического значения eta
# Критическое значение eta, при котором движение становится апериодическим
eta_critical = omega  # критическое значение коэффициента трения

print(f"Критическое значение коэффициента трения η* = {eta_critical}")