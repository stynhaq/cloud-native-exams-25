# CKA and CKAD Preb by Gemini Pro

Of course. Preparing for both the CKA (Certified Kubernetes Administrator) and CKAD (Certified Kubernetes Application Developer) exams in three weeks is an ambitious but achievable goal with intense, focused effort. Your strategy to create a combined study plan is excellent, as there is significant overlap. Prioritizing the more complex CKA perspective on shared topics will serve you well.

Your plan to use a 3-node `kubeadm` cluster is perfect for this preparation, as it will give you hands-on experience with cluster setup and maintenance, a key CKA domain.

Here is a combined, aggressive 3-week study plan designed to prepare you for both exams, followed by the complex lab scenarios you requested.

## Prerequisites & Exam Environment Simulation

Before you begin, ensure you are fast with the following, as speed is critical in the exam:

- **Command Line:** A Linux shell (bash).
- **Terminal Editor:** `vim` or `nano`. You will not have a GUI editor.
- **`kubectl` Alias:** Set this up immediately in your `.bashrc`: `alias k=kubectl`. It will save you thousands of keystrokes.
- **`kubectl` Imperative Commands:** Practice creating resources without writing full YAML files from scratch. The key is the `--dry-run=client -o yaml` flag, which generates the YAML for you to modify and apply.
- **Kubernetes Documentation:** You are allowed one browser tab open to the official Kubernetes documentation (`kubernetes.io/docs`, `/blog`, `/api`). Practice finding information there quickly.

---

### The 3-Week Combined CKA/CKAD Study Plan

This plan front-loads CKA topics, as they provide the foundational context for the CKAD topics.

#### **Week 1: Core Concepts & `kubectl` Mastery**

The goal this week is to master the fundamental building blocks and become fluent with `kubectl`.

- **Day 1-2: Cluster Architecture & `kubectl` Fluency**

  - **Topic:** Cluster Installation & Components. Build your 3-node `kubeadm` cluster. Understand the roles of `etcd`, `kube-apiserver`, `kube-scheduler`, `kube-controller-manager`, `kubelet`, and `kube-proxy`.
  - **CKA Focus:** Use `kubeadm` to initialize the control plane and join worker nodes. Learn to inspect component logs using `journalctl` or `kubectl logs` in the `kube-system` namespace.
  - **`kubectl` Practice:**
    - `k config view`, `k config use-context`
    - `k get <resource> -o wide`, `k describe <resource> <name>`
    - `k run <pod-name> --image=<image> -- <command>`
    - `k create deployment <name> --image=<image> --replicas=3`
    - `k expose deployment <name> --port=80 --target-port=8080`
    - `k scale deployment <name> --replicas=5`
    - `k set image deployment/<name> <container-name>=<new-image>`

- **Day 3-4: Workloads**

  - **Topic:** Pods, Deployments, ReplicaSets, DaemonSets, Jobs, CronJobs.
  - **CKA/CKAD Overlap:** Both exams require you to create, manage, and troubleshoot these.
  - **Practice:** Use imperative commands with `--dry-run=client -o yaml` to generate manifests. Understand the difference between a `Deployment` (for stateless apps) and a `StatefulSet` (for stateful apps). Create a `CronJob` that runs a simple script every minute.

- **Day 5-6: Services & Networking**

  - **Topic:** Exposing applications and controlling traffic.
  - **CKA Focus (More Complex):** Understand how Services use `kube-proxy` (iptables/IPVS mode) to route traffic. Troubleshoot DNS resolution within the cluster using a `busybox` or `dnsutils` pod (`nslookup <service-name>`). Create and troubleshoot `NetworkPolicies` to restrict pod-to-pod communication.
  - **CKAD Focus:** Know how to expose a Deployment using `ClusterIP`, `NodePort`, and a basic `Ingress` resource.

