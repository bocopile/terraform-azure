# aks 구조

```shell
terraform-aks/
├── main.tf                       # Azure Provider, AKS 클러스터 생성, helm 모듈 호출
├── main.tf                       # kube_config 출력
├── variables.tf                  # 변수 정의 (예: location, cluster_name 등)
├── helm/                         # Helm 모듈로 정의된 디렉토리
│   ├── main.tf                   # Helm provider 설정 + Helm 리소스 (nginx, cert-manager, argocd 등)
│   ├── variables.tf              # helm 모듈에서 사용할 변수 정의 (kube_config, cluster_name 등)
│   ├── argocd.tf                 # argocd 추가
│   ├── cert-manager.tf           # cert-manager 추가
│   ├── ingress-nginx.tf          # ingress 추가
│   ├── ingress-nginx.tf          # istio 추가
│   ├── prometheus-grafana.tf     # prometheus, grafana
│   ├── variables.tf              # helm 모듈에서 사용할 변수 정의 (kube_config, cluster_name 등)
│   ├── manifests/                # YAML 리소스 수동 적용용 (예: cert-manager용 ClusterIssuer)
│   │   └── cluster-issuer.yaml   # Let's Encrypt HTTP01 방식 ClusterIssuer
│   ├── values/                   # Helm values.yaml 설정 파일 디렉토리
│   │   ├── argocd-values.yaml       # ArgoCD Helm values (Ingress + TLS 설정 포함)
│   │   ├── prometheus-values.yaml  # Prometheus & Grafana values (Ingress + TLS + Dashboard)
│   │   └── kiali-values.yaml       # Kiali + Jaeger values (Ingress + TLS 설정 포함)

```




---

## ✅ 구성 요소 설명

| 디렉토리 / 파일                     | 설명 |
|----------------------------------|------|
| `main.tf`                        | AKS 클러스터와 기본 인프라 정의 (v1.32.2, autoscaler 포함) |
| `terraform.tfvars`               | subscription_id 등 민감 정보 별도 관리 |
| `helm/ingress-nginx.tf`          | Ingress Controller(NGINX) 설치 |
| `helm/cert-manager.tf`           | cert-manager 설치 및 CRDs 등록 |
| `helm/manifests/cluster-issuer.yaml` | Let's Encrypt ACME 방식의 ClusterIssuer 정의 |
| `helm/argocd.tf`                 | ArgoCD 설치 및 `argocd.bocopile.io` TLS 적용 |
| `helm/prometheus-grafana.tf`     | Prometheus + Grafana 설치 및 TLS, 대시보드 구성 |
| `helm/istio-tools.tf`            | Kiali, Jaeger 설치 및 각 도메인 TLS 설정 |
| `helm/values/*.yaml`             | Helm Values 정의 (Ingress + TLS 포함) |

---

## 🌐 할당 도메인 예시

| 서비스      | 도메인                     |
|-----------|--------------------------|
| Grafana   | `grafana.bocopile.io`    |
| Prometheus| `prometheus.bocopile.io` |
| ArgoCD    | `argocd.bocopile.io`     |
| Kiali     | `kiali.bocopile.io`      |
| Jaeger    | `jaeger.bocopile.io`     |

---




# 작업 절차

## 권한 부여
```shell
# 현재 권한 확인
echo $ARM_CLIENT_ID
```
## 초기화
```shell
terraform init
```
## 구성 확인
```shell
terraform plan
```

## 리소스 그룹 및 DNS Zone 우선 생성
```shell
terraform apply -target=azurerm_resource_group.aks_rg -target=azurerm_dns_zone.main
```

## 클러스터 생성
```shell
terraform apply -auto-approve
```

## 클러스터 접속
```shell
az aks get-credentials --resource-group rg-aks-bocopile --name aks-bocopile-cluster
kubectl get nodes
```


## helm 배포 확인
```shell
kubectl get ingress -n monitoring
kubectl get certificate -A
kubectl describe certificate grafana-tls -n monitoring
kubectl get ingress -A
```


# 삭제
```shell
terraform destroy -auto-approve
rm -rf ~/.kube/config
```