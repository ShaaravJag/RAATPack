"""
Dynamic Modulus — AASHTO T342 / R62 / R84, NCHRP 1-37A. Port of DynamicModulus.m.

Pieces (all reproduce v2 verbatim, including its temperature-unit conventions):
  * emax_hirsch()               — E*max from volumetrics (Hirsch)
  * a_vts_from_*()              — binder A / VTS from DSR, penetration, rotational viscometer, PG lookup
  * build_average_table()       — align frequencies across up to 3 replicates x 3 temperatures, average
  * witczak_prediction()        — Witczak 1-37A predicted E* at the measured (T, f) pairs
  * hirsch_from_gstar()         — Hirsch E* from binder G*
  * fit_ea / fit_vts / fit_free — sigmoidal master curves with Arrhenius, VTS or free shifting
"""
from __future__ import annotations

import math
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Sequence

import numpy as np

from ..numerics import matlab as ml
from ..io.ampt import AMPTSummary, MPA_TO_PSI

# ---- constants --------------------------------------------------------------
HIRSCH_E_AGG_PSI = 4200000.0
HIRSCH_G_BINDER_PSI = 435000.0      # for E*max (binder at its glassy limit)
HIRSCH_PC_A, HIRSCH_PC_B, HIRSCH_PC_EXP = 20.0, 650.0, 0.58
DSR_VISC_EXP = 4.8628               # η = 1000·(G*/10)·(1/sin δ)^4.8628   (cP from G* in Pa)
PEN_A, PEN_B, PEN_C = 10.5012, 2.2601, 0.00389
EA_CONST = 19.14714                 # R (J/mol·K) x ln(10) — Arrhenius shift constant
VISCOSITY_CAP = 2.7e12
REDUCED_GRID = np.array([-10, -9, -8, -7, -6, -4, -3, -2, -1, 0, 2, 3, 4, 5, 6, 8, 9, 10], float)
WITCZAK = dict(d0=-1.249937, d200=0.029232, d200sq=-0.001767, d4=-0.002841, dva=-0.05809, dvb=-0.802208,
               a0=3.871977, a4=-0.0021, a38=0.003958, a38sq=-0.000017, a34=0.00547,
               b0=-0.603313, b1=-0.313351, c=-0.393532, scale=1e5)
PHASE_POLY_ORDER = 5

# fit set-ups (x0, lb, ub) exactly as v2
FIT_EA = dict(x0=[4, -1, -0.5, 2.0e5], lb=[-50, -50, -50, 2e5], ub=[50, 0, 0, 2e5])
FIT_HIRSCH_EA = dict(x0=[4, -1, -0.5, 2.0e5], lb=[-5, -5, -5, 2e5], ub=[5, 0, 0, 2e5])
FIT_VTS = dict(x0=[2.7550, -1.3202, 0.4716, 1.0764], lb=[0, -5, 0, 0], ub=[5, 0, 5, 5])
FIT_WITCZAK = dict(x0=[3.7935, -1.0528, 0.4188, 1.2440], lb=[0, -5, 0, 0], ub=[5, 0, 5, 5])
FIT_FREE = dict(x0=[3.5, 1, 0.5, 2, -2.5], lb=[-50, -50, 0, 0, -5], ub=[50, 0, 50, 5, 0])
FREE_TEMP_GROUP_TOL_F = 5.0