- **Day 7: Configuration & Storage**
  - **Topic:** ConfigMaps, Secrets, PersistentVolumes (PV), and PersistentVolumeClaims (PVC).
  - **CKA Focus (More Complex):** Manually create a `PersistentVolume` (e.g., using `hostPath` for your lab) and have it bound by a `PersistentVolumeClaim`. Understand different reclaim policies.
  - **CKAD Focus:** Know how to create a `PVC` and mount it into a Pod as a volume. Know how to consume `ConfigMaps` and `Secrets` as environment variables or mounted files.

---

#### **Week 2: CKA - The Administrator's Domain**

This week is dedicated to the core CKA domains that are less emphasized in CKAD.

- **Day 8-9: Cluster Administration & Maintenance**

  - **Topic:** Managing a live cluster.
  - **CKA Focus:** Practice `etcd` backup and restore from a snapshot. This is a critical, high-value task. Practice upgrading your cluster using `kubeadm upgrade`. Learn to safely drain a node for maintenance (`k drain <node> --ignore-daemonsets`) and bring it back online (`k uncordon <node>`).

- **Day 10-11: Advanced Scheduling**

  - **Topic:** Controlling where pods run.
  - **CKA Focus:** Use `Taints` and `Tolerations` to repel pods from nodes unless they have a matching toleration. Use `Node Selectors` and `Node Affinity` to attract pods to specific nodes based on labels.

- **Day 12-13: Security**

  - **Topic:** Securing the cluster and its applications.
  - **CKA Focus:** This is a huge CKA topic. Master Role-Based Access Control (RBAC). Create `Roles` (namespaced) and `ClusterRoles` (cluster-wide), and bind them to users or `ServiceAccounts` using `RoleBindings` and `ClusterRoleBindings`. Practice using `k auth can-i ... --as <user>` to test permissions.

- **Day 14: Monitoring & Troubleshooting**
  - **Topic:** Observing and fixing a broken cluster.
  - **CKA Focus:** Monitor node health (`k top node`). Monitor application resource usage (`k top pod`). Troubleshoot a failing control plane component by checking its static pod manifest in `/etc/kubernetes/manifests` and its logs. Troubleshoot a failing `kubelet` on a worker node.

---

#### **Week 3: CKAD Focus & Full-Scale Practice**

This week focuses on application-centric patterns and then transitions into intense, timed practice.

- **Day 15-16: Application Design & Observability**

  - **Topic:** Building robust, cloud-native applications.
  - **CKAD Focus:** Design multi-container Pods (e.g., a logging sidecar). Configure `livenessProbe`, `readinessProbe`, and `startupProbe` to manage pod health. Define resource `requests` and `limits` for CPU and memory.

- **Day 17: Helm & Deployment Strategies**

  - **Topic:** Application packaging and deployment.
  - **CKAD Focus:** While not a deep topic, understand how to use `helm` to install a basic chart. Understand the difference between `RollingUpdate` and `Recreate` deployment strategies. Perform a rolling update and a rollback (`k rollout history deployment/...`, `k rollout undo deployment/...`).

- **Day 18-21: Intense Timed Labs**
  - **Goal:** Simulate the exam environment perfectly. Use a timer for every task.
  - **Action:**
    1. Use an exam simulator like Killer.sh (often included with CNCF exam registration) or other popular online platforms. These are designed to be harder than the real exam.
    2. Work through the complex lab ideas below. Break your cluster on purpose and fix it.
    3. Do not use any tool or website other than the official Kubernetes documentation.
    4. For each problem, force yourself to start with `k create --dry-run=client -o yaml`.

---

### Complex Hands-On Lab Ideas (Tougher than the Exam)

These scenarios require you to synthesize knowledge from multiple domains to solve a single problem.

#### Lab 1: The Multi-Layer Security Lockdown

