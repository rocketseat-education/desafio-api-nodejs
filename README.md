# Desafio Node.js – Primeira API (aulas)

API simples em Node.js + TypeScript usando Fastify, Drizzle ORM (PostgreSQL) e Zod. Inclui documentação Swagger/Scalar em ambiente de desenvolvimento.

## Requisitos
- Node.js 22+
- Docker e Docker Compose
- npm (ou outro gerenciador, mas o projeto usa `package-lock.json`)

## Tecnologias
- Fastify 5
- TypeScript
- Drizzle ORM + PostgreSQL
- Zod (validação)
- Swagger/OpenAPI + Scalar API Reference (em `/docs` quando `NODE_ENV=development`)

## Configuração
1. Clone o repositório e acesse a pasta do projeto.
2. Instale as dependências:
```bash
npm install
```
3. Suba o banco Postgres com Docker:
```bash
docker compose up -d
```
4. Crie um arquivo `.env` na raiz com:
```bash
# URL do banco (Docker local padrão)
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/desafio

# Ativa docs em /docs
NODE_ENV=development
```
5. Rode as migrações (Drizzle):
```bash
npm run db:migrate
```
(opcional) Para inspecionar o schema/estado com o Drizzle Studio:
```bash
npm run db:studio
```

## Executando o servidor
```bash
npm run dev
```
- Porta padrão: `http://localhost:3333`
- Logs legíveis habilitados
- Documentação da API (em dev): `http://localhost:3333/docs`

## Endpoints
Base URL: `http://localhost:3333`

- POST `/courses`
  - Cria um curso
  - Body (JSON):
    ```json
    { "title": "Curso de Docker" }
    ```
  - Respostas:
    - 201: `{ "courseId": "<uuid>" }`

- GET `/courses`
  - Lista todos os cursos
  - 200: `{ "courses": [{ "id": "<uuid>", "title": "..." }] }`

- GET `/courses/:id`
  - Busca um curso pelo ID
  - Parâmetros: `id` (UUID)
  - Respostas:
    - 200: `{ "course": { "id": "<uuid>", "title": "...", "description": "... | null" } }`
    - 404: vazio

Há um arquivo `requisicoes.http` com exemplos prontos (compatível com extensões de REST Client).

## Modelos (schema)
Tabelas principais definidas em `src/database/schema.ts`:
- `courses`
  - `id` (uuid, pk, default random)
  - `title` (text, único, obrigatório)
  - `description` (text, opcional)
- `users` (exemplo para estudos)
  - `id` (uuid, pk, default random)
  - `name` (text, obrigatório)
  - `email` (text, único, obrigatório)

## Fluxo principal (Mermaid)

```mermaid
sequenceDiagram
  participant C as Client
  participant S as Fastify Server
  participant V as Zod Validator
  participant DB as Drizzle + PostgreSQL

  C->>S: POST /courses {title}
  S->>V: Validar body
  V-->>S: OK ou Erro 400
  alt válido
    S->>DB: INSERT INTO courses (title)
    DB-->>S: {id}
    S-->>C: 201 {courseId}
  else inválido
    S-->>C: 400
  end

  C->>S: GET /courses
  S->>DB: SELECT id,title FROM courses
  DB-->>S: lista
  S-->>C: 200 {courses: [...]} 

  C->>S: GET /courses/:id
  S->>V: Validar param id (uuid)
  V-->>S: OK ou Erro 400
  alt encontrado
    S->>DB: SELECT * FROM courses WHERE id=...
    DB-->>S: course
    S-->>C: 200 {course}
  else não encontrado
    S-->>C: 404
  end
```

## Scripts
- `npm run dev`: inicia o servidor com reload e carrega variáveis de `.env`
- `npm run db:generate`: gera artefatos do Drizzle a partir do schema
- `npm run db:migrate`: aplica migrações no banco
- `npm run db:studio`: abre o Drizzle Studio

## Dicas e solução de problemas
- Conexão recusada ao Postgres: confirme `docker compose up -d` e que a porta `5432` não está em uso.
- Variável `DATABASE_URL` ausente: verifique seu `.env`. O Drizzle exige essa variável para `db:generate`, `db:migrate` e `db:studio`.
- Docs não aparecem em `/docs`: garanta `NODE_ENV=development` no `.env` e reinicie o servidor.

## Licença
ISC (ver `package.json`).
