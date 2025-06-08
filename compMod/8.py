import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

# Параметры модели
T_START = 300     # Начальный год наблюдения
T_END = 400       # Конец наблюдений
K_CRISIS = T_START+10   # Год начала кризиса
ALPHA_INITIAL = 0.1      # Исходный коэффициент рождаемости
ALPHA_FINAL = 0.11       # Финальный коэффициент рождаемости
K1_INITIAL = 0.25        # Исходная доля соцвыплат
K1_FINAL = 0.6           # Финальная доля соцвыплат
D = 0.08                 # Постоянный коэффициент смертности
RATE_CHANGE_ALPHA = (ALPHA_FINAL - ALPHA_INITIAL) / 20  # Скорость изменения альфа
RATE_CHANGE_K1 = (K1_FINAL - K1_INITIAL) / 20          # Скорость изменения k1

def model(t, y):
    """
    Дифференциальное уравнение численности населения
    """
    if t >= K_CRISIS:
        alpha_t = min(ALPHA_INITIAL + RATE_CHANGE_ALPHA * (t-K_CRISIS), ALPHA_FINAL)
        k1_t = min(K1_INITIAL + RATE_CHANGE_K1 * (t-K_CRISIS), K1_FINAL)
    else:
        alpha_t = ALPHA_INITIAL
        k1_t = K1_INITIAL

    return (alpha_t + k1_t)*y - D*y

# Решение системы методом Рунге-Кутта
solution = solve_ivp(model, [T_START, T_END], [1000], dense_output=True)

# Время
years = np.linspace(T_START, T_END, num=1000)
population_values = solution.sol(years)[0]

plt.figure(figsize=(10, 6))
plt.plot(years, population_values, label='Население')
plt.xlabel('Год')
plt.ylabel('Численность населения')
plt.title('Имитация восстановления численности населения после кризиса')
plt.legend()
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

# Параметры модели
T_START = 300     # Начальный год наблюдения
T_END = 400       # Конец наблюдений
K_CRISIS = T_START+10   # Год начала кризиса
ALPHA_INITIAL = 0.1      # Исходный коэффициент рождаемости
ALPHA_FINAL = 0.11       # Финальный коэффициент рождаемости
K1_INITIAL = 0.25        # Исходная доля соцвыплат
K1_FINAL = 0.6           # Финальная доля соцвыплат
D = 0.08                 # Постоянный коэффициент смертности
RATE_CHANGE_ALPHA = (ALPHA_FINAL - ALPHA_INITIAL) / 20  # Скорость изменения альфа
RATE_CHANGE_K1 = (K1_FINAL - K1_INITIAL) / 20          # Скорость изменения k1

def model(t, y):
    """
    Дифференциальное уравнение численности населения
    """
    if t >= K_CRISIS:
        alpha_t = min(ALPHA_INITIAL + RATE_CHANGE_ALPHA * (t-K_CRISIS), ALPHA_FINAL)
        k1_t = min(K1_INITIAL + RATE_CHANGE_K1 * (t-K_CRISIS), K1_FINAL)
    else:
        alpha_t = ALPHA_INITIAL
        k1_t = K1_INITIAL

    return (alpha_t + k1_t)*y - D*y

# Решение системы методом Рунге-Кутта
solution = solve_ivp(model, [T_START, T_END], [1000], dense_output=True)

# Время
years = np.linspace(T_START, T_END, num=1000)
population_values = solution.sol(years)[0]

plt.figure(figsize=(10, 6))
plt.plot(years, population_values, label='Население')
plt.xlabel('Год')
plt.ylabel('Численность населения')
plt.title('Имитация восстановления численности населения после кризиса')
plt.legend()
plt.grid(True)
plt.show()