PG_TABLE = {
    "PG 46-34": (11.5040, -3.9010), "PG 46-40": (10.1010, -3.3930), "PG 46-46": (8.7550, -2.9050),
    "PG 52-10": (13.3860, -4.5700), "PG 52-16": (13.3050, -4.5410), "PG 52-22": (12.7550, -4.3420),
    "PG 52-28": (11.8400, -4.0120), "PG 52-34": (10.7070, -3.6020), "PG 52-40": (9.4960, -3.1640),
    "PG 52-46": (8.3100, -2.7360), "PG 58-10": (12.3160, -4.1720), "PG 58-16": (12.2480, -4.1470),
    "PG 58-22": (11.7870, -3.9810), "PG 58-28": (11.0100, -3.7010), "PG 58-34": (10.0350, -3.3500),
    "PG 58-40": (8.9760, -2.9680), "PG 64-10": (11.4320, -3.8420), "PG 64-16": (11.3750, -3.8220),
    "PG 64-22": (10.9800, -3.6800), "PG 64-28": (10.3120, -3.4400), "PG 64-34": (9.4610, -3.1340),
    "PG 64-40": (8.5240, -2.7980), "PG 70-10": (10.6900, -3.5660), "PG 70-16": (10.6410, -3.5480),
    "PG 70-22": (10.2990, -3.4260), "PG 70-28": (9.7150, -3.2170), "PG 70-34": (8.9650, -2.9480),
    "PG 70-40": (8.1290, -2.6480), "PG 76-10": (10.0590, -3.3310), "PG 76-16": (10.0150, -3.3150),
    "PG 76-22": (9.7150, -3.2080), "PG 76-28": (9.2000, -3.0240), "PG 76-34": (8.5320, -2.7850),
    "PG 82-10": (9.5140, -3.1280), "PG 82-16": (9.4750, -3.1140), "PG 82-22": (9.2090, -3.0190),
    "PG 82-28": (8.7500, -2.8560), "PG 82-34": (8.1510, -2.6420),
    "AC-2.5": (11.5167, -3.8900), "AC-5": (11.2614, -3.7914), "AC-10": (11.0134, -3.6954),
    "AC-20": (10.7709, -3.6017), "AC-3": (10.6316, -3.5480), "AC-40": (10.5338, -3.5104),
    "PEN 40-50": (10.5254, -3.5047), "PEN 60-70": (10.6508, -3.5537), "PEN 85-100": (11.8232, -3.6210),
    "PEN 120-150": (11.0897, -3.7252), "PEN 200-300": (11.8107, -4.0068),
}

CURVE_NAMES = {
    "ea": "AMPT (EA Shifting)", "vts": "VTS Shifting", "free": "No Constraints Shifting",
    "witczak": "Witczak Prediction Equation", "hirsch_vts": "Hirsch Model VT Shifting",
    "hirsch_ea": "Hirsch Model EA Shifting",
}
CURVE_TITLES = {
    "ea": "EA Shifting Master Curve", "vts": "VTS Shifting Master Curve",
    "free": "No Constraints Shifting Master Curve", "witczak": "Witczak Shifting Master Curve",
    "hirsch_vts": "Hirsch Model VTS Shifting Master Curve", "hirsch_ea": "Hirsch Model EA Shifting Master Curve",
}


# ---------------------------------------------------------------------------
# Volumetrics / E*max
# ---------------------------------------------------------------------------

@dataclass
class Volumetrics:
    Gmm: float
    Gsb: float
    air_voids: float
    ac_pct: float
    Gmb: float = 0.0
    VMA: float = 0.0
    VFA: float = 0.0
    EMAX: float = 0.0


def emax_hirsch(Gmm: float, Gsb: float, AV: float, AC: float) -> Volumetrics:
    Gmb = Gmm - (AV / 100.0) * Gmm
    VMA = 100.0 - ((Gmb * (100.0 - AC)) / Gsb)
    VFA = (VMA - AV) / VMA * 100.0
    k = HIRSCH_G_BINDER_PSI * VFA / VMA
    Pc = ((HIRSCH_PC_A + k) ** HIRSCH_PC_EXP) / (HIRSCH_PC_B + k ** HIRSCH_PC_EXP)
    EMAX = (Pc * (HIRSCH_E_AGG_PSI * (1 - VMA / 100.0) + HIRSCH_G_BINDER_PSI * (VFA * VMA / 10000.0))
            + (1 - Pc) / ((1 - VMA / 100.0) / HIRSCH_E_AGG_PSI + VMA / (HIRSCH_G_BINDER_PSI * VFA)))
    return Volumetrics(Gmm, Gsb, AV, AC, float(Gmb), float(VMA), float(VFA), float(EMAX))


# ---------------------------------------------------------------------------
# Binder A / VTS
# ---------------------------------------------------------------------------

@dataclass
class BinderFit:
    A: float
    VTS: float
    rsq: Optional[float]
    source: str
    log_temp: List[float] = field(default_factory=list)
    loglog_visc: List[float] = field(default_factory=list)


def _fit_a_vts(log_temp: np.ndarray, loglog_visc: np.ndarray, source: str) -> BinderFit:
    p = ml.polyfit(log_temp, loglog_visc, 1)
    VTS, A = float(p[0]), float(p[1])
    rsq = ml.rsq_from_polyfit(log_temp, loglog_visc, p)
    return BinderFit(A, VTS, rsq, source, log_temp.tolist(), loglog_visc.tolist())


