# Combined 3-Week CKA + CKAD Study Plan with Advanced Labs

## Overview

- Goal: Prepare for both CKA and CKAD in three weeks with intensive, hands-on practice.
- Strategy: When topics overlap, always study from the more complex CKA perspective to fully cover CKAD needs.
- Cluster: Start with your 3-node `kubeadm` cluster (1 control plane, 2 workers). Optionally add:
  - A 4th worker for chaos and drain/eviction tests.
  - An HA control plane (2–3 control-plane nodes) for upgrade and failure drills.
  - An external etcd node if you want to practice etcd HA patterns.

## Prerequisites and Speed Setup

- Terminal Proficiency: Bash, `vim` or `nano`, and quick file navigation.
- `kubectl` Ergonomics:
  - `alias k=kubectl` and shell completion.
  - Prefer imperative to YAML: `--dry-run=client -o yaml`.
- Documentation Navigation: Practice finding pages in the official Kubernetes docs quickly.
- Baseline Validation:
  - Ensure all nodes are Ready.
  - Confirm CNI and DNS are healthy.
  - Verify `kubectl` context and permissions.

```bash
# Enable autocomplete (bash example)
source <(kubectl completion bash)
echo 'alias k=kubectl' >> ~/.bashrc && source ~/.bashrc

# Common quick checks
k get nodes -o wide
k get pods -A
k -n kube-system get pods -o wide
```

## Study Philosophy

- Depth over breadth: Master cluster internals, security, and troubleshooting first; application patterns second.
- Practice-first approach: Every concept should be validated in-cluster via a lab.
- Time discipline: Use timers (5–10 minutes per task) to simulate exam cadence.

## Week 1: Foundations, Workloads, and Networking

### Objectives

- Build fluency with `kubectl`, YAML, core resources, and the control-plane architecture.
- Emphasize CKA-level troubleshooting in every topic.

### Topics

- Architecture and Components: `etcd`, `kube-apiserver`, `kube-scheduler`, `kube-controller-manager`, `kubelet`, `kube-proxy`.
- Workloads: Pods, ReplicaSets, Deployments, DaemonSets, Jobs, CronJobs.
- Configuration and Storage: ConfigMaps, Secrets, PVs/PVCs, StorageClasses.
- Networking: Services (ClusterIP, NodePort, LoadBalancer), Endpoints, DNS, NetworkPolicies, basic Ingress.

### Daily Plan

- Day 1–2: Architecture, Cluster Validation, `kubectl` Mastery.
- Day 3–4: Workload Types and Rollouts, Probes, Resource Requests/Limits.
- Day 5–6: Services, DNS, NetworkPolicies, Ingress Basics.
- Day 7: ConfigMaps, Secrets, PVCs, StorageClasses, Reclaim Policies.

### Week 1 Complex Labs

- Control Plane Failure and Recovery.
  - Move a static pod manifest (e.g., `kube-apiserver`) out of `/etc/kubernetes/manifests/` to simulate failure, observe system health, and restore it.
  - Capture and interpret logs from `kubelet` and control-plane pods.
- NetworkPolicy Zero-Trust Baseline.
  - Default-deny all ingress and egress in a namespace; permit only namespace-scoped, port-scoped flows for a multi-tier app.
- Multi-Container Pod with Sidecar.
  - Build a sidecar that tails a file and sends logs to `stdout`; main container writes to shared `emptyDir`.
  - Add `liveness`, `readiness`, and `startup` probes tuned to realistic thresholds.

```bash
# Example: Imperative to YAML
k create deployment web --image=nginx --replicas=3 --dry-run=client -o yaml > web.yaml
k apply -f web.yaml
k expose deployment web --port=80 --target-port=8080 --dry-run=client -o yaml > web-svc.yaml
k apply -f web-svc.yaml
```

## Week 2: Administration, Scheduling, Security, and Storage

### 2. Objectives

- Master CKA-exclusive domains: backup/restore, upgrades, RBAC, taints/affinity, PodDisruptionBudgets.
- Strengthen storage and stateful patterns.

### 2. Topics

- Cluster Maintenance: Node drains/uncordon, component logs, static pod changes, `kubeadm upgrade`.
- Scheduling: Taints/Tolerations, Node Affinity/Anti-Affinity, Topology Spread Constraints, DaemonSets.
- Security: RBAC, ServiceAccounts, Pod Security Standards (baseline/restricted), Admission controls.
- Stateful Apps: StatefulSets, volume identity, PVC binding, dynamic provisioning, reclaim policies.
- Availability: PDBs and graceful disruption.

