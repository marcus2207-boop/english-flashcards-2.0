# Phase 5 — Final Package (Deployment & Infrastructure) — Ready for Review

Wersja: 0.1  
Data: 2025-10-01

Status: Completed (ready for stakeholder review)

## Zakres i cele fazy 5
Faza 5 pokrywa architekturę wdrożenia i operacyjną warstwę systemu: deployment w homelabie (Docker Compose), diagramy deploymentowe (C4 L3), strategię CI/CD i release, monitoring/observability, health checks oraz runbook operacyjny.

## Dostarczone artefakty (lokalizacje)
- Phase 5 documentation: `Phase_5_Deployment_and_Infra.md`
- Deployment diagram (homelab): `diagrams/deployment-homelab.puml`
- C4 L3 components: `diagrams/c4-components.puml`
- CI updates with integrated smoke-tests: `.github/workflows/ci.yml`
- Runbook, health checks, monitoring notes included in `Phase_5_Deployment_and_Infra.md`

## Najważniejsze decyzje i konfiguracje
- Deployment target: Docker Compose on Proxmox VM (homelab)
- Coqui TTS: enabled by default in compose with resource limits cpu=1.0, memory=1g
- Admin network restriction: 192.168.1.0/24 (enforced in app middleware + proxy)
- Secrets: `.env` on host, perms 600. CI uses GitHub Secrets for deployment credentials if required
- Monitoring: recommended Prometheus (scrape /metrics), optional Grafana for dashboards
- Logging: structured JSON to stdout; ops collect via docker logs or optional ELK stack later

## Health checks (endpoints)
- GET /health -> overall service status (api, db, worker)
- GET /health/tts -> TTS engine status & sample latency
- Liveness/readiness guidelines included in `Phase_5_Deployment_and_Infra.md`

## CI/CD & Release
- PR -> CI (lint/tests)
- merge -> build images + smoke-tests (CI)
- release tags -> optional push to registry
- deploy -> manual or automated worker on homelab (runbook includes `deploy.sh` pattern)

## Monitoring & Alerts (summary)
- Instrument FastAPI with Prometheus metrics (endpoint timings, request counts)
- Monitor:
  - API health and error rates
  - TTS success rate and latency
  - DB file size and disk usage
  - Queue length for background tasks
- Alert thresholds (examples):
  - API p90 > 500ms (investigate)
  - TTS success rate < 95%
  - Disk usage > 80%

## Runbook snippets (ops)
- Start: `docker compose up --build -d`
- Check health: `curl -f http://localhost:8000/health`
- Backup DB: snapshot host volume via Proxmox
- Restore: replace db file, run migrations verification

## Acceptance checklist
- [ ] Review deployment diagrams and confirm mapping to infrastructure
- [ ] Confirm resource limits for Coqui (cpu=1.0, mem=1g) acceptable
- [ ] Verify CI smoke-tests pass (or accept sketched results)
- [ ] Approve Phase 5 for handoff to Ops/Dev

## Next steps after acceptance
- (Optional) Add Prometheus & Grafana services to `docker-compose.yml` for local monitoring
- (Optional) Implement OpenTelemetry tracing into FastAPI
- Prepare System Architecture Package (final handoff): combine Phases 1–6 into single document `System_Architecture_Package.md`

Prepared by: AI System Architect

Phase 5 status: Completed and waiting your approval.