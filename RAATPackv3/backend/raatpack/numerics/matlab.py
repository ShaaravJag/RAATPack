"""
MATLAB-compatibility numerics.

Every function here reproduces the *behaviour* of the MATLAB call the v2 kernels used,
including the quirks that matter for numerical parity (verified against the v2 demo reports).
Keep this module free of any test-specific logic — it is shared by all ten equation files.
"""
from __future__ import annotations

import math
from typing import Callable, Optional, Sequence, Tuple

import numpy as np
from scipy import optimize

Array = np.ndarray

# ---------------------------------------------------------------------------
# Polynomials
# ---------------------------------------------------------------------------

def polyfit(x: Sequence[float], y: Sequence[float], deg: int) -> Array:
    """MATLAB polyfit(x,y,n) -> coefficients, highest power first.

    numpy.polyfit column-scales the Vandermonde matrix; verified to reproduce v2's
    Hamburg results (SIP to the digit) on data conditioned at ~1e30, where an unscaled
    least-squares solve does not. Do not replace with a hand-rolled solve.
    """
    with np.errstate(all="ignore"):
        return np.polyfit(np.asarray(x, float), np.asarray(y, float), deg)


def polyval(p: Sequence[float], x) -> Array:
    return np.polyval(np.asarray(p, float), x)


def polyder(p: Sequence[float]) -> Array:
    return np.polyder(np.asarray(p, float))


def roots(p: Sequence[float]) -> Array:
    return np.roots(np.asarray(p, float))


def real_roots_matlab(r: Array) -> Array:
    """Emulate the v2 idiom  `if isreal(r(i)) keep else 0`.

    MATLAB simplifies an indexed element with an exactly-zero imaginary part back to a
    real scalar, so `isreal` is true for real roots and false for genuinely complex ones.
    LAPACK returns real eigenvalues of a real companion matrix with imag == 0.0 exactly,
    so the exact-zero test reproduces MATLAB's selection.
    """
    r = np.asarray(r)
    out = np.where(np.imag(r) == 0.0, np.real(r), 0.0)
    return out.astype(float)


# ---------------------------------------------------------------------------
# Regression
# ---------------------------------------------------------------------------

def fitlm_slope_intercept(x: Sequence[float], y: Sequence[float]) -> Tuple[float, float]:
    """MATLAB fitlm(x,y): Coefficients.Estimate(2)=slope, (1)=intercept (OLS)."""
    x = np.asarray(x, float)
    y = np.asarray(y, float)
    if x.size < 2:
        return float("nan"), float("nan")
    slope, intercept = np.polyfit(x, y, 1)
    return float(slope), float(intercept)


def rsquared_ordinary(x: Sequence[float], y: Sequence[float]) -> float:
    """fitlm(x,y).Rsquared.Ordinary for a simple linear model."""
    x = np.asarray(x, float)
    y = np.asarray(y, float)
    slope, intercept = np.polyfit(x, y, 1)
    yhat = slope * x + intercept
    ss_res = float(np.sum((y - yhat) ** 2))
    ss_tot = float(np.sum((y - y.mean()) ** 2))
    return 1.0 - ss_res / ss_tot if ss_tot > 0 else float("nan")


def rsq_from_polyfit(x: Sequence[float], y: Sequence[float], p: Sequence[float]) -> float:
    """The v2 idiom:  1 - SSresid / ((n-1)*var(y))  with var = sample variance."""
    x = np.asarray(x, float)
    y = np.asarray(y, float)
    yfit = np.polyval(p, x)
    ss_res = float(np.sum((y - yfit) ** 2))
    ss_tot = (len(y) - 1) * float(np.var(y, ddof=1)) if len(y) > 1 else 0.0
    return 1.0 - ss_res / ss_tot if ss_tot > 0 else float("nan")


# ---------------------------------------------------------------------------
# Integration, search
# ---------------------------------------------------------------------------