def a_vts_from_dsr(temp_c: Sequence[float], g_star: Sequence[float], delta_deg: Sequence[float]) -> BinderFit:
    T = np.asarray(temp_c, float)
    G = np.asarray(g_star, float)
    d = np.asarray(delta_deg, float)
    T_R = 1.8 * T + 491.67                                  # v2 calls this "temperature_K"
    visc = 1000.0 * G / 10.0 * (1.0 / np.sin(np.pi * d / 180.0)) ** DSR_VISC_EXP
    return _fit_a_vts(np.log10(T_R), np.log10(np.log10(visc)), "From DSR Testing")


def a_vts_from_penetration(temp_f: Sequence[float], pen: Sequence[float]) -> BinderFit:
    T = np.asarray(temp_f, float)
    P = np.asarray(pen, float)
    visc = 10 ** (PEN_A - PEN_B * np.log10(P) + PEN_C * np.log(P) ** 2) * 100.0    # v2: log() is natural here
    return _fit_a_vts(np.log10(T + 459.7), np.log10(np.log10(visc)), "From Penetration Testing")


def a_vts_from_rotational(temp_f: Sequence[float], viscosity_cp: Sequence[float]) -> BinderFit:
    T = np.asarray(temp_f, float)
    V = np.asarray(viscosity_cp, float)
    return _fit_a_vts(np.log10(T + 459.7), np.log10(np.log10(V)), "From Rotational Viscometer Testing")


def a_vts_from_pg(grade: str) -> BinderFit:
    A, VTS = PG_TABLE[grade]
    return BinderFit(A, VTS, None, "NCHRP 1-37A")


# ---------------------------------------------------------------------------
# AMPT data assembly
# ---------------------------------------------------------------------------

@dataclass
class AverageTable:
    target_temp_f: np.ndarray      # col 1
    chamber_temp_f: np.ndarray     # col 2
    frequency: np.ndarray          # col 3
    E_psi: np.ndarray              # col 4  (mean of replicates)
    phase: np.ndarray              # col 5
    logE: np.ndarray               # col 6  (log10 of the averaged E)
    stdev_E: np.ndarray
    cov_E: np.ndarray
    stdev_phase: np.ndarray
    cov_phase: np.ndarray
    samples: List[np.ndarray]      # per-replicate 6-col tables (NaN rows removed)
    warn_unequal_freqs: bool


def _file_table(s: AMPTSummary, target_c: float) -> np.ndarray:
    tf = float(round(target_c * 9 / 5 + 32))
    E = s.modulus_mpa * MPA_TO_PSI
    chamber_f = s.avg_temp_c * 9 / 5 + 32
    return np.column_stack([np.full(len(E), tf), chamber_f, s.frequencies_hz, E, s.phase_deg, np.log10(E)])


def build_average_table(replicates: List[List[Optional[AMPTSummary]]],
                        target_temps_c: List[List[Optional[float]]]) -> AverageTable:
    """replicates[i][j] = summary for replicate i (0..2), temperature slot j (0..2, low->high)."""
    tables: Dict[tuple, Optional[np.ndarray]] = {}
    freqsets = []
    for i, rep in enumerate(replicates):
        for j, s in enumerate(rep):
            if s is None:
                tables[(i, j)] = None
                continue
            tables[(i, j)] = _file_table(s, target_temps_c[i][j])
            freqsets.append(s.frequencies_hz)
    if not freqsets:
        raise ValueError("No AMPT files loaded")
    sizes = [len(f) for f in freqsets]
    warn = len(set(sizes)) > 1
    base = np.asarray(freqsets[int(np.argmax(sizes))], float)

    def align(tbl, tf):
        out = np.full((len(base), 6), np.nan)
        out[:, 2] = base
        out[:, 0] = tf
        if tbl is None:
            return out
        for k, f in enumerate(base):
            hit = np.flatnonzero(tbl[:, 2] == f)
            if hit.size:
                out[k] = tbl[hit[0]]
        return out

    per_rep = []
    for i, rep in enumerate(replicates):
        blocks = []
        for j in range(len(rep)):
            tf = float(round((target_temps_c[i][j] or 0) * 9 / 5 + 32))
            blocks.append(align(tables.get((i, j)), tf))
        per_rep.append(np.vstack(blocks))
    stack = np.stack(per_rep, axis=2)                       # rows x 6 x reps
    avg = ml.nanmean(stack, axis=2)
    stdE = ml.nanstd(stack[:, 3, :], axis=1)
    stdP = ml.nanstd(stack[:, 4, :], axis=1)
    keep = ~np.any(np.isnan(avg), axis=1)
    avg = avg[keep]
    stdE = stdE[keep]
    stdP = stdP[keep]
    avg[:, 5] = np.log10(avg[:, 3])
    covE = stdE / avg[:, 3] * 100.0
    covP = stdP / avg[:, 4] * 100.0
    samples = []
    for i in range(stack.shape[2]):
        t = stack[:, :, i]
        samples.append(t[~np.any(np.isnan(t), axis=1)])
    return AverageTable(avg[:, 0], avg[:, 1], avg[:, 2], avg[:, 3], avg[:, 4], avg[:, 5],
                        stdE, covE, stdP, covP, samples, warn)


