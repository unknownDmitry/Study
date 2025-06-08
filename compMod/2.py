import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

# Параметры модели
g = 9.81  # ускорение свободного падения
m = 125    # масса зонда
k2 = 1.11 # коэффициент сопротивления до раскрытия парашюта
k2_prime = 5  # коэффициент сопротивления после раскрытия парашюта
v0 = 200  # начальная скорость

# Система уравнений для движения вверх
def upward_motion(t, y):
    h, v = y
    dhdt = v
    dvdt = -g - (k2 / m) * v**2
    return [dhdt, dvdt]

# Система уравнений для движения вниз
def downward_motion(t, y):
    h, v = y
    dhdt = v
    dvdt = -g + (k2_prime / m) * v**2
    return [dhdt, dvdt]

# Событие для остановки интегрирования при достижении верхней точки (v = 0)
def event_max_height(t, y):
    return y[1]  # скорость v = y[1]
event_max_height.terminal = True  # остановить интегрирование
event_max_height.direction = -1   # событие при переходе скорости через ноль (сверху вниз)

# Событие для остановки интегрирования при достижении земли (h = 0)
def event_ground(t, y):
    return y[0]  # высота h = y[0]
event_ground.terminal = True  # остановить интегрирование
event_ground.direction = -1   # событие при переходе высоты через ноль (сверху вниз)

# Начальные условия
y0 = [0, v0]  # начальная высота и скорость

# Решение для движения вверх
t_span_up = (0, 1000)  # увеличенный временной интервал для движения вверх
sol_up = solve_ivp(upward_motion, t_span_up, y0, events=[event_max_height, event_ground], max_step=0.1)

# Проверяем, было ли зафиксировано событие верхней точки
if len(sol_up.t_events[0]) > 0:
    t_max_height = sol_up.t_events[0][0]  # время верхней точки
    h_max_height = sol_up.y_events[0][0][0]  # высота верхней точки
else:
    print("Зонд не достиг верхней точки. Возможно, скорость не успела снизиться до 0 на заданном временном промежутке.")
    t_max_height = sol_up.t[-1]  # последнее время интегрирования
    h_max_height = sol_up.y[0][-1]  # последняя высота

# Решение для движения вниз (если зонд достиг верхней точки)
if h_max_height > 0:
    y0_down = [h_max_height, 0]  # начальные условия для движения вниз
    t_span_down = (t_max_height, 2000)  # увеличенный временной интервал для движения вниз
    sol_down = solve_ivp(downward_motion, t_span_down, y0_down, events=event_ground, max_step=0.1)

    # Объединяем результаты
    t = np.concatenate((sol_up.t, sol_down.t))
    h = np.concatenate((sol_up.y[0], sol_down.y[0]))
    v = np.concatenate((sol_up.y[1], sol_down.y[1]))
else:
    # Если зонд не достиг верхней точки, используем только решение для движения вверх
    t = sol_up.t
    h = sol_up.y[0]
    v = sol_up.y[1]

# Убедимся, что высота не становится отрицательной
h[h < 0] = 0  # если высота меньше нуля, устанавливаем её в 0

# Построение графиков
plt.figure(figsize=(12, 6))

# График высоты от времени
plt.subplot(1, 2, 1)  # 1 строка, 2 столбца, первый график
plt.plot(t, h, label='Высота (м)')
if h_max_height > 0:
    plt.scatter(t_max_height, h_max_height, color='red', label='Верхняя точка')  # выделяем верхнюю точку
    plt.axvline(t_max_height, color='r', linestyle='--', alpha=0.5)  # вертикальная линия для верхней точки
plt.xlabel('Время (с)')
plt.ylabel('Высота (м)')
plt.title('Высота зонда от времени')
plt.legend()
plt.grid()

# График скорости от времени
plt.subplot(1, 2, 2)  # 1 строка, 2 столбца, второй график
plt.plot(t, v, label='Скорость (м/с)', color='orange')
if h_max_height > 0:
    plt.axvline(t_max_height, color='r', linestyle='--', alpha=0.5, label='Раскрытие парашюта')  # вертикальная линия
plt.xlabel('Время (с)')
plt.ylabel('Скорость (м/с)')
plt.title('Скорость зонда от времени')
plt.legend()
plt.grid()

plt.tight_layout()  # чтобы графики не перекрывались
plt.show()