#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import urllib.request


def main() -> int:
    parser = argparse.ArgumentParser(description="List Prometheus scrape targets that are not healthy.")
    parser.add_argument(
        "--prometheus-url",
        required=True,
        help="Base URL for Prometheus, for example http://127.0.0.1:9090",
    )
    args = parser.parse_args()

    url = args.prometheus_url.rstrip("/") + "/api/v1/targets?state=any"
    with urllib.request.urlopen(url) as response:
        data = json.load(response)

    for target in data["data"]["activeTargets"]:
        if target.get("health") == "up":
            continue
        labels = target.get("labels", {})
        print(
            " | ".join(
                [
                    f"health={target.get('health', '')}",
                    f"job={labels.get('job', '')}",
                    f"cluster={labels.get('cluster', '')}",
                    f"instance={labels.get('instance', '')}",
                    f"namespace={labels.get('namespace', labels.get('kubernetes_namespace', ''))}",
                    f"service={labels.get('service', labels.get('kubernetes_service_name', ''))}",
                ]
            )
        )
        print(f"  scrapeUrl={target.get('scrapeUrl', '')}")
        print(f"  lastError={target.get('lastError', '')}")
        print()

    return 0


if __name__ == "__main__":
    raise SystemExit(main())