def blackspace_fit(logE: np.ndarray, phase: np.ndarray):
    """2nd-order polynomial of phase angle vs log E* with v2's R²."""
    p = ml.polyfit(logE, phase, 2)
    return p, ml.rsq_from_polyfit(logE, phase, p)


# ---------------------------------------------------------------------------
# Witczak / Hirsch predictions
# ---------------------------------------------------------------------------

@dataclass
class WitczakResult:
    volumetrics: Dict[str, float]
    delta: float
    alpha: float
    E_psi: np.ndarray
    temperature_f: np.ndarray
    frequency: np.ndarray


def viscosity_scaled(A: float, VTS: float, T_R: np.ndarray) -> np.ndarray:
    return (10 ** (10 ** (A + VTS * np.log10(T_R)))) / 100.0 / 1e6


def viscosity_v2_loop(A: float, VTS: float, T_R: np.ndarray) -> np.ndarray:
    """v2 quirk reproduced: entries above the cap are capped; all others are re-assigned the
    UN-scaled value 10^(10^(A+VTS·log T))."""
    scaled = viscosity_scaled(A, VTS, T_R)
    raw = 10 ** (10 ** (A + VTS * np.log10(T_R)))
    return np.where(scaled > VISCOSITY_CAP, VISCOSITY_CAP, raw)


def witczak_prediction(Gmm, Gsb, AV, AC, Gb, passing200, retained34, retained38, retained4,
                       A: float, VTS: float, temperature_f: np.ndarray, frequency: np.ndarray) -> WitczakResult:
    Gmb = Gmm - (AV / 100) * Gmm
    Mb = AC / 100 * Gmb
    Vb = Mb / Gb
    Gse = (100 - AC) / ((100 / Gmm) - (AC / Gb))
    Ps = 100 - AC
    Ms = Gmb - Mb
    Pba = 100 * ((Gse - Gsb) / (Gsb * Gse)) * Gb
    Pbe = AC - (Pba / 100) * Ps
    Vs = Ms / Gse
    Vse = Ms / Gsb
    Vabs = Vse - Vs
    Vbe = Vb - Vabs
    ACe = Vbe * 100
    VMA = (Vbe * 100) + AV
    VFA = (Vbe * 100) / VMA * 100
    Tgmm = Gmb / (1 - (1 - (Vbe + Vabs + Vs)))
    w = WITCZAK
    delta = (w["d0"] + w["d200"] * passing200 + w["d200sq"] * passing200 ** 2 + w["d4"] * retained4
             + w["dva"] * AV + w["dvb"] * (ACe / (ACe + AV)))
    alpha = w["a0"] + w["a4"] * retained4 + w["a38"] * retained38 + w["a38sq"] * retained38 ** 2 + w["a34"] * retained34
    T_R = ((temperature_f - 32) * 5 / 9) * 1.8 + 491.67
    visc = viscosity_scaled(A, VTS, T_R)
    beta = w["b0"] + w["b1"] * np.log10(frequency)
    E = (10 ** (delta + (alpha / (1 + np.exp(beta + w["c"] * np.log10(visc)))))) * w["scale"]
    vol = dict(AV=AV, Pb=AC, Mb=Mb, Gmm=Gmm, Tgmm=Tgmm, Gmb=Gmb, Gse=Gse, Gsb=Gsb, Ps=Ps, Ms=Ms, HMA_AV=AV,
               Pba=Pba, Pbe=Pbe, ACe=ACe, Vs=Vs, Vse=Vse, Vb=Vb, Vabs=Vabs, Vbe=Vbe, VMA=VMA, VFA=VFA,
               delta=delta, alpha=alpha)
    return WitczakResult({k: float(v) for k, v in vol.items()}, float(delta), float(alpha), E,
                         np.asarray(temperature_f, float), np.asarray(frequency, float))


