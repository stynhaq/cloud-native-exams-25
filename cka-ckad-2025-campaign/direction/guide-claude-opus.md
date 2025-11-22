# 3-Week Combined CKA/CKAD Intensive Study Plan

## Your Lab Environment Setup

Your 3-node kubeadm cluster is perfect for this preparation. Here's the recommended setup:

### Cluster Configuration

- **Control Plane**: 1 node (2 CPU, 4GB RAM minimum)
- **Worker Nodes**: 2 nodes (2 CPU, 2GB RAM each)
- **Kubernetes Version**: Use the exam version (currently 1.31.x)
- **CNI**: Calico or Flannel
- **Additional Tools**: Install metrics-server, ingress-nginx controller

## Week 1: Core Fundamentals & Cluster Administration

### Days 1-2: Cluster Architecture & Installation (CKA Focus)

**Study Topics:**

- Cluster components deep dive (etcd, kube-apiserver, scheduler, controller-manager)
- kubeadm cluster setup, upgrades, and backup/restore
- High availability configurations
- Certificate management with kubeadm

**Complex Lab Exercises:**

1. **Multi-Master HA Setup Challenge**

   - Create a 3-master node HA cluster with external etcd
   - Implement automatic failover testing
   - Perform rolling upgrade from v1.30.x to v1.31.x while maintaining zero downtime

2. **Disaster Recovery Simulation**
   - Corrupt etcd data deliberately and recover
   - Lose a master node and recover cluster state
   - Backup etcd with encryption and restore to a new cluster

### Days 3-4: Workload Management & Scheduling

**Study Topics:**

- Advanced pod scheduling (node affinity, pod affinity/anti-affinity, taints, tolerations)
- Resource management (requests, limits, QoS classes)
- DaemonSets, StatefulSets, Jobs, CronJobs
- Pod disruption budgets

**Complex Lab Exercises:**

1. **Advanced Scheduling Orchestration**

   - Deploy a multi-tier application with complex inter-pod affinity rules
   - Implement pod topology spread constraints across zones
   - Create a custom scheduler and use it for specific workloads

2. **Resource Management Challenge**
   - Set up a namespace with ResourceQuotas and LimitRanges
   - Deploy applications that deliberately exceed limits and handle the failures
   - Implement VPA and HPA simultaneously for the same application

### Days 5-7: Networking Deep Dive

**Study Topics:**

- CNI internals and troubleshooting
- Services (ClusterIP, NodePort, LoadBalancer, ExternalName)
- Ingress controllers and rules
- Network Policies (ingress/egress)
- CoreDNS configuration

**Complex Lab Exercises:**

1. **Multi-Tenant Network Isolation**

   - Create 3 namespaces representing different teams
   - Implement zero-trust networking with default deny-all policies
   - Allow specific inter-namespace communication patterns
   - Debug DNS resolution issues between namespaces

2. **Advanced Ingress Routing**
   - Deploy 3 different applications with path-based and host-based routing
   - Implement SSL/TLS termination with cert-manager
   - Configure rate limiting and authentication at ingress level
   - Set up canary deployments using ingress weights

## Week 2: Security, Storage & Advanced Workloads

### Days 8-9: Security Hardening

**Study Topics:**

- RBAC (Roles, ClusterRoles, Bindings)
- Service Accounts and token management
- Security Contexts and Pod Security Standards
- Admission controllers (ValidatingAdmissionWebhooks, MutatingAdmissionWebhooks)
- Secrets and ConfigMap management
- Image security scanning

**Complex Lab Exercises:**

1. **Multi-Tenant RBAC Implementation**

   - Create 5 different user personas with varying permissions
   - Implement custom ClusterRoles with aggregation
   - Set up audit logging and analyze security events
   - Create a ValidatingAdmissionWebhook that enforces custom policies

2. **Pod Security Standards Challenge**
   - Migrate from PSP to Pod Security Standards
   - Implement restricted security context across namespaces
   - Deploy privileged workloads with proper exceptions
   - Use OPA Gatekeeper for policy enforcement

### Days 10-11: Storage Architecture

**Study Topics:**

- Persistent Volumes and Claims
- Storage Classes and dynamic provisioning
- Volume snapshots and cloning
- CSI drivers
- StatefulSet storage patterns

**Complex Lab Exercises:**

1. **Stateful Application Migration**

   - Deploy a MongoDB replica set with persistent storage
   - Perform storage migration between different StorageClasses
   - Implement backup and restore using volume snapshots
   - Simulate node failure and verify data persistence

2. **Multi-Attach Storage Scenario**
   - Configure NFS provisioner for RWX volumes
   - Deploy a shared file system for multiple pods
   - Implement storage quotas and monitoring
   - Handle storage failover scenarios