### 2. Daily Plan

- Day 8–9: Backup/Restore, Upgrades, Node Maintenance.
- Day 10–11: Scheduling Controls, Spread Constraints, DaemonSets.
- Day 12–13: RBAC, ServiceAccounts, Pod Security Standards and Admission Configuration.
- Day 14: StatefulSets, StorageClasses, PVC/PV binding edge cases, PDBs under drain.

### Week 2 Very Complex Labs

- Etcd Snapshot and Full Restore.
  - Take a snapshot, wipe data, restore to a new directory, and rewire the static pod manifest to the restored data path.
  - Verify cluster reconvergence with health checks and workloads.
- Cluster Upgrade with Zero Downtime.
  - Drain the control-plane node, upgrade via `kubeadm`, cordon/uncordon properly, then roll workers one-by-one while a critical app remains available under a strict PDB.
- Scheduling Puzzle: Taints, Tolerations, and Affinity.
  - Reserve a GPU node (`gpu=true:NoSchedule`) for select pods; ensure DaemonSets tolerate taints; enforce required Node Affinity (`disk=ssd`) for a stateful app.
- Pod Security Standards Rollout.
  - Apply namespace-level `restricted` profiles; fix failing workloads by adding required securityContext fields (runAsNonRoot, capabilities drop, readOnlyRootFilesystem) without breaking functionality.

```bash

# Drain/uncordon patterns
k drain <node> --ignore-daemonsets --delete-emptydir-data
# Perform maintenance...
k uncordon <node>
```

## Week 3: Advanced Networking, Troubleshooting, CRDs, Ingress, and Timed Drills

### 3. Objectives

- Achieve high-speed diagnosis and remediation, build custom resources, and configure advanced ingress and observability.
- Run multiple, timed full simulations.

### 3. Topics

- Troubleshooting: Events, logs, `kubectl exec`, `kubectl debug`, node/systemd logs, DNS/CNI issues.
- Extensibility: CRDs and basic Controllers/Operators; admission policy via a policy engine.
- Ingress: Path and host rules, TLS termination, rewrite rules; optional mTLS.
- Observability: Probes, metrics, basic Prometheus/Grafana deployment (optional), log shipping patterns.

### 3. Daily Plan

- Day 15–16: Probes, Rollouts/Rollbacks, Ingress Advanced Rules with TLS.
- Day 17: CRDs, simple controller, and admission policy basics.
- Day 18–21: Timed mixed scenarios; combine failures across networking, scheduling, storage, and security.

### Week 3 Expert Labs

- Blackhole Diagnostics.
  - Break DNS by misconfiguring CoreDNS; detect via `nslookup`/`dig` from a test pod; restore by fixing ConfigMap and rolling CoreDNS.
  - Switch `kube-proxy` between iptables and IPVS; verify service behavior under load; revert safely.
- CNI Migration Under Load.
  - Migrate from one CNI to another in a lab environment; plan order of operations, cordon/drain, and verify pod connectivity and policies post-migration.
- Custom Resource + Controller.
  - Define a CRD `ScalePolicy` with a spec that maps labels to replica counts.
  - Implement a minimal controller (script or lightweight tool) that watches CR instances and reconciles target Deployments.
- Advanced Ingress with TLS and Auth.
  - Configure host-based routing for multiple apps.
  - Add TLS certificates and enforce HTTPS only.
  - Integrate an auth proxy to protect selected paths.
- Stateful Data Resilience.
  - Deploy a database via StatefulSet with volumeClaimTemplates.
  - Kill pods and simulate node failure; ensure identity (ordinal) and data persistence remain correct.
  - Exercise volume expansion and snapshot restore if your storage class supports it.

```bash
# Quick troubleshooting patterns
k get events --sort-by=.lastTimestamp
k -n <ns> logs deploy/<name> --all-containers
k get endpoints <svc>
k -n kube-system logs ds/kube-proxy -c kube-proxy
```

## Timed Drill Routine

- Set a 60–90 minute window and stack 6–10 tasks.
- Rules:
  - Use only official documentation.
  - Start each resource via imperative generation, then refine YAML.
  - Aim for 5–8 minutes per task and move on if stuck; return later.
- Example Drill Stack:
  - Create a Deployment with probes and resource limits.
  - Expose via Service and Ingress with TLS.
  - Apply a NetworkPolicy that isolates the app except from a labeled client pod.
  - Add a PDB and drain/uncordon a node.
  - Rotate a Secret and trigger a rollout without downtime.
  - Diagnose failing DNS and restore CoreDNS.