def hirsch_from_gstar(VMA: float, VFA: float, g_star_psi: np.ndarray) -> np.ndarray:
    G = np.abs(np.asarray(g_star_psi, float))
    k = (VFA * 3.0 * G) / VMA
    Pc = (HIRSCH_PC_A + k) ** HIRSCH_PC_EXP / (HIRSCH_PC_B + k ** HIRSCH_PC_EXP)
    return (Pc * (HIRSCH_E_AGG_PSI * (1 - VMA / 100) + 3.0 * G * (VFA * VMA / 10000.0))
            + (1 - Pc) * ((1 - VMA / 100) / HIRSCH_E_AGG_PSI + VMA / (3.0 * VFA * G)) ** (-1))


# ---------------------------------------------------------------------------
# Master curves
# ---------------------------------------------------------------------------

@dataclass
class MasterCurve:
    key: str
    title: str
    params: Dict[str, float]
    sse: float
    reduced: np.ndarray               # per data point (log reduced frequency or log reduced time)
    logE_measured: np.ndarray
    logE_predicted: np.ndarray
    reduced_frequency: np.ndarray     # Hz, per data point
    E_measured: np.ndarray            # psi, per data point
    grid_x: np.ndarray                # Hz (18 points)
    grid_y: np.ndarray                # psi
    phase: np.ndarray
    phase_fit: np.ndarray
    phase_rsq: float
    temperature_f: np.ndarray
    frequency: np.ndarray
    shift_factors: Dict[str, float] = field(default_factory=dict)   # log10(a_T) by temperature (°F)


def _sigmoid(delta, logEmax, beta, gamma, reduced):
    return delta + (logEmax - delta) / (1 + np.exp(beta + gamma * reduced))


def _finish(key, params, sse, reduced, logE, logE_pred, red_freq, E, gx, gy, phase, temperature_f, frequency,
            shift_factors):
    if len(reduced) > PHASE_POLY_ORDER:
        pp = ml.polyfit(reduced, phase, PHASE_POLY_ORDER)
        pfit = ml.polyval(pp, reduced)
        prsq = ml.rsq_from_polyfit(reduced, phase, pp)
    else:
        pfit = np.full_like(phase, np.nan)
        prsq = float("nan")
    return MasterCurve(key, CURVE_TITLES[key], params, float(sse), reduced, logE, logE_pred, red_freq, E,
                       gx, gy, phase, pfit, float(prsq), temperature_f, frequency, shift_factors)


def _two_pass(sse, setup):
    x1 = ml.fmincon_bounds(sse, setup["x0"], setup["lb"], setup["ub"])
    x2 = ml.fmincon_bounds(sse, x1, setup["lb"], setup["ub"])
    return x2


def fit_ea(frequency, temperature_f, logE, E_psi, phase, EMAX, ref_temp_c, key="ea", setup=FIT_EA) -> MasterCurve:
    f = np.asarray(frequency, float)
    Tf = np.asarray(temperature_f, float)
    logE = np.asarray(logE, float)
    Tref = ref_temp_c + 273.15
    T_K = (Tf - 32) * 5 / 9 + 273.15
    logEmax = math.log10(EMAX)

    def sse(x):
        d, b, g, EA = x
        red = np.log10(f) + (EA / EA_CONST) * (1 / T_K - 1 / Tref)
        return float(np.sum((_sigmoid(d, logEmax, b, g, red) - logE) ** 2))

    d, b, g, EA = _two_pass(sse, setup)
    red = np.log10(f) + (EA / EA_CONST) * (1 / T_K - 1 / Tref)
    pred = _sigmoid(d, logEmax, b, g, red)
    gx = 10 ** REDUCED_GRID
    gy = 10 ** _sigmoid(d, logEmax, b, g, REDUCED_GRID)
    red_freq = 10 ** red
    shifts = {}
    for t in np.unique(Tf):
        tk = (t - 32) * 5 / 9 + 273.15
        shifts[str(t)] = float((EA / EA_CONST) * (1 / tk - 1 / Tref))
    return _finish(key, dict(delta=d, beta=b, gamma=g, EA=EA), sse([d, b, g, EA]), red, logE, pred, red_freq,
                   np.asarray(E_psi, float), gx, gy, np.asarray(phase, float), Tf, f, shifts)


