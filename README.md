# DEVOPPS API ATIVIDADE ITALO SANTOS

Projeto acadêmico para a disciplina de **DevOps**, com foco na **Configuração de Ambiente Multi-Container** usando FastAPI e PostgreSQL em Docker. Este README descreve passo a passo como criar o ambiente, construir a imagem e rodar a aplicação no Windows PowerShell, incluindo instruções de troubleshooting.

---

## Visão Geral do Projeto

A atividade consiste em:

1. **Criação do Dockerfile**
   - Desenvolver um Dockerfile para a aplicação FastAPI, utilizando uma imagem base adequada (Python 3.11-slim).

2. **Definição do Docker Compose**
   - Configurar dois serviços:  
     - `api`: aplicação FastAPI + Uvicorn  
     - `db`: banco de dados PostgreSQL  

3. **Configuração de Volumes**
   - Garantir persistência dos dados do banco configurando volumes no Docker Compose.

4. **Criação de Rede Customizada**
   - Criar uma rede isolada para permitir comunicação entre containers sem expor portas desnecessárias.

5. **Utilização de Variáveis de Ambiente**
   - Configurar credenciais, URLs do banco e outras informações sensíveis via `.env`.


---

## Pré-requisitos

- Docker e Docker Compose instalados e em execução no Windows.
- PowerShell para execução dos comandos abaixo.

Verifique as versões mínimas (opcional):

```powershell
docker --version
docker-compose --version
```

---

## Arquivos Importantes

- `docker-compose.yml` — define serviços, rede e volumes.  
- `app/Dockerfile` — imagem da API.  
- `app/wait-for-db.sh` — aguarda o banco e cria usuário/permissões.  
- `app/.env` — variáveis de ambiente (não comitar; usar `.env.example` como referência).  

---

## Criando o Arquivo de Ambiente (`.env`)

Na raiz do projeto (mesmo nível do `docker-compose.yml`), crie o arquivo `.env`:

```powershell
# .env (NÃO comitar senhas reais em repositórios públicos)
POSTGRES_USER=postgres
POSTGRES_PASSWORD=devoops123
POSTGRES_DB=devoopsdb
POSTGRES_HOST=db
POSTGRES_PORT=5432

APP_DB_USER=devops
APP_DB_PASSWORD=italo3040
APP_DB_NAME=devoopsdb

# URL usada pelo SQLAlchemy (opcional)
DATABASE_URL=postgresql+psycopg2://postgres:devoops123@db:5432/devoopsdb
```

**Observações:**  
- Mantenha este arquivo seguro.  
- Use `.env.example` como modelo se disponível.  

---

## Rodando a Aplicação (PowerShell)

1. **Subir os serviços com logs no terminal:**

```powershell
docker-compose up --build
```

2. **Rodar em background (detached) e seguir logs da API:**

```powershell
docker-compose up --build -d
docker-compose logs -f api
```

3. **Parar e remover containers e volumes (para resetar o banco):**

```powershell
docker-compose down -v
```

4. **Resolvendo conflitos de porta:**

```powershell
docker ps -a
netstat -ano | findstr :8000
# remover container que estiver usando a porta:
docker rm -f <nome_ou_id_do_container>
```

---

## Testando a API

- **Swagger UI:** [http://localhost:8000/docs](http://localhost:8000/docs)  
- **Curl / PowerShell:**  

```powershell
Invoke-WebRequest -Uri http://localhost:8000/ -UseBasicParsing | Select-Object -ExpandProperty Content
```

---

## Sobre o Script `wait-for-db.sh`

- Aguarda o PostgreSQL ficar pronto (`pg_isready`).  
- Cria usuário da aplicação e aplica permissões usando `psql` via TCP (`--host db --port 5432`).  
- Necessário para evitar erros de socket local dentro do container da API.

---

## Comandos Úteis de Debug

**Entrar no container da API:**

```powershell
docker exec -it devoops_api /bin/sh
psql --host db --port 5432 --username "$POSTGRES_USER" -c '\l'
```

**Ver logs do Postgres:**

```powershell
docker logs -f devoops_postgres
```

---

## Resetando o Banco

```powershell
docker-compose down -v
docker-compose up --build
```


