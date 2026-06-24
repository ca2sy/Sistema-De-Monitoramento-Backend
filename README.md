# Sistema de Monitoramento — Back-End

Protótipo de API REST para gerenciamento de processos/aquisições, responsável pelas regras de negócio, persistência de dados e geração dos indicadores exibidos no dashboard.

## ✨ Funcionalidades

- **CRUD de processos** — cadastro, listagem, cancelamento e exclusão.
- **Checklist de etapas** — controle de subetapas concluídas por processo, com data de conclusão.
- **Dashboard agregado** — endpoint único que retorna totais, valores, distribuição por status, tipo e categoria, além de evolução mensal de criação dos processos.
- **Tabelas de apoio** — gerenciamento de entidades auxiliares (status, tipos, categorias) usadas para classificar os processos.
- **Modelagem relacional** — projetos, tipos de aquisição, etapas e subetapas organizados hierarquicamente via Prisma ORM.

## 🛠️ Tecnologias

- [Node.js](https://nodejs.org/) + [Express](https://expressjs.com/) 5
- [Prisma ORM](https://www.prisma.io/) 7
- [PostgreSQL](https://www.postgresql.org/)
- [CORS](https://www.npmjs.com/package/cors) / [dotenv](https://www.npmjs.com/package/dotenv)

## 📁 Estrutura do projeto

```
.
├── index.js                  # Entry point da API
├── prismaClient.js           # Instância do Prisma Client
├── prisma/
│   ├── schema.prisma         # Modelagem das entidades
│   └── migrations/           # Histórico de migrações
├── routes/
│   ├── aquisicoesRoutes.js
│   ├── dashboardRoutes.js
│   ├── projetosRoutes.js
│   └── tabelasApoioRoutes.js
└── services/
    └── aquisicoesService.js  # Regras de negócio das aquisições
```

## 🗄️ Modelagem de dados

O domínio é estruturado em torno de:

- **Projeto** → agrupa diferentes **tipos de aquisição**
- **Tipo de aquisição** → composto por **etapas**, que por sua vez se dividem em **subetapas**
- **Aquisição** → instância concreta vinculada a um projeto, tipo, etapa, status e categoria, com checklist de subetapas concluídas

Essa modelagem permite acompanhar o progresso de cada processo de forma granular, etapa por etapa.

## 🚀 Como rodar localmente

```bash
# Clone o repositório
git clone https://github.com/ca2sy/Sistema-De-Monitoramento-Backend.git
cd Sistema-De-Monitoramento-Backend

# Instale as dependências
npm install

# Configure o .env com a string de conexão do PostgreSQL
# DATABASE_URL="postgresql://usuario:senha@localhost:5432/nome_do_banco"

# Execute as migrações
npx prisma migrate deploy

# Inicie o servidor
npm run dev
```

A API estará disponível em `http://localhost:3001` (ou na porta configurada).

> Este back-end serve dados para o [Sistema de Monitoramento — Front-End](https://github.com/ca2sy/Sistema-De-Monitoramento-FrontEnd).

## 📡 Principais endpoints

| Método | Rota | Descrição |
|---|---|---|
| `GET` | `/aquisicoes` | Lista todos os processos |
| `POST` | `/aquisicoes` | Cadastra um novo processo |
| `DELETE` | `/aquisicoes/:codigo` | Remove um processo |
| `PATCH` | `/aquisicoes/:codigo/checklist/:subEtapaId` | Marca/desmarca item do checklist |
| `PATCH` | `/aquisicoes/:codigo/cancelar` | Cancela um processo |
| `GET` | `/dashboard` | Retorna indicadores agregados |