# numpy >= 2.0 renamed trapz -> trapezoid; support both so the engine runs on either.
_TRAPZ = getattr(np, "trapezoid", None) or np.trapz


def trapz(y: Sequence[float], x: Sequence[float]) -> float:
    """MATLAB trapz(x,y).  NB argument order here is (y, x) like numpy."""
    return float(_TRAPZ(np.asarray(y, float), np.asarray(x, float)))


def knnsearch(x: Sequence[float], q: float) -> int:
    """1-D knnsearch: index of the element of x nearest to q (first on ties)."""
    return int(np.argmin(np.abs(np.asarray(x, float) - q)))


def first_max_index(y: Sequence[float]) -> int:
    """Index of the first occurrence of max(y) — `find(y==max(y)); n1(1)`."""
    y = np.asarray(y, float)
    return int(np.argmax(y))


# ---------------------------------------------------------------------------
# Optimisation
# ---------------------------------------------------------------------------

def fminbnd(f: Callable[[float], float], a: float, b: float, xtol: float = 1e-8) -> float:
    """MATLAB fminbnd (Brent bounded minimisation)."""
    res = optimize.minimize_scalar(f, bounds=(a, b), method="bounded", options={"xatol": xtol})
    return float(res.x)


def fzero(f: Callable[[float], float], x0: float) -> float:
    """MATLAB fzero with a scalar start: expand a bracket around x0, then Brent.

    Reproduces MATLAB's bracket search (dx = x0/50, growing by sqrt(2), alternating sides).
    """
    fx = f(x0)
    if fx == 0:
        return float(x0)
    dx = x0 / 50.0 if x0 != 0 else 1.0 / 50.0
    a = b = x0
    fa = fb = fx
    for _ in range(200):
        dx *= math.sqrt(2.0)
        a = x0 - dx
        fa = f(a)
        if np.sign(fa) != np.sign(fx):
            return float(optimize.brentq(f, a, x0, xtol=1e-12, maxiter=500))
        b = x0 + dx
        fb = f(b)
        if np.sign(fb) != np.sign(fx):
            return float(optimize.brentq(f, x0, b, xtol=1e-12, maxiter=500))
    raise RuntimeError("fzero: could not bracket a root")


def fmincon_bounds(sse: Callable[[Array], float], x0: Sequence[float],
                   lb: Sequence[float], ub: Sequence[float]) -> Array:
    """fmincon(sse, x0, [],[],[],[], lb, ub) — bound-constrained SSE minimisation.

    v2 always calls this twice (warm restart from the first solution); callers do the
    same. Parameters with lb == ub are held fixed exactly.
    """
    x0 = np.asarray(x0, float)
    lb = np.asarray(lb, float)
    ub = np.asarray(ub, float)
    x0 = np.clip(x0, lb, ub)
    fixed = lb == ub
    free = ~fixed

    def wrapped(z):
        full = x0.copy()
        full[free] = z
        return float(sse(full))

    if not np.any(free):
        return x0
    bounds = [(float(l), float(u)) for l, u, fr in zip(lb, ub, free) if fr]
    best = None
    for method in ("L-BFGS-B", "SLSQP", "TNC"):
        try:
            res = optimize.minimize(wrapped, x0[free], method=method, bounds=bounds,
                                    options={"maxiter": 2000})
        except Exception:
            continue
        val = wrapped(res.x)
        if best is None or val < best[0]:
            best = (val, res.x)
    full = x0.copy()
    full[free] = best[1]
    return full


# ---------------------------------------------------------------------------
# Curve fitting (Curve Fitting Toolbox `fit`)
# ---------------------------------------------------------------------------

