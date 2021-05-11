[{
  "logConfiguration": {
    "logDriver": "awslogs",
    "secretOptions": null,
    "options": {
      "awslogs-group": "/ecs/todoapp",
      "awslogs-region": "${REGION}",
      "awslogs-stream-prefix": "ecs"
    }
  },
  "portMappings": [
    {
      "hostPort": 80,
      "protocol": "tcp",
      "containerPort": 80
    }
  ],
  "cpu": 256,
  "networkMode": "awsvpc",
  "environment": [
    {
      "name": "PORT",
      "value": "80"
    },
    {
      "name": "RACK_ENV",
      "value": "production"
    },
    {
      "name": "RAILS_ENV",
      "value": "production"
    },
    {
      "name": "RAILS_SERVE_STATIC_FILES",
      "value": "true"
    },
    {
      "name": "RAILSLOGTO_STDOUT",
      "value": "true"
    },
    {
      "name": "REDIS_URL",
      "value": "redis://${REDIS}:6379/1"
    },
    {
      "name": "SECRET_KEY_BASE",
      "value": "productionkey"
    },
    {
      "name": "TODO_APP_DATABASE_HOST",
      "value": "${POSTGRES}"
    },
    {
      "name": "TODO_APP_DATABASE_PASSWORD",
      "value": "${DB_PASSWORD}"
    },
    {
      "name": "TODO_APP_DATABASE_PORT",
      "value": "5432"
    },
    {
      "name": "TODO_APP_DATABASE_USER",
      "value": "${DB_USERNAME}"
    }
  ],
  "memoryReservation": 512,
  "image": "${REPOSITORY_URL}:latest",
  "name": "web"
}]