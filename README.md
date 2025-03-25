# Azure Login
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