def fit_power1(x: Sequence[float], y: Sequence[float],
               lower: Tuple[float, float] = (-np.inf, -np.inf),
               upper: Tuple[float, float] = (np.inf, np.inf)) -> Tuple[float, float]:
    """fit(x, y, 'power1', fitoptions(...))  ->  (a, b) for  y = a * x^b.

    Start point mirrors MATLAB's power1 heuristic: a linear fit in log-log space.
    """
    x = np.asarray(x, float)
    y = np.asarray(y, float)
    m = (x > 0) & (y > 0)
    if m.sum() >= 2:
        b0, la0 = np.polyfit(np.log(x[m]), np.log(y[m]), 1)
        a0 = math.exp(la0)
    else:
        a0, b0 = float(y[0]), -2.0
    p0 = np.clip([a0, b0], lower, upper)
    f = lambda xx, a, b: a * np.power(xx, b)
    with np.errstate(all="ignore"):
        (a, b), _ = optimize.curve_fit(f, x, y, p0=p0, bounds=(lower, upper),
                                       maxfev=200000, method="trf")
    return float(a), float(b)


def fit_exp1_robust_lar(x: Sequence[float], y: Sequence[float],
                        max_iter: int = 50, tol: float = 1e-10) -> Tuple[float, float]:
    """fit(x, y, 'exp1', fitoptions('exp1','Robust','LAR'))  ->  (a, b) for y = a*exp(b*x).

    MATLAB's LAR robust option is iteratively re-weighted nonlinear least squares with
    weights w_i = 1/|r_i| (least absolute residuals). Start from the ordinary NLS fit.
    """
    x = np.asarray(x, float)
    y = np.asarray(y, float)
    m = y > 0
    b0, la0 = np.polyfit(x[m], np.log(y[m]), 1)
    a0 = math.exp(la0)
    f = lambda xx, a, b: a * np.exp(b * xx)
    with np.errstate(all="ignore"):
        (a, b), _ = optimize.curve_fit(f, x, y, p0=[a0, b0], maxfev=200000)
        prev = np.array([a, b])
        for _ in range(max_iter):
            r = y - f(x, a, b)
            w = 1.0 / np.maximum(np.abs(r), 1e-12)
            sigma = 1.0 / np.sqrt(w)            # curve_fit weights via sigma = 1/sqrt(w)
            (a, b), _ = optimize.curve_fit(f, x, y, p0=[a, b], sigma=sigma,
                                           absolute_sigma=False, maxfev=200000)
            cur = np.array([a, b])
            if np.all(np.abs(cur - prev) <= tol * np.maximum(1.0, np.abs(prev))):
                break
            prev = cur
        # polish to the true least-absolute-residual optimum (MATLAB's converged answer sits
        # within 0.03 % of this on the v2 demo data; the plain IRLS is on the other side of it)
        l1 = lambda pq: float(np.sum(np.abs(y - pq[0] * np.exp(pq[1] * x))))
        res = optimize.minimize(l1, [a, b], method="Nelder-Mead",
                                options={"xatol": 1e-12, "fatol": 1e-12, "maxiter": 20000})
        if res.fun <= l1([a, b]):
            a, b = res.x
    return float(a), float(b)


# ---------------------------------------------------------------------------
# Statistics with MATLAB / Excel semantics
# ---------------------------------------------------------------------------

def nanmean(a, axis=None):
    with np.errstate(all="ignore"):
        return np.nanmean(np.asarray(a, float), axis=axis)


def nanstd(a, axis=None):
    """MATLAB nanstd — sample std (N-1)."""
    with np.errstate(all="ignore"):
        return np.nanstd(np.asarray(a, float), axis=axis, ddof=1)


def excel_stats(values: Sequence[Optional[float]]) -> Tuple[Optional[float], Optional[float], Optional[float]]:
    """AVERAGE / STDEV / COV(%) exactly as the v2 report templates compute them:
    blanks ignored, sample standard deviation, COV = stdev/mean*100. Returns None
    where Excel would show #DIV/0!."""
    v = np.array([float(x) for x in values if x is not None and not (isinstance(x, float) and math.isnan(x))], float)
    if v.size == 0:
        return None, None, None
    mean = float(v.mean())
    std = float(v.std(ddof=1)) if v.size > 1 else None
    cov = (std / mean * 100.0) if (std is not None and mean != 0) else None
    return mean, std, cov
