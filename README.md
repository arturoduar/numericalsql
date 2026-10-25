# numericalsql

A MySQL 8.4 project for working with numeric data, run locally with Docker.

## Setup

```bash
cp .env.example .env        # then edit the passwords
docker compose up -d
```

On the first start, the scripts in `sql/init/` run in filename order and create the tables and sample data.

## Connect

```bash
docker compose exec db mysql -u numeric -p numericalsql
```

Run the example queries without opening a prompt:

```bash
docker compose exec -T db mysql -u numeric -p numericalsql < sql/queries/examples.sql
```

(Use the `MYSQL_USER` and `MYSQL_PASSWORD` values from your `.env`.)

## Reset the database

Init scripts only run on an empty volume. To rebuild from scratch:

```bash
docker compose down -v
docker compose up -d
```

## Layout

```
numericalsql/
├── docker-compose.yml
├── .env.example
├── .gitignore
├── README.md
└── sql/
    ├── init/
    │   ├── 01_schema.sql      series and observations tables
    │   └── 02_seed.sql        sample data
    └── queries/
        └── examples.sql       summary stats, moving average, median
```

## Schema

- `series`: one row per named numeric series (name, unit, description).
- `observations`: timestamped `DECIMAL(18,6)` values, unique per series and timestamp.
