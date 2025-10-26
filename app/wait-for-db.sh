#!/bin/sh

set -e
host="$1"
shift

echo "Aguardando PostgreSQL em $host..."
until pg_isready -h "$host" -U postgres > /dev/null 2>&1; do
  echo "PostgreSQL ainda não está pronto. Tentando novamente em 2 segundos..."
  sleep 2
done

echo "PostgreSQL está pronto! Iniciando aplicação..."
exec "$@"
