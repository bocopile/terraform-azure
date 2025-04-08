# 사전 준비사항
## Azure Login
1. Azure CLI 로그인
    - az login
2. Azure Subscription 설정
    - az account set --subscription "<subscription_id_or_subscription_name>"
3. Azure CLI Service Principal 생성
    - az ad sp create-for-rbac --name "terraform-sp" --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"

4. 생성후 정보 확인
    - 3번 명령어를 입력하면 다음과 같은 JSON 응답값이 나온다
      {
      "appId": "xxxxxxxxxxxx",
      "displayName": "terraform-sp",
      "password": "xxxxxxxxx",
      "tenant": "xxxxxxx"
      }
    - 여기서 해당 값을 기억할것
        - appId → client_id
        - password → client_secret
        - tenant → tenant_id

   5. 변수 선언
      ```bash
      cat << EOF >> ~/.zshrc

      export ARM_CLIENT_ID="$(az ad sp list --display-name "terraform-sp" --query "[].appId" -o tsv)"
      export ARM_CLIENT_SECRET="${password}"  # 해당 부분 수정 필요
      export ARM_TENANT_ID="$(az account show --query "tenantId" -o tsv)"
      export ARM_SUBSCRIPTION_ID="$(az account show --query id -o tsv)"
   
      EOF
      source ~/.zshrc
      echo $ARM_CLIENT_ID $ARM_CLIENT_SECRET $ARM_TENANT_ID $ARM_SUBSCRIPTION_ID
      tail -n 10 ~/.zshrc
       ```



## pub 생성
- 기존 Azure에서 VM 생성시 pem 파일을 이미 만들었을 경우 아래 절차대로 변경이 필요하다.
-  ssh-keygen -y -f /Users/bokhoshin/azure/bocopile-azure-key.pem > /Users/bokhoshin/azure/bocopile-azure-key.pub

# Terraform 실행

## Terraform 초기화
- terraform init

## 실행 계획 확인
- terraform plan

## 리소스 생성
- terraform apply -auto-approve

## 리소스 삭제 
- terraform destroy -auto-approveterraform destroy -auto-approve


# 프로젝트 설명
- vm-create : VM 생성 (신규 리소스)
- vm-create-exist-resource : VM 생성 (virtualNet, SubNet, Resource Group은 기존에 생성)
- vm-create-compute-gallary : VM OS image를 Azure compute Gallary에서 가져 와서 생