### Days 12-14: Observability & Troubleshooting

**Study Topics:**

- Metrics Server and monitoring
- Logging architecture (node, pod, cluster level)
- Debugging techniques (kubectl debug, ephemeral containers)
- Performance tuning
- Cluster maintenance

**Complex Lab Exercises:**

1. **Production Incident Simulation**

   - Create 10 different failure scenarios:
     - OOMKilled pods with memory leak simulation
     - CrashLoopBackOff with init container failures
     - ImagePullBackOff with private registry issues
     - Network partition between nodes
     - Disk pressure on nodes
     - API server performance degradation
     - etcd split-brain scenario
     - DNS resolution failures
     - Certificate expiration
     - Kernel panic simulation

2. **Observability Pipeline**
   - Deploy Prometheus and Grafana
   - Create custom metrics and alerts
   - Implement distributed tracing
   - Set up centralized logging with Fluentd

## Week 3: Advanced Patterns & Exam Preparation

### Days 15-16: Application Deployment Patterns (CKAD Focus)

**Study Topics:**

- Blue-Green deployments
- Canary deployments
- Rolling updates with rollback
- Helm charts and Kustomize
- GitOps patterns

**Complex Lab Exercises:**

1. **Zero-Downtime Deployment Pipeline**

   - Implement blue-green deployment with traffic switching
   - Create canary deployment with automated rollback on failures
   - Use Flagger for progressive delivery
   - Implement feature flags with ConfigMaps

2. **Multi-Environment Configuration**
   - Use Kustomize to manage dev/staging/prod configurations
   - Implement sealed-secrets for sensitive data
   - Create a Helm chart with complex dependencies
   - Deploy using ArgoCD for GitOps

### Days 17-18: Service Mesh & Advanced Networking

**Study Topics:**

- Service mesh concepts
- mTLS between services
- Circuit breakers and retries
- Traffic management

**Complex Lab Exercises:**

1. **Microservices Communication**
   - Deploy a 5-service microservices application
   - Implement service discovery patterns
   - Add circuit breakers for resilience
   - Implement distributed tracing

### Days 19-20: Mock Exam Scenarios

**Complex Exam-Style Challenges:**

1. **CKA Scenario: "Production Crisis"** (2 hours)

   - Cluster has multiple issues: fix in order of priority
   - etcd backup is corrupted - recover from older backup
   - Master node certificates expired
   - Worker node not joining cluster
   - Critical pod not scheduling due to taints
   - NetworkPolicy blocking legitimate traffic
   - Upgrade cluster with zero downtime

2. **CKAD Scenario: "Application Marathon"** (2 hours)
   - Deploy 15 different applications with specific requirements
   - Implement auto-scaling for 3 applications
   - Create NetworkPolicies for multi-tier app
   - Debug and fix 5 broken deployments
   - Implement canary deployment
   - Create Jobs and CronJobs with specific parallelism

### Day 21: Final Review & Speed Drills

**Speed Challenges:**

- Create 20 different resource types in under 30 minutes
- Troubleshoot 10 common issues in 20 minutes
- Complete RBAC setup for 5 users in 15 minutes

## Critical Exam Tips

### Command Mastery

```bash
# Master these imperative commands
kubectl create deployment nginx --image=nginx --replicas=3 --dry-run=client -o yaml
kubectl set image deployment/nginx nginx=nginx:1.19
kubectl create configmap app-config --from-literal=key1=value1
kubectl create secret generic app-secret --from-literal=password=secret
kubectl expose deployment nginx --port=80 --type=NodePort
kubectl autoscale deployment nginx --min=2 --max=10 --cpu-percent=80
```

### Alias Setup (First thing in exam)

```bash
alias k=kubectl
alias kn='kubectl config set-context --current --namespace'
export do="--dry-run=client -o yaml"
export fg="--force --grace-period=0"
```

### Time Management Strategy

- **CKA**: 2 hours, ~15-17 questions (7-8 minutes per question average)
- **CKAD**: 2 hours, ~15-19 questions (6-7 minutes per question average)
- Skip questions taking >10 minutes, return later
- Use imperative commands when possible
- Copy from kubernetes.io/docs examples

## Daily Study Schedule

- **Hours 1-2**: Theory and documentation review
- **Hours 2-4**: Hands-on labs
- **Hour 5**: Mock questions and troubleshooting
- **Hour 6**: Review mistakes and documentation bookmarking

## Additional Resources

- Practice with killer.sh (included with exam registration)
- Use `kubectl explain` extensively
- Bookmark key documentation pages
- Join CKA/CKAD Slack communities for tips

Remember: The exams test speed and accuracy under pressure. Practice these complex scenarios, but during the exam, focus on completing tasks efficiently rather than perfectly. Good luck with your preparation!
