# Unified Atomic Task Template (TK)

| Section | Content (Source Mapping) | Priority for VS Code AI |
|---------|--------------------------|-------------------------|
| Identity | TITLE (TK-ID): Atomic action in imperative mood (0.5–2 days max) | Execution command |
| Goal | GOAL AND RESULT: Single concrete artifact (e.g., "Working GET /users endpoint with full test coverage") | Validation target for ADE metrics |
| Context | INPUTS (REQUIRED): API/Event Contract link, DDL/Model link, UI Design link, RTM references (Story/Feature ID) | AI Context Attachment (high priority) |
| Plan | SCOPE AND IMPLEMENTATION STEPS: Sequential, detailed steps (enforces plan-first SOP) | Agent Guardrail: Must follow sequence |
| Files | FILES TO CREATE/CHANGE: Explicit list of files/directories (aligns with 01-repo-structure.mdc) | Agent Guardrail: File Modification Limits |
| Quality | REQUIRED TESTS: Must define Unit, Integration, Contract, Performance, Security, A11y tests | Direct mapping to CI/CD Quality Gates |
| Budget | NFR (TARGETS): Quantified budgets (e.g., p95 ≤ 100ms, SAST must pass) | AI Optimization Goal (Performance First) |
| DoD | DEFINITION OF DONE (Task): Checklist confirming code/tests pass, Contracts are consistent, and NFRs are met | Final task acceptance checklist |
| Metadata | TIME AND RISKS: Estimated time and mitigation plan | Planning and Project Board automation |
