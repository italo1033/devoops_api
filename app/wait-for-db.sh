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

# Se a variável POSTGRES_USER existir, passe -U, caso contrário omita o parametro
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

echo "PostgreSQL está pronto! Iniciando aplicação..."
exec "$@"
