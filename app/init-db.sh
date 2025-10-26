#!/bin/sh
set -e

# usage: ./init-db.sh <host>
host="$1"

if [ -z "$host" ]; then
  host="${POSTGRES_HOST:-db}"
fi

echo "Inicializando banco: conectando em $host..."

# Configurações do usuário da aplicação (variáveis de ambiente)
# Primeiro tenta as variáveis específicas da aplicação (APP_DB_*),
# se não estiverem definidas, usa as variáveis do Postgres (POSTGRES_*)
# e por fim um valor padrão.
DB_USER=${APP_DB_USER:-${POSTGRES_USER:-devops}}
DB_PASSWORD=${APP_DB_PASSWORD:-${POSTGRES_PASSWORD:-}} 
DB_NAME=${APP_DB_NAME:-${POSTGRES_DB:-devoopsdb}}

PGHOST="$host"
PGPORT="${POSTGRES_PORT:-5432}"

echo "Criando usuário '$DB_USER' e configurando permissões no banco '$DB_NAME'..."

# Export PGPASSWORD for non-interactive authentication
export PGPASSWORD="${POSTGRES_PASSWORD:-}"

psql -v ON_ERROR_STOP=1 --host "$PGHOST" --port "$PGPORT" --username "$POSTGRES_USER" <<-EOSQL
    -- Cria usuário se não existir
    DO
    \$do\$
    BEGIN
       IF NOT EXISTS (
          SELECT FROM pg_catalog.pg_roles WHERE rolname = '$DB_USER'
       ) THEN
          CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';
       END IF;
    END
    \$do\$;

    -- Concede permissões sobre o banco existente
    GRANT CONNECT ON DATABASE $DB_NAME TO $DB_USER;
    \c $DB_NAME
    GRANT USAGE, CREATE ON SCHEMA public TO $DB_USER;
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO $DB_USER;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO $DB_USER;
EOSQL

echo "Usuário '$DB_USER' criado e permissões aplicadas com sucesso!"

exit 0
