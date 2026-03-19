#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import sys
import urllib.error
import urllib.request

DEFAULT_TIMEOUT_SECONDS = 10


def fetch_json(url: str) -> dict:
    try:
        with urllib.request.urlopen(url, timeout=DEFAULT_TIMEOUT_SECONDS) as response:
            return json.load(response)
    except urllib.error.HTTPError as exc:
        print(f"failed to query {url}: HTTP {exc.code}", file=sys.stderr)
        raise SystemExit(1) from exc
    except urllib.error.URLError as exc:
        print(f"failed to query {url}: {exc.reason}", file=sys.stderr)
        raise SystemExit(1) from exc
    except json.JSONDecodeError as exc:
        print(f"failed to parse JSON from {url}: {exc}", file=sys.stderr)
        raise SystemExit(1) from exc


def main() -> int:
    parser = argparse.ArgumentParser(description="List Prometheus scrape targets that are not healthy.")
    parser.add_argument(
        "--prometheus-url",
        required=True,
        help="Base URL for Prometheus, for example http://127.0.0.1:9090",
    )
    args = parser.parse_args()

    url = args.prometheus_url.rstrip("/") + "/api/v1/targets?state=any"
    data = fetch_json(url)

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
