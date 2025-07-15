# Observability Strategy for AryaXAI Microservice

This document outlines the observability strategy for the AryaXAI FastAPI microservice, focusing on metrics, logging, and distributed tracing to ensure comprehensive monitoring, debugging, and performance optimization.

## Metrics

We will use **Prometheus** for metrics collection and **Grafana** for visualization and alerting. The FastAPI application will expose a `/metrics` endpoint using the `prometheus-fastapi-instrumentator` library to provide application-specific metrics. Prometheus will be deployed in the Kubernetes cluster, scraping metrics from the application and kube-state-metrics for cluster-level insights. Grafana dashboards will visualize metrics and trigger alerts for predefined thresholds.

### Key Metrics to Monitor

- **Request Latency**: Measure HTTP request processing time (e.g., p99, p95, p50 percentiles) to identify performance bottlenecks.
- **Error Rate**: Track the percentage of HTTP 4xx and 5xx responses to detect issues with the application or external dependencies.
- **Request Rate**: Monitor requests per second to understand traffic patterns and capacity needs.
- **CPU/Memory Utilization**: Track pod resource usage via kube-state-metrics to ensure efficient resource allocation.
- **Pod Autoscaling Metrics**: Monitor the number of replicas and CPU utilization driving the HorizontalPodAutoscaler (HPA) to verify scaling behavior.

### Implementation Details

- **Prometheus Configuration**: Deploy Prometheus using the `kube-prometheus-stack` Helm chart, configured to scrape the `/metrics` endpoint.
- **Grafana Dashboards**: Create dashboards for latency, error rate, and resource usage. Set alerts for critical thresholds (e.g., error rate > 5%, p99 latency > 500ms).
- **Retention**: Store metrics for 15 days to balance storage costs and historical analysis needs.

## Logging

Logs will be aggregated using **Loki** with **Promtail** as the log collection agent. The FastAPI application will log to stdout/stderr in JSON format for structured logging, including fields like timestamp, log level, endpoint, and request ID. Promtail will scrape logs from Kubernetes pods and send them to Loki for storage and querying. Grafana will be used as the frontend to search and visualize logs.

### Logging Strategy

- **Log Format**: Configure FastAPI to use a structured JSON logger (e.g., `python-json-logger`) with fields: `timestamp`, `level`, `message`, `endpoint`, `request_id`.
- **Log Levels**: Use `INFO` for normal operations, `ERROR` for failures, and `DEBUG` for detailed troubleshooting (disabled in production by default).
- **Search and Analysis**: Use Grafana to query logs by pod, namespace, log level, or request ID. Example query: `{app="aryaxai-app"} | level="error"`.
- **Retention**: Store logs for 7 days to balance storage and debugging needs.

### Implementation Details

- **Promtail Deployment**: Deploy Promtail as a DaemonSet to collect logs from all nodes.
- **Loki Configuration**: Deploy Loki in single-binary mode for simplicity, with S3 or EBS for storage in EKS.
- **Alerting**: Configure Loki ruler to send alerts to Grafana for critical log patterns (e.g., frequent `ERROR` logs).

## Tracing

Distributed tracing will be implemented using **OpenTelemetry** with **Jaeger** as the backend. The FastAPI application will be instrumented with the OpenTelemetry Python SDK to generate traces for HTTP requests, capturing spans for endpoint calls and external dependencies. The OpenTelemetry Collector will aggregate traces and export them to Jaeger for storage and visualization.

### Tracing Strategy

- **Instrumentation**: Use `opentelemetry-instrumentation-fastapi` to automatically instrument FastAPI endpoints, capturing spans for each request.
- **Trace Context**: Propagate trace context (e.g., trace ID) across microservices using W3C Trace Context headers.
- **Visualization**: Use Jaeger UI to visualize traces, identify latency bottlenecks, and debug cross-service interactions.
- **Sampling**: Configure head-based sampling (10% of requests) to reduce overhead while capturing sufficient traces for analysis.

### Implementation Details

- **OpenTelemetry Collector**: Deploy as a Deployment in the EKS cluster to collect and export traces to Jaeger.
- **Jaeger Deployment**: Deploy Jaeger in all-in-one mode for simplicity, using EBS for storage.
- **Retention**: Retain traces for 7 days to support debugging without excessive storage costs.

## Summary

This observability stack—Prometheus/Grafana for metrics, Loki/Promtail for logging, and OpenTelemetry/Jaeger for tracing—ensures comprehensive monitoring and rapid debugging. Metrics provide performance insights, logs enable error investigation, and traces reveal cross-service dependencies, collectively supporting a reliable and scalable microservice.
