"""Declarative description of the bundled sample data set (the v2 demo files).

This is the single source of truth for "which sample file belongs to which module, read with
which template, at which specimen dimensions". Three consumers share it:

  * ``scripts/verify_demo_data.py`` — loads and analyses every file, proving the set still works.
  * ``tests/test_golden.py``       — joins files to the numbers transcribed from the v2 reports.
  * the ``/samples`` API route      — pre-loads a module's sample set in the app.

Before this module the same knowledge lived in three incompatible places: hand-built
``Template(...)`` literals inside the tests, scalar dimensions in ``tests/golden/values.json``,
and dead metadata strings. The templates named below are the ones the application actually
ships (``data/templates``), and they were verified to read the demo files to identical arrays
as the old inline literals.

Dimensions come from the v2 reference reports (``Demo Data/*/*.pdf``) wherever a report exists;
each set records where its numbers came from in ``dimensions_source``.
"""
from __future__ import annotations

import fnmatch
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, Iterator, List, Optional, Tuple

from .settings import SAMPLES_DIR

# ---------------------------------------------------------------------------
# roles
# ---------------------------------------------------------------------------
SPECIMEN = "specimen"            # a normal data file, read through analysis.load_data()
HIRSCH_INPUT = "hirsch_input"    # binder G* workbook, read through io.ampt.read_hirsch_input()

# Files matching these are not test data (Excel/LibreOffice lock files, OS metadata). They must
# never be offered as samples, and dragging one in should be refused with a readable message.
IGNORED_GLOBS = ("~$*", ".~lock.*", ".DS_Store", "Thumbs.db")


def is_ignored(name: str) -> bool:
    return any(fnmatch.fnmatch(name, g) for g in IGNORED_GLOBS)


@dataclass(frozen=True)
class SampleFile:
    name: str                    # path relative to the set's folder
    specimen_id: str             # pre-filled label; free text, unique within the set
    role: str = SPECIMEN
    golden: bool = False         # numbers for this file were transcribed from the v2 report
    note: str = ""
    expect: Dict[str, object] = field(default_factory=dict)
    """Qualitative outcomes this file is known to produce, checked by the verification harness.

    These pin the degraded and edge-case paths that headline numbers hide: a failed tail
    extrapolation, a missing stripping inflection point, an absent wheel. The harness fails on
    a mismatch in *either* direction, so a file that quietly starts succeeding is as loud as one
    that starts failing -- which is what keeps v2's bug-for-bug behaviour from drifting.
    """


@dataclass(frozen=True)
class SampleSet:
    module: str
    folder: str                  # relative to SAMPLES_DIR
    template: Optional[str]      # built-in template id, or None for the fixed-format readers
    dimensions: Dict[str, float] = field(default_factory=dict)
    files: Tuple[SampleFile, ...] = ()
    reference_pdf: Optional[str] = None
    dimensions_source: str = ""
    note: str = ""

    def path(self) -> Path:
        return SAMPLES_DIR / self.folder

    def specimens(self) -> Tuple[SampleFile, ...]:
        return tuple(f for f in self.files if f.role == SPECIMEN)

    def file_path(self, f: SampleFile) -> Path:
        return self.path() / f.name

    def rel(self, f: SampleFile) -> str:
        """'IDEAL-CT/IDEALCT Demo File 1.xlsx' — the key golden/values.json uses."""
        return f"{self.folder}/{f.name}"


# ---------------------------------------------------------------------------
# the sample sets
# ---------------------------------------------------------------------------
# Specimen ids are derived from the file names so they are unique and informative. Where a
# reference report numbered its rows (IDEAL-CT, DCT, Cold SCB, HT-IDT print a bare 1/2/3) that
# number is a row position the v2 operator typed, not a property of the file, so it is not
# reused here -- except for SCB, whose 1A/1B/2A/2B are real specimen labels mapping 1:1 to files.
#
# Air voids are deliberately absent: every reference report prints "#DIV/0!" for air voids,
# i.e. the v2 demo runs left that field blank. It is optional for all ten modules.

