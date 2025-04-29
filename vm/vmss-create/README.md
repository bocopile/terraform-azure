# Azure VMSS + NAT Pool + Rolling Update Terraform 구성

## 📦 프로젝트 구조
```bash
/terraform
  ├── main.tf                    # Provider 설정, Resource Group 생성
  ├── variables.tf                # 변수 정의 파일
  ├── outputs.tf                  # Output 정의 파일 (예: LB Public IP 출력)
  ├── compute.tf                  # VMSS 리소스 (Rolling Update 정책 적용)
  ├── network.tf                  # VNet, Subnet, NSG 리소스
  ├── lb.tf                       # Load Balancer 및 NAT Pool 설정
  ├── storage.tf                  # Azure Files 스토리지 (공유 디렉토리용) 생성
  ├── autoscale.tf                # AutoScale 설정 (CPU 기준 자동 스케일링)
  ├── scripts/
  │    └── startup-script.sh      # 부팅 시 /log 공유 디렉토리 마운트 스크립트
```

---

## 🔧 주요 파일 설명

| 파일 | 설명 |
|:---|:---|
| `main.tf` | Provider 설정, 기본 Resource Group 생성 |
| `variables.tf` | 리소스 이름, 리전, 이미지 버전 등 변수 관리 |
| `outputs.tf` | 배포 결과 출력 (예: LB Public IP) |
| `compute.tf` | VMSS 생성, Rolling Upgrade 정책 설정 |
| `network.tf` | VNet/Subnet/NSG 구성 |
| `lb.tf` | Load Balancer 설정, NAT Pool (SSH용) 설정 |
| `storage.tf` | Azure Storage Account 및 File Share 생성 |
| `autoscale.tf` | VMSS AutoScale 정책 (CPU 80% 초과 시 Scale-Out) |
| `scripts/startup-script.sh` | Azure Files를 /log 경로에 마운트하는 스크립트 |

---

## 🛠 핵심 리소스 설명

### VMSS (compute.tf)

- `upgrade_mode = "Automatic"` 설정
- `rolling_upgrade_policy` 적용:
    - `max_batch_instance_percent = 50`
    - `max_unhealthy_instance_percent = 50`
    - `max_unhealthy_upgraded_instance_percent = 20`
    - `pause_time_between_batches = "PT2M"`

### Load Balancer + NAT Pool (lb.tf)

- Load Balancer Standard SKU 사용
- NAT Pool 설정:
    - `frontend_port_start = 50000`
    - `frontend_port_end = 50009` (10개 포트 확보)
- Backend Pool에 VMSS 인스턴스 자동 연결

### Azure Files (storage.tf)

- Storage Account (Standard_LRS) 생성
- File Share `/logshare` 생성
- VM 부팅 시 `/log` 경로로 마운트

### AutoScale (autoscale.tf)

- CPU 사용량 80% 초과 시 인스턴스 1개 추가
- CPU 사용량 10% 이하 시 인스턴스 1개 감소
- 최소 3개, 최대 5개 인스턴스 유지

---

## 🚀 Terraform 적용 순서

1. Terraform 초기화
    ```bash
    terraform init
    ```
2. Terraform Plan (변경사항 확인)
    ```bash
    terraform plan
    ```
3. Terraform Apply (배포 진행)
    ```bash
    terraform apply
    ```

---

## 🎯 주의사항

- **NAT Pool 포트 수는** Scale Out/Upgrade 중 생길 임시 인스턴스까지 고려해 충분히 확보해야 함
- **Rolling Upgrade는** 인프라 최초 배포 시 적용되지 않고, 이미지 변경 등 수정 작업 시에만 적용된다
- **Azure Files를 사용해** 모든 VM이 `/log` 공유 디렉토리를 사용할 수 있도록 구성
- **Terraform State Drift** 방지를 위해 Azure Portal에서 수동 수정 금지

---

## 🧩 추가 추천 개선

- Azure Storage SAS 토큰 사용하여 보안 강화
- Azure Monitor로 VMSS 헬스 상태 모니터링 추가
- Scale-In Protection 옵션 적용 (인스턴스 임의 삭제 방지)

---