def fit_vts(frequency, temperature_f, logE, E_psi, phase, EMAX, ref_temp_c, A, VTS, key="vts",
            setup=FIT_VTS) -> MasterCurve:
    f = np.asarray(frequency, float)
    Tf = np.asarray(temperature_f, float)
    logE = np.asarray(logE, float)
    T_R = Tf + 459.67
    T_R_ref = ref_temp_c * 9 / 5 + 491.67
    visc = viscosity_v2_loop(A, VTS, T_R)
    visc_ref = float(viscosity_v2_loop(A, VTS, np.array([T_R_ref]))[0])
    logEmax = math.log10(EMAX)
    dv = np.log10(visc) - np.log10(visc_ref)

    def sse(x):
        d, b, g, C = x
        red = np.log10(1 / f) - C * dv
        return float(np.sum((_sigmoid(d, logEmax, b, g, red) - logE) ** 2))

    d, b, g, C = _two_pass(sse, setup)
    red = np.log10(1 / f) - C * dv
    pred = _sigmoid(d, logEmax, b, g, red)
    gx = 1 / (10 ** REDUCED_GRID)
    gy = 10 ** _sigmoid(d, logEmax, b, g, REDUCED_GRID)
    red_freq = 1 / (10 ** red)
    shifts = {}
    for t in np.unique(Tf):
        v = viscosity_v2_loop(A, VTS, np.array([t + 459.67]))[0]
        shifts[str(t)] = float(-C * (np.log10(v) - np.log10(visc_ref)))
    return _finish(key, dict(delta=d, beta=b, gamma=g, C=C), sse([d, b, g, C]), red, logE, pred, red_freq,
                   np.asarray(E_psi, float), gx, gy, np.asarray(phase, float), Tf, f, shifts)


def fit_free(frequency, temperature_f, logE, E_psi, phase, EMAX, key="free", setup=FIT_FREE) -> MasterCurve:
    f = np.asarray(frequency, float)
    Tf = np.asarray(temperature_f, float)
    logE = np.asarray(logE, float)
    logEmax = math.log10(EMAX)
    t1 = int(np.max(np.flatnonzero(Tf - Tf[0] < FREE_TEMP_GROUP_TOL_F))) + 1          # MATLAB temp1_idx (1-based)
    t2 = t1 + 1
    t3 = int(np.max(np.flatnonzero(Tf - Tf[t2 - 1] < FREE_TEMP_GROUP_TOL_F))) + 1 + 1
    f1, f2, f3 = f[:t1], f[t1:t3 - 1], f[t3 - 1:]

    def reduced_of(x):
        c, ccc = x[3], x[4]
        fe = np.concatenate([10 ** c * f1, 10 ** 0 * f2, 10 ** ccc * f3])
        return np.log10(1 / fe), fe

    def sse(x):
        d, b, g = x[0], x[1], x[2]
        red, _ = reduced_of(x)
        return float(np.sum((_sigmoid(d, logEmax, b, g, red) - logE) ** 2))

    x = _two_pass(sse, setup)
    d, b, g, c, ccc = x
    red, fe = reduced_of(x)
    pred = _sigmoid(d, logEmax, b, g, red)
    gx = 1 / (10 ** REDUCED_GRID)
    gy = 10 ** _sigmoid(d, logEmax, b, g, REDUCED_GRID)
    shifts = {str(Tf[0]): float(c), str(Tf[t2 - 1]): 0.0, str(Tf[t3 - 1]): float(ccc)}
    return _finish(key, dict(delta=d, beta=b, gamma=g, c=c, cc=0.0, ccc=ccc), sse(x), red, logE, pred, fe,
                   np.asarray(E_psi, float), gx, gy, np.asarray(phase, float), Tf, f, shifts)