## Recommended Cluster Variants

- Baseline: 1 control plane + 2 workers (your current setup).
- Chaos-Friendly: Add a 4th worker to absorb drains and evictions.
- HA Control Plane: 3 control-plane nodes for upgrade and failure drills.
- External Etcd: Separate node running etcd for HA and disaster-recovery practice.

## Checklists

- `kubectl` Essentials.
  - Context: `k config get-contexts`, `k config use-context <ctx>.`
  - Introspection: `k get`, `k describe`, `k logs`, `k events.`
  - Rollout: `k rollout status`, `k rollout undo`, `k set image.`
- Security and RBAC.
  - SA, Role/ClusterRole, RoleBinding/ClusterRoleBinding.
  - Verify with `k auth can-i <verb> <resource> --as <user>.`
- Scheduling.
  - Taints/Tolerations, Affinity/Anti-Affinity, Topology Spread Constraints.
- Storage.
  - PV/PVC binding, StorageClasses, Reclaim policies, StatefulSets.
- Troubleshooting.
  - Component logs, DNS tests, service endpoints, node health, events.

## Reference Links

- Kubernetes Documentation: [Kubernetes Docs](https://kubernetes.io/docs/).
- API Reference: [Kubernetes API Reference](https://kubernetes.io/docs/reference/kubernetes-api/).
- RBAC Concepts: [RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/).
- Networking: [Services](https://kubernetes.io/docs/concepts/services-networking/service/), [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/), [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/).
- Storage: [Volumes](https://kubernetes.io/docs/concepts/storage/volumes/), [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/).
- Workloads: [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/), [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/), [DaemonSets](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/).

## Daily Breakdown Table (Example)

| Day   | Focus Area                                                    | Lab Emphasis                                                |
| ----- | ------------------------------------------------------------- | ----------------------------------------------------------- |
| 1–2   | Architecture, `kubectl` fluency, control-plane introspection. | Control-plane failure simulation and recovery.              |
| 3–4   | Workloads, probes, rollouts/rollbacks.                        | Sidecar logging, multi-container design with probes.        |
| 5–6   | Services, DNS, NetworkPolicies, Ingress basics.               | Zero-trust namespace policies and DNS diagnostics.          |
| 7     | ConfigMaps, Secrets, PV/PVC, StorageClasses.                  | Manual PV/PVC binding and reclaim policy behavior.          |
| 8–9   | Maintenance, backup/restore, upgrades.                        | Etcd snapshot/restore and `kubeadm upgrade`.                |
| 10–11 | Scheduling controls and spread constraints.                   | Taints/tolerations puzzle and required affinity.            |
| 12–13 | RBAC, ServiceAccounts, Pod Security Standards.                | Least-privilege RBAC and restricted profiles rollout.       |
| 14    | StatefulSets and availability.                                | PDB under drain and data persistence on failure.            |
| 15–16 | Advanced Ingress, TLS, observability.                         | TLS termination and selective auth via proxy.               |
| 17    | CRDs and controller basics.                                   | Custom CRD and reconciliation script/controller.            |
| 18–21 | Timed mixed drills and full simulations.                      | Stacked scenarios across networking, storage, and security. |

## Notes and Edge Cases

- Prefer strict policies: Default-deny network, restricted Pod Security, least-privilege RBAC.
- Validate endpoints after every Service/Ingress change; do not assume connectivity.
- Watch for PVC binding issues due to access modes or StorageClass defaults.
- In drains, confirm DaemonSets and static pods are handled appropriately.
- Always verify readiness gates and PDBs before disruptive operations.

## Optional YAML and Command Starters

```yaml
# NetworkPolicy: Default deny and allow specific ingress
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-from-client
  namespace: app
spec:
  podSelector:
    matchLabels:
      app: api
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
        - namespaceSelector:
            matchLabels:
              access: client
      ports:
        - protocol: TCP
          port: 8080
  egress:
    - to:
        - podSelector:
            matchLabels:
              app: db
      ports:
        - protocol: TCP
          port: 5432
```

```yaml
# PodDisruptionBudget example
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: api-pdb
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: api
```

```yaml
# Affinity example
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
            - key: disk
              operator: In
              values:
                - ssd
```

---

Focus on disciplined, repeatable workflows, and push your labs beyond comfort. By prioritizing CKA-level depth on overlapping topics and running timed, complex scenarios, you’ll be well prepared for both exams.