- **Scenario:** You have a three-tier application: `frontend`, `api-service`, and `database`. A new security mandate requires complete network and access control segmentation.
- **Task:**
  1. Create three `ServiceAccounts`: `frontend-sa`, `api-sa`, and `db-sa`.
  2. Create a `Role` for the `api-sa` that only allows it to `get` and `list` secrets within its namespace.
  3. Create a `ClusterRole` that allows read-only access to nodes (`get`, `list`, `watch`) and bind it to a new user named `auditor`.
  4. Implement `NetworkPolicies` to enforce the following rules:
     - `frontend` pods can only send egress traffic to `api-service` pods on port 8080.
     - `api-service` pods can accept ingress traffic from `frontend` pods and send egress traffic to `database` pods on port 5432.
     - `database` pods can only accept ingress traffic from `api-service` pods.
     - No other traffic is allowed. Deny all by default.
- **Concepts Tested:** RBAC (`ServiceAccount`, `Role`, `ClusterRole`, `Bindings`), `NetworkPolicy`, Labels/Selectors, `kubectl auth can-i`.

#### Lab 2: The "Etcd Restore" and Cluster Upgrade Emergency

- **Scenario:** Your `etcd` database is corrupted. You have a backup snapshot located at `/opt/etcd-backup.db` on your control plane node. After restoring the cluster, you must immediately upgrade it from version 1.29.0 to 1.29.1.
- **Task:**
  1. Stop the `kube-apiserver` static pod by moving its manifest out of `/etc/kubernetes/manifests/`.
  2. Perform an `etcd` restore using `etcdctl snapshot restore`, pointing the restored data to a new directory.
  3. Modify the `etcd` static pod manifest to use the new, restored data directory.
  4. Restart the control plane components and verify the cluster is back to its pre-backup state.
  5. Once restored, perform a standard `kubeadm` upgrade on the control plane and one worker node.
- **Concepts Tested:** `etcdctl`, `kubeadm upgrade`, managing static pods, cluster troubleshooting, node maintenance (`drain`, `uncordon`).

#### Lab 3: The Tainted Node Scheduling Puzzle

- **Scenario:** You have a 3-node cluster. One node (`node01`) has a powerful GPU and should only run data science workloads. Another node (`node03`) is reserved for infrastructure pods only.
- **Task:**
  1. Apply a `Taint` to `node01` with the effect `NoSchedule` (e.g., `gpu=true:NoSchedule`).
  2. Deploy a pod with the appropriate `Toleration` to run on `node01`.
  3. Apply a `Taint` to `node03` with the effect `NoExecute` (e.g., `infra-only=true:NoExecute`).
  4. Create a `DaemonSet` for logging agents that must run on all nodes, including the tainted ones. Ensure it has the correct tolerations.
  5. Deploy a critical application that must run on a node with SSD storage (`disk=ssd`). Use `Node Affinity` (not `nodeSelector`) to schedule it, ensuring it is a _required_ affinity. Label one of your nodes with `disk=ssd` to test this.
- **Concepts Tested:** `Taints`, `Tolerations`, `Node Affinity` (requiredDuringSchedulingIgnoredDuringExecution), `DaemonSets`, `Labels`.

#### Lab 4: The Sidecar Injection and Debugging Failure

- **Scenario:** You have a legacy application container that writes logs to a file (`/var/log/app.log`) instead of `stdout`. You need to ship these logs to a central collector. The application is also known to crash silently.
- **Task:**
  1. Create a `Deployment` for the application.
  2. Modify the `Pod` spec to include a `sidecar` container (e.g., using `busybox`) that reads the log file and streams it to its own `stdout`.
  3. Use a shared `emptyDir` volume so both containers can access the log file.
  4. Configure a `livenessProbe` for the main application container that executes a command to check if the app's process is still running (`ps aux | grep myapp`).
  5. Configure a `readinessProbe` that checks if the application is ready to serve traffic by making an HTTP request to `localhost:8080/healthz`.
- **Concepts Tested:** Multi-container pods (sidecar pattern), shared volumes (`emptyDir`), `livenessProbe` (`exec`), `readinessProbe` (`httpGet`), advanced pod design.

Good luck with your preparation. This intense schedule will be challenging, but by focusing on these hands-on, complex scenarios, you will be more than ready for the exam environment.
