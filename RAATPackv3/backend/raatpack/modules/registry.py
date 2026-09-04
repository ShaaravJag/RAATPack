"""
Module registry — one entry per test. Presentation metadata only (names, standards, chart
labels, which reader/template kind). The maths lives in raatpack.equations.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Dict, List, Optional

from ..equations import ideal_ct, scb, cold_scb, dct, htidt, bond, apa, hamburg, beam
from ..equations._base import Field
from ..io.templates import KIND_XY, KIND_FOUR, KIND_BEAM

READER_XY = "xy"
READER_SCB = "scb"
READER_FOUR = "four"
READER_BEAM = "beam"
READER_APA = "apa"
READER_HAM = "hamburg"
READER_AMPT = "ampt"


@dataclass
class ModuleSpec:
    id: str
    name: str
    short: str
    standard: str
    description: str
    reader: str
    template_kind: Optional[str]          # None => no template (IPC Global / AMPT fixed formats)
    specimen_inputs: List[Field]
    required_inputs: List[str]
    result_fields: List[Field]
    x_label: str
    y_label: str
    chart_title: str
    report_title: str
    max_export: int = 0                   # 0 = unlimited (v2 was 12)
    single_export: bool = False           # v2 exported one sample per report (APA, HAM, Beam)
    supports_pick: bool = False           # SCB inflection / Hamburg slopes
    supports_trim: bool = False           # SCB "Trim Beginning?"
    extra: Dict = field(default_factory=dict)


MODULES: Dict[str, ModuleSpec] = {}


def _add(m: ModuleSpec):
    MODULES[m.id] = m


_add(ModuleSpec("ideal_ct", "IDEAL-CT", "IDEAL-CT", "ASTM D8225",
                "Indirect tensile cracking test on a full-size gyratory specimen. Reports the CT Index.",
                READER_XY, KIND_XY, ideal_ct.SPECIMEN_INPUTS, ideal_ct.REQUIRED_INPUTS, ideal_ct.RESULT_FIELDS,
                "Displacement (mm)", "Force (kN)", "IDEAL-CT", "IDEAL-CT: Proposed Cracking Test",
                extra={"passfail_label": "CT Index criteria"}))

_add(ModuleSpec("scb", "Intermediate Temperature SCB", "SCB", "AASHTO TP 124",
                "Semi-circular bend at intermediate temperature. Reports fracture energy and the Flexibility Index.",
                READER_SCB, KIND_XY, scb.SPECIMEN_INPUTS, scb.REQUIRED_INPUTS, scb.RESULT_FIELDS,
                "Displacement (mm)", "Force (kN)", "Intermediate Temperature SCB",
                "AASHTO TP 124: Standard Method of Test for Determining the Fracture Potential of Asphalt Mixtures "
                "Using Semicircular Bend Geometry (SCB) at Intermediate Temperatures",
                supports_pick=True, supports_trim=True))

_add(ModuleSpec("cold_scb", "Cold Temperature SCB", "Cold SCB", "AASHTO TP 105-13",
                "Low-temperature semi-circular bend. Reports fracture energy (with the extrapolated tail), stiffness and K_IC.",
                READER_FOUR, KIND_FOUR, cold_scb.SPECIMEN_INPUTS, cold_scb.REQUIRED_INPUTS, cold_scb.RESULT_FIELDS,
                "Displacement (mm)", "Load (kN)", "Cold SCB",
                "AASHTO Designation: TP 105-13 Standard Method of Test for Determining the Fracture Energy of "
                "Asphalt Mixtures Using the Semicircular Bend Geometry (SCB)",
                extra={"export_curve": "cod_vs_load", "tail_option": True}))

_add(ModuleSpec("dct", "DCT", "DCT", "ASTM D7313-13",
                "Disk-shaped compact tension. Reports fracture energy from the fitted CMOD.",
                READER_FOUR, KIND_FOUR, dct.SPECIMEN_INPUTS, dct.REQUIRED_INPUTS, dct.RESULT_FIELDS,
                "CMOD (mm)", "Load (kN)", "DCT",
                "ASTM D7313-13 Standard Test Method for Determining Fracture Energy of Asphalt-Aggregate Mixture "
                "Using the Disk-Shaped Compact Tension Geometry"))

_add(ModuleSpec("htidt", "HT-IDT", "HT-IDT", "ASTM D6931 (Modified, High Temperature)",
                "High-temperature indirect tensile strength.",
                READER_XY, KIND_XY, htidt.SPECIMEN_INPUTS, htidt.REQUIRED_INPUTS, htidt.RESULT_FIELDS,
                "Displacement (mm)", "Force (kN)", "HT-IDT", "ASTM D6931 (Modified, High Temperature): HT-IDT"))

_add(ModuleSpec("bond", "Bond Strength", "Bond", "AASHTO TP 114-17",
                "Interlayer shear (bond) strength on cores.",
                READER_XY, KIND_XY, bond.SPECIMEN_INPUTS, bond.REQUIRED_INPUTS, bond.RESULT_FIELDS,
                "Displacement (mm)", "Load (kN)", "Bond Strength",
                "AASHTO TP 114-17: Standard Method of Test for Determining the Interlayer Shear Strength (ISS) "
                "of Asphalt Pavement Layers"))

_add(ModuleSpec("apa", "APA", "APA", "AASHTO T340-10",
                "Asphalt Pavement Analyzer wheel-track rutting (IPC Global output).",
                READER_APA, None, apa.SPECIMEN_INPUTS, apa.REQUIRED_INPUTS, apa.RESULT_FIELDS,
                "Number of Loading Cycles", "APA Rutting (mm)", "APA Rutting",
                "AASHTO T340-10: Standard Method of Test for Determining Rutting Susceptibility of Hot Mix Asphalt "
                "(HMA) Using the Asphalt Pavement Analyzer (APA)",
                single_export=True, extra={"hose_pressure": True, "wheel_load": True}))

_add(ModuleSpec("hamburg", "Hamburg", "Hamburg", "AASHTO T324-17",
                "Hamburg wheel-track test (IPC Global output). Creep slope, stripping slope and inflection point per wheel.",
                READER_HAM, None, hamburg.SPECIMEN_INPUTS, hamburg.REQUIRED_INPUTS, hamburg.RESULT_FIELDS,
                "Loading Cycles (n)", "Vertical Deformation (mm)", "Hamburg",
                "AASHTO T324-17: Standard Method of Test for Hamburg Wheel-Track Testing of Compacted Asphalt Mixtures",
                single_export=True, supports_pick=True))

_add(ModuleSpec("beam", "Beam Fatigue", "Beam", "AASHTO T321",
                "Four-point bending fatigue. AASHTO exponential and ASTM normalized-modulus Nf50.",
                READER_BEAM, KIND_BEAM, beam.SPECIMEN_INPUTS, beam.REQUIRED_INPUTS, beam.RESULT_FIELDS,
                "Loading cycles (n)", "Flexural Stiffness (MPa)", "AASHTO Method",
                "AASHTO T321: Standard Method of Test for Determining the Fatigue Life of Compacted Asphalt Mixtures "
                "Subjected to Repeated Flexural Bending", single_export=True))

_add(ModuleSpec("dynamic_modulus", "Dynamic Modulus", "E*", "AASHTO T342 / R62 / R84",
                "AMPT dynamic modulus master curves (Arrhenius, VTS, free, Witczak, Hirsch).",
                READER_AMPT, None, [], [], [],
                "Loading Frequency (Hz)", "Dynamic Modulus (psi)", "Master Curve",
                "AASHTO T342: Standard Method of Test for Determining Dynamic Modulus of Hot Mix Asphalt (HMA)"))

ORDER = ["apa", "beam", "bond", "cold_scb", "dct", "dynamic_modulus", "hamburg", "htidt", "ideal_ct", "scb"]


def get(module_id: str) -> ModuleSpec:
    return MODULES[module_id]


def public(m: ModuleSpec) -> dict:
    f = lambda fl: [dict(key=x.key, label=x.label, dp=x.dp, report=x.report, fmt=x.fmt) for x in fl]
    return dict(id=m.id, name=m.name, short=m.short, standard=m.standard, description=m.description,
                reader=m.reader, template_kind=m.template_kind, specimen_inputs=f(m.specimen_inputs),
                required_inputs=m.required_inputs, result_fields=f(m.result_fields), x_label=m.x_label,
                y_label=m.y_label, chart_title=m.chart_title, report_title=m.report_title,
                single_export=m.single_export, supports_pick=m.supports_pick, supports_trim=m.supports_trim,
                extra=m.extra)
