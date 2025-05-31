# GCP TypeScript API

## 🚀 Infraestrutura com Terraform

### Comandos para provisionamento:

```bash
cd terraform
terraform init
terraform apply -var="project_id=seu-projeto-id"
```


## 📌 Endpoints

- `GET /` → `Olá do GCP com TypeScript e Express!`

## 📦 Estrutura

- `terraform/` → Infraestrutura GCP
- `api/` → Código da API com Express e TypeScript

## 🧾 Observações

Certifique-se de abrir a porta 80 na firewall para acesso HTTP.


## 🔔 Pub/Sub

Este projeto cria:

- **Tópico:** `api-topic`
- **Subscription:** `api-subscription`

### Endpoints

- `GET /produce?message=Olá via endpoint!` → Publica uma mensagem no topico que será recebida no /consume.
- `GET /consume` → Consome uma única mensagem do Pub/Sub e exibe no navegador.

### Como testar

Publique uma mensagem no tópico:

```endpoint
acesse o endpoint:
http://<IP_DA_INSTANCIA>/produce?message=Olá do Endpoint!

```

```bash
gcloud pubsub topics publish api-topic --message="Olá da CLI!"
```

Em seguida, acesse o endpoint:

```
http://<IP_DA_INSTANCIA>/consume
```

A primeira mensagem disponível será exibida.
