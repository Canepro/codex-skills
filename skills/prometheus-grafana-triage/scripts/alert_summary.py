#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import sys
import urllib.error
import urllib.request

DEFAULT_TIMEOUT_SECONDS = 10


def fetch_json(url: str):
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


def from_prometheus(base_url: str) -> int:
    data = fetch_json(base_url.rstrip("/") + "/api/v1/alerts")
    alerts = data["data"]["alerts"]
    for alert in alerts:
        labels = alert.get("labels", {})
        annotations = alert.get("annotations", {})
        print(
            " | ".join(
                [
                    f"state={alert.get('state', '')}",
                    f"alert={labels.get('alertname', '')}",
                    f"cluster={labels.get('cluster', '')}",
                    f"severity={labels.get('severity', '')}",
                ]
            )
        )
        if annotations.get("summary"):
            print(f"  summary={annotations['summary']}")
        if annotations.get("description"):
            print(f"  description={annotations['description']}")
        print()
    return 0


def from_alertmanager(base_url: str) -> int:
    alerts = fetch_json(base_url.rstrip("/") + "/api/v2/alerts")
    for alert in alerts:
        labels = alert.get("labels", {})
        status = alert.get("status", {})
        print(
            " | ".join(
                [
                    f"status={status.get('state', '')}",
                    f"alert={labels.get('alertname', '')}",
                    f"cluster={labels.get('cluster', '')}",
                    f"severity={labels.get('severity', '')}",
                ]
            )
        )
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Summarize active alerts from Prometheus or Alertmanager.")
    parser.add_argument("--prometheus-url", help="Base URL for Prometheus, for example http://127.0.0.1:9090")
    parser.add_argument("--alertmanager-url", help="Base URL for Alertmanager, for example http://127.0.0.1:9093")
    args = parser.parse_args()

    if bool(args.prometheus_url) == bool(args.alertmanager_url):
        parser.error("Provide exactly one of --prometheus-url or --alertmanager-url")

    if args.prometheus_url:
        return from_prometheus(args.prometheus_url)
    return from_alertmanager(args.alertmanager_url)


if __name__ == "__main__":
    raise SystemExit(main())
