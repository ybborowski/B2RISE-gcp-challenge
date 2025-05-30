# GCP TypeScript API

## 🚀 Infraestrutura com Terraform

### Comandos para provisionamento:

```bash
cd terraform
terraform init
terraform apply -var="project_id=seu-projeto-id"
```

## 🌐 Deploy da API na VM

Acesse sua VM via SSH, clone o projeto e execute:

```bash
sudo apt update
sudo apt install -y nodejs npm git
git clone <repo-url>
cd api
npm install
npm run build
sudo npm start
```

Para rodar com PM2 (opcional):

```bash
npm install -g pm2
pm2 start dist/index.js
pm2 startup
pm2 save
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

### Endpoint

- `GET /consume` → Consome uma única mensagem do Pub/Sub e exibe no navegador.

### Como testar

Publique uma mensagem no tópico:

```bash
gcloud pubsub topics publish api-topic --message="Olá da CLI!"
```

Em seguida, acesse o endpoint:

```
http://<IP_DA_INSTANCIA>/consume
```

A primeira mensagem disponível será exibida.
