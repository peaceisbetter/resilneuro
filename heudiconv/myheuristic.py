from __future__ import annotations

from typing import Optional

from heudiconv.utils import SeqInfo


def create_key(
    template: Optional[str],
    outtype: tuple[str, ...] = ("nii.gz",),
    annotation_classes: None = None,
) -> tuple[str, tuple[str, ...], None]:
    if template is None or not template:
        raise ValueError("Template must be a valid format string")
    return (template, outtype, annotation_classes)


def infotodict(
    seqinfo: list[SeqInfo],
) -> dict[tuple[str, tuple[str, ...], None], list[str]]:
    """Heuristic evaluator for determining which runs belong where

    allowed template fields - follow python string module:

    item: index within category
    subject: participant id
    seqitem: run number during scanning
    subindex: sub index within group
    """
    t1 = create_key("sub-{subject}/anat/sub-{subject}_T1w")
    t2 = create_key("sub-{subject}/anat/sub-{subject}_T2w")
    
    TASK = create_key("sub-{subject}/func/sub-{subject}_task-STERN_dir-{dir}_run-{item:01d}_bold")
    rest = create_key("sub-{subject}/func/sub-{subject}_task-REST_dir-{dir}_run-{item:01d}_bold")

    info: dict[tuple[str, tuple[str, ...], None], list] = {
        t1: [],
        t2: [],
        TASK: [],
        rest: [],
    }

    for idx, s in enumerate(seqinfo):
        if (s.dim3 == 208) and (s.dim4 == 1) and ("t1" in s.protocol_name):
            info[t1] = [s.series_id]
        if (s.dim3 == 208) and ("t2" in s.protocol_name):
            info[t2] = [s.series_id]
        if (s.series_files == 218) and ("ep2d_bold_p2_s5_2iso_750" in s.protocol_name):
            info[TASK].append({"item": s.series_id, "dir": "AP"})
        if (s.series_files == 488) and ("Resting_AP" in s.protocol_name):
            info[rest].append({"item": s.series_id, "dir": "AP"})
        if (s.series_files == 488) and ("Resting_PA" in s.protocol_name):
            info[rest].append({"item": s.series_id, "dir": "PA"})
    return info
