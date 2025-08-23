# 🚚 LogistiGO

**LogistiGO** is a multi-tenant SaaS platform for enterprises to assign, track, and optimize logistics tasks in real time.  
It combines a Rails backend, Go workers, React dashboard, React Native mobile app, SQL Server, Kafka, and AWS for a modern, distributed architecture.  

---

## ✨ Features (Phase 1 - MVP)
- Multi-tenant SaaS backend (Rails + SQL Server).
- Admin dashboard (React + Vite + TypeScript).
- Task management (CRUD for Companies, Users, and Tasks).
- Ready to scale with event-driven architecture (Kafka + Go workers).

---

## 🛠️ Tech Stack
- **Backend:** Ruby on Rails (API, SaaS logic, multi-tenant)
- **Frontend (Admin):** React + Vite + TypeScript
- **Mobile (Users):** React Native (tasks + GPS) *(Phase 2)*
- **Workers:** Go (background jobs, GPS processing, reporting)
- **Database:** SQL Server (via AWS RDS in production)
- **Messaging:** Kafka (via AWS MSK in production)
- **Infrastructure:** Docker / Docker Compose, AWS ECS Fargate
- **Maps/GPS:** AWS Location Service or Mapbox

---

## 📂 Project Structure
```
LogistiGO/
 ├── backend/        # Rails API
 ├── frontend/       # React Admin Dashboard
 ├── mobile/         # React Native App (later)
 ├── workers/        # Go services (Kafka consumers)
 ├── docker/         # Extra docker configs (if needed)
 ├── docker-compose.yml
 └── README.md
```

---

## 🚀 API Endpoints

API Documentation on Swagger UI:

👉 [http://localhost:3000/api-docs](http://localhost:3000/api-docs)

### Companies
- `GET /api/v1/companies` → Lista todas as empresas
- `POST /api/v1/companies` → Cria uma empresa
- `GET /api/v1/companies/{id}` → Mostra uma empresa
- `PUT /api/v1/companies/{id}` → Atualiza uma empresa
- `DELETE /api/v1/companies/{id}` → Apaga uma empresa

### Users
- `GET /api/v1/users` → Lista todos os utilizadores
- `POST /api/v1/users` → Cria um utilizador
- `GET /api/v1/users/{id}` → Mostra um utilizador
- `PUT /api/v1/users/{id}` → Atualiza um utilizador
- `DELETE /api/v1/users/{id}` → Apaga um utilizador

### Tasks
- `GET /api/v1/tasks` → Lista todas as tarefas
- `POST /api/v1/tasks` → Cria uma tarefa
- `GET /api/v1/tasks/{id}` → Mostra uma tarefa
- `PUT /api/v1/tasks/{id}` → Atualiza uma tarefa
- `DELETE /api/v1/tasks/{id}` → Apaga uma tarefa

## 🚀 Getting Started (Development)

### 🔹 Prerequisites
- [Git](https://git-scm.com/)
- [Rancher Desktop](https://rancherdesktop.io/) **or** [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Node.js LTS](https://nodejs.org/) (>= 20.x) – for React/React Native
- [Ruby](https://www.ruby-lang.org/) (>= 3.0, optional if you want to run Rails outside Docker)

---

### 🔹 Clone repository
```bash
git clone https://github.com/<your-username>/LogistiGO.git
cd LogistiGO
```

---

### 🔹 Start with Docker Compose
If you are using **Docker Desktop** or Rancher Desktop with **dockerd (moby)**:
```bash
docker-compose up --build
```

If you are using Rancher Desktop with **containerd** runtime:
```bash
nerdctl compose up --build
```

---

### 🔹 Services
- **Rails API** → http://localhost:3000  
- **React Frontend** → http://localhost:5173  
- **SQL Server** → port `1433`

---

## 📅 Roadmap
- **Phase 1 (MVP):** Rails + React + SQL Server basic CRUD
- **Phase 2:** React Native app (users + GPS tracking)
- **Phase 3:** Kafka integration + Go workers for real-time tracking
- **Phase 4:** Alerts, reporting, advanced features
- **Phase 5:** AWS deployment (ECS, RDS, MSK, Amplify, Cognito)

---

## 📜 License
MIT License. Feel free to use this project as inspiration for your own learning or portfolio.