SAMPLE_SETS: Tuple[SampleSet, ...] = (
    SampleSet(
        module="apa",
        folder="APA",
        template=None,                       # IPC Global fixed format
        dimensions={},
        reference_pdf="APA/APA.pdf",
        dimensions_source="APA takes no specimen dimensions.",
        note="Single-specimen export: v2 produced one report per file. The 2% file is the one "
             "the reference report covers; 4/6/8% exercise the other wheel layouts.",
        files=(
            SampleFile("APA, 2% AV BRIC.xlsx", "2% AV BRIC", golden=True,
                       note="reference report row 'Sample #1'; right wheel absent",
                       expect={"wheels": "left+center"}),
            SampleFile("APA, 4% AV BRIC.xlsx", "4% AV BRIC", expect={"wheels": "left+right"}),
            SampleFile("APA, 6% AV BRIC.xlsx", "6% AV BRIC", expect={"wheels": "left+right"}),
            SampleFile("APA, 8% AV BRIC.xlsx", "8% AV BRIC", expect={"wheels": "center+right"}),
        ),
    ),
    SampleSet(
        module="beam",
        folder="BEAM",
        template="Default_-_Beam",
        dimensions={"width_mm": 100.0, "height_mm": 100.0, "length_mm": 100.0},
        reference_pdf="BEAM/Beam.pdf",
        dimensions_source="Beam.pdf: Width 100 / Height 100 / Length 100 mm.",
        note="Single-specimen export.",
        files=(
            SampleFile("Beam_RR_Berger_#7.csv", "#7", golden=True),
            SampleFile("Beam_RR_Berger_#10.csv", "#10"),
            SampleFile("Beam_RR_Berger_#24.csv", "#24"),
        ),
    ),
    SampleSet(
        module="bond",
        folder="Bond Strength",
        template="MTS_TWSX_stroke_mm_load_kN_-_IDEAL-CT_Bond",
        dimensions={"diameter_mm": 150.0, "length_mm": 50.0},
        reference_pdf=None,
        dimensions_source=(
            "SELF-GENERATED, not v2-derived: Bond Strength ships no reference report. 150 mm is "
            "the standard core diameter; length feeds only the reported Length (in) pass-through "
            "and never the strength calculation (bond.analyse -> BondStrfinder.m)."
        ),
        files=(
            SampleFile("Bond Strength Demo File 1.xlsx", "1"),
            SampleFile("Bond Strength Demo File 2.xlsx", "2"),
            SampleFile("Bond Strength Demo File 3.xlsx", "3"),
        ),
    ),
    SampleSet(
        module="cold_scb",
        folder="Cold SCB",
        template="MTS_TWSX_4-channel_stroke_m_load_N_-_Cold_SCB",
        dimensions={"thickness_mm": 25.0, "radius_mm": 75.0, "notch_mm": 15.0},
        reference_pdf="Cold SCB/cold.pdf",
        dimensions_source="cold.pdf: Thickness 25.0 / Radius 75.0 / Notch 15.0 mm.",
        note="The report's three rows are demo files 4, 5 and 6 -- not 1, 2 and 3. File 1 is the "
             "only file in the whole set whose tail extrapolation fails (tail_success=False).",
        files=(
            SampleFile("Cold SCB Demo File 1.xlsx", "1", expect={"tail_success": False},
                       note="the only file in the set whose tail extrapolation fails: the fit "
                            "pins tail_B at its -2 bound, so Gf is the no-tail value"),
            SampleFile("Cold SCB Demo File 2.xlsx", "2", expect={"tail_success": True}),
            SampleFile("Cold SCB Demo File 3.xlsx", "3", expect={"tail_success": True}),
            SampleFile("Cold SCB Demo File 4.xlsx", "4", golden=True, expect={"tail_success": True}),
            SampleFile("Cold SCB Demo File 5.xlsx", "5", golden=True, expect={"tail_success": True}),
            SampleFile("Cold SCB Demo File 6.xlsx", "6", golden=True, expect={"tail_success": True}),
        ),
    ),
    SampleSet(
        module="dct",
        folder="DCT",
        template="MTS_TWSX_4-channel_stroke_mm_load_kN_-_DCT",
        dimensions={"diameter_mm": 150.0, "thickness_mm": 50.0, "ligament_mm": 83.0},
        reference_pdf="DCT/DCT.pdf",
        dimensions_source="DCT.pdf: Diameter 150.00 / Thickness 50.00 / Ligament 83.00 mm.",
        note="The report's three rows are demo files 1, 3 and 4. Files 1 and 4 are byte-identical "
             "in their reported values, which is why the report shows row 1 and row 3 matching.",
        files=(
            SampleFile("DCT Demo File 1.xlsx", "1", golden=True),
            SampleFile("DCT Demo File 2.xlsx", "2"),
            SampleFile("DCT Demo File 3.xlsx", "3", golden=True),
            SampleFile("DCT Demo File 4.xlsx", "4", golden=True),
        ),
    ),
    SampleSet(
        module="dynamic_modulus",
        folder="Dynamic Modulus",
        template=None,                       # AMPT summary CSVs, fixed format
        dimensions={"Gmm": 2.473, "Gsb": 2.700, "air_voids": 4.0, "ac_pct": 5.0},
        reference_pdf="Dynamic Modulus/DM.pdf",
        dimensions_source=(
            "SELF-GENERATED volumetrics: DM.pdf prints the master curve but no volumetrics. These "
            "four reproduce the report's E*max of 3,294,355 psi to within 0.002% via "
            "emax_hirsch(), giving VMA 16.47 / VFA 75.71 -- both in the normal Superpave range."
        ),
        note="Three replicates at three temperatures each; the target temperature is read from the "
             "file name by io.ampt.guess_temperature_from_name(). The Hirsch workbook is a binder "
             "G* input for the optional Hirsch master curves, not a specimen file, and needs "
             "volumetrics (VMA/VFA) entered first.",
        files=(
            SampleFile("Winslow/Winslow_#1_4C_Sum.csv", "Winslow #1", golden=True),
            SampleFile("Winslow/Winslow_#1_20C_Sum.csv", "Winslow #1", golden=True),
            SampleFile("Winslow/Winslow_#1_45C_Sum.csv", "Winslow #1", golden=True),
            SampleFile("Winslow/Winslow_#2_4C_Sum.csv", "Winslow #2", golden=True),
            SampleFile("Winslow/Winslow_#2_20C_Sum.csv", "Winslow #2", golden=True),
            SampleFile("Winslow/Winslow_#2_45C_Sum.csv", "Winslow #2", golden=True),
            SampleFile("Winslow/Winslow_#3_4C_Sum.csv", "Winslow #3", golden=True),
            SampleFile("Winslow/Winslow_#3_20C_Sum.csv", "Winslow #3", golden=True),
            SampleFile("Winslow/Winslow_#3_45C_Sum.csv", "Winslow #3", golden=True),
            SampleFile("Hirsch Input File.xlsx", "binder G*", role=HIRSCH_INPUT,
                       note="18 rows at 39/68/113 F; POST /api/dm/hirsch/file"),
        ),
    ),
    SampleSet(
        module="hamburg",
        folder="HAM",
        template=None,                       # Hamburg fixed format
        dimensions={},
        reference_pdf="HAM/HAM.pdf",
        dimensions_source="Hamburg takes no specimen dimensions.",
        note="Single-specimen export. Reported per wheel, not per specimen: the reference report's "
             "left wheel has no stripping inflection point, the right wheel has one at 16,197 "
             "cycles. File 2 has none on either wheel.",
        files=(
            SampleFile("HAM Demo File 1.xlsx", "1", golden=True,
                       expect={"left_sip": False, "right_sip": True},
                       note="left wheel has no stripping inflection point; the right wheel's is "
                            "at 16,197 cycles and becomes the reported average"),
            SampleFile("HAM Demo File 2.xlsx", "2",
                       expect={"left_sip": False, "right_sip": False},
                       note="no stripping inflection on either wheel, so the average is None too "
                            "-- the one file that exercises that path"),
        ),
    ),
    SampleSet(
        module="htidt",
        folder="HTIDT",
        template="SmartJIG_to_RAAT",
        dimensions={"thickness_mm": 150.0, "diameter_mm": 150.0},
        reference_pdf="HTIDT/HTIDT.pdf",
        dimensions_source="HTIDT.pdf: Thickness 150.0 / Diameter 150.0 mm.",
        files=(
            SampleFile("HTIDT Demo File 1.csv", "1", golden=True),
            SampleFile("HTIDT Demo File 2.csv", "2", golden=True),
            SampleFile("HTIDT Demo File 3.csv", "3", golden=True),
        ),
    ),
    SampleSet(
        module="ideal_ct",
        folder="IDEAL-CT",
        template="MTS_TWSX_stroke_mm_load_kN_-_IDEAL-CT_Bond",
        dimensions={"thickness_mm": 62.0, "diameter_mm": 150.0},
        reference_pdf="IDEAL-CT/IDEALCT Demo.pdf",
        dimensions_source="IDEALCT Demo.pdf: Thickness 62.0 / Diameter 150.0 mm.",
        files=(
            SampleFile("IDEALCT Demo File 1.xlsx", "1", golden=True),
            SampleFile("IDEALCT Demo File 2.xlsx", "2", golden=True),
            SampleFile("IDEALCT Demo File 3.xlsx", "3", golden=True),
        ),
    ),
    SampleSet(
        module="scb",
        folder="SCB",
        template="MTS_TWSX_stroke_m_load_kN_-_SCB",
        dimensions={"thickness_mm": 50.0, "ligament_mm": 58.0},
        reference_pdf="SCB/SCB.pdf",
        dimensions_source="SCB.pdf: Thickness 50.00 / Ligament Length 58.00 mm.",
        note="No file in this set needs a manual inflection pick, so the manual-pick path has no sample coverage. Stroke is in metres for this module -- the template that reads millimetres would "
             "parse happily and report numbers 1000x out.",
        files=(
            SampleFile("SCB Demo File 1.xlsx", "1A", golden=True, expect={"needs_pick": False}),
            SampleFile("SCB Demo File 2.xlsx", "1B", golden=True, expect={"needs_pick": False}),
            SampleFile("SCB Demo File 3.xlsx", "2A", golden=True, expect={"needs_pick": False}),
            SampleFile("SCB Demo File 4.xlsx", "2B", golden=True, expect={"needs_pick": False}),
        ),
    ),
)

_BY_MODULE = {s.module: s for s in SAMPLE_SETS}


def get(module_id: str) -> SampleSet:
    return _BY_MODULE[module_id]


def find(module_id: str) -> Optional[SampleSet]:
    return _BY_MODULE.get(module_id)


def modules() -> List[str]:
    return [s.module for s in SAMPLE_SETS]


def all_files() -> Iterator[Tuple[SampleSet, SampleFile]]:
    for s in SAMPLE_SETS:
        for f in s.files:
            yield s, f
