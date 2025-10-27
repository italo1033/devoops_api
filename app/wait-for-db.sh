#!/bin/sh
set -e

# usage: ./wait-for-db.sh <host> -- <command to run when ready>
host="$1"
shift

if [ -z "$host" ]; then
  echo "Uso: $0 <host> -- <comando>"
  exit 1
fi

echo "Aguardando PostgreSQL em $host..."

# Espera o PostgreSQL ficar pronto
if [ -n "${POSTGRES_USER:-}" ]; then
  until pg_isready -h "$host" -U "$POSTGRES_USER" > /dev/null 2>&1; do
    echo "PostgreSQL ainda não está pronto. Tentando novamente em 2 segundos..."
    sleep 2
  done
else
  until pg_isready -h "$host" > /dev/null 2>&1; do
    echo "PostgreSQL ainda não está pronto. Tentando novamente em 2 segundos..."
    sleep 2
  done
fi

echo "PostgreSQL está pronto!"

# Configurações do usuário da aplicação (variáveis de ambiente)
# Primeiro tenta as variáveis específicas da aplicação (APP_DB_*),
# se não estiverem definidas, usa as variáveis do Postgres (POSTGRES_*)
# e por fim um valor padrão.
DB_USER=${APP_DB_USER:-${POSTGRES_USER:-devops}}
DB_PASSWORD=${APP_DB_PASSWORD:-${POSTGRES_PASSWORD:-}}
DB_NAME=${APP_DB_NAME:-${POSTGRES_DB:-devoopsdb}}

echo "Executando inicialização do banco (init-db.sh)..."

if [ -x "/app/init-db.sh" ]; then
  # passa o host para que init-db saiba onde conectar
  /app/init-db.sh "$host"
else
  echo "Aviso: /app/init-db.sh não encontrado ou não executável — pulando etapa de inicialização do DB."
fi

exec "$@"
