# Process Monitoring System — Backend

REST API responsible for process and acquisition management, business rules, data persistence, and dashboard metrics generation.

## ✨ Features

* **Process CRUD Operations** — Create, list, cancel, and delete processes.
* **Stage Checklist Tracking** — Manage completed sub-stages for each process, including completion dates.
* **Aggregated Dashboard Metrics** — Single endpoint providing totals, values, distributions by status, type, category, and monthly creation trends.
* **Reference Data Management** — Support tables for statuses, acquisition types, and categories.
* **Relational Data Modeling** — Projects, acquisition types, stages, and sub-stages organized hierarchically using Prisma ORM.

## 🛠️ Technologies

* Node.js
* Express 5
* Prisma ORM 7
* PostgreSQL
* CORS
* dotenv

## 📁 Project Structure

```text
.
├── index.js                  # API entry point
├── prismaClient.js           # Prisma Client instance
├── prisma/
│   ├── schema.prisma         # Database schema
│   └── migrations/           # Migration history
├── routes/
│   ├── aquisicoesRoutes.js
│   ├── dashboardRoutes.js
│   ├── projetosRoutes.js
│   └── tabelasApoioRoutes.js
└── services/
    └── aquisicoesService.js  # Business logic
```

## 🗄️ Data Model

The domain is structured around:

* **Project** → groups multiple acquisition types
* **Acquisition Type** → composed of stages, which are further divided into sub-stages
* **Process (Acquisition)** → a concrete instance linked to a project, acquisition type, stage, status, and category, while maintaining its own completed checklist items

This structure enables detailed process tracking at every stage of execution.

## 🚀 Running Locally

```bash
# Clone the repository
git clone https://github.com/ca2sy/Sistema-De-Monitoramento-Backend.git

cd Sistema-De-Monitoramento-Backend

# Install dependencies
npm install

# Configure the .env file
# DATABASE_URL="postgresql://user:password@localhost:5432/database_name"

# Run migrations
npx prisma migrate deploy

# Start the server
npm run dev
```

The API will be available at `http://localhost:3001` (or the configured port).

> This backend provides data for the Process Monitoring System frontend.

## 📡 Main Endpoints

| Method | Endpoint                                  | Description                |
| ------ | ----------------------------------------- | -------------------------- |
| GET    | /aquisicoes                               | Retrieve all processes     |
| POST   | /aquisicoes                               | Create a new process       |
| DELETE | /aquisicoes/:codigo                       | Delete a process           |
| PATCH  | /aquisicoes/:codigo/checklist/:subEtapaId | Toggle a checklist item    |
| PATCH  | /aquisicoes/:codigo/cancelar              | Cancel a process           |
| GET    | /dashboard                                | Retrieve dashboard metrics |

## 📌 Status

Personal project under active development, created for learning purposes and full-stack software engineering practice.
