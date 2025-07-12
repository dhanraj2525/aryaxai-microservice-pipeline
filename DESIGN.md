Observability Strategy for AryaXAI Microservice

Metrics

We will use Prometheus for metrics collection and Grafana for visualization and alerting. Prometheus will scrape metrics from the FastAPI application (exposed via /metrics endpoint using prometheus-fastapi-instrumentator). Key metrics to monitor:





Request Latency: Measure the time taken to process HTTP requests (e.g., p99, p95, p50).



Error Rate: Track the percentage of HTTP 4xx and 5xx responses.



Request Rate: Monitor the number of requests per second.



CPU/Memory Utilization: Track resource usage of the application pods via kube-state-metrics.



Pod Autoscaling Metrics: Monitor the number of replicas and CPU utilization driving the HPA.

Prometheus will be deployed in the Kubernetes cluster, with Grafana dashboards configured for real-time monitoring. Alerts will be set up in Grafana for thresholds (e.g., error rate > 5%, latency > 500ms).

Logging

Logs will be aggregated using Loki with Promtail as the log collection agent. FastAPI will log to stdout/stderr in JSON format for structured logging. Promtail will scrape logs from pods and send them to Loki. Grafana will be used to query and visualize logs, enabling searches by log level, endpoint, or timestamp. Retention will be set to 7 days to balance storage and debugging needs.

Tracing

Distributed tracing will be implemented using OpenTelemetry with Jaeger as the backend. The FastAPI application will be instrumented with OpenTelemetry SDK to generate traces for HTTP requests. Jaeger will store and visualize traces, allowing us to identify bottlenecks or failures across microservices. OpenTelemetry Collector will be deployed to aggregate and export traces to Jaeger.

This observability stack ensures comprehensive monitoring, rapid debugging, and performance optimization for the microservice.