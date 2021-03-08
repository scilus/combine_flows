#!/usr/bin/env python3


import argparse
from pathlib import Path


def get_arguments():
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "-t", "--tractoflow_dir",
        required=True,
        help="tractoflow results directory"
    )

    parser.add_argument(
        "-o", "--rbx_flow_tree",
        required=True,
        help="rbx_flow tree directory"
    )

    return parser.parse_args()


if __name__ == "__main__":
    args = get_arguments()

    tractoflow_dir = Path(args.tractoflow_dir)

    rbx_flow_tree = Path(args.rbx_flow_tree)
    rbx_flow_tree.mkdir(exist_ok=True)

    print(f"tractoflow folder: {tractoflow_dir.resolve()}")
    print(f"rbx_flow tree folder: {rbx_flow_tree.resolve()}")

    tree_patterns = [
        "*Tracking/*tracking*.trk",
        "DTI_Metrics/*__fa.nii.gz",
    ]

    for subject in tractoflow_dir.iterdir():
        excluded_dirs = ["FRF", "Readme"]
        if any([_ in subject.name for _ in excluded_dirs]):
            continue

        subject_tree = rbx_flow_tree / subject.name
        subject_tree.mkdir(exist_ok=True)

        for pattern in tree_patterns:
            link = list(subject.glob(pattern))
            if len(link) == 0:
                print(f"{subject / pattern} not found")
                continue

            elif len(link) > 1:
                print(f"Several links found for {subject / pattern}")
                continue

            else:
                link = link[0]

            path_tree = subject_tree / link.name
            path_tree.symlink_to(link.resolve())

