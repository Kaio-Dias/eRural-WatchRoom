# syntax=docker/dockerfile:1

# Frontend build stage
FROM node:22 as frontend-builder
WORKDIR /app/frontend
COPY frontend/package.json frontend/package-lock.json* ./
RUN npm install --legacy-peer-deps --loglevel=error
COPY frontend/ .
RUN npm run build

# Backend build stage
FROM ruby:3.4.7 as backend-builder
WORKDIR /app/backend
COPY backend/Gemfile backend/Gemfile.lock ./
RUN bundle install
COPY backend/ .

# Final image
FROM ruby:3.4.7
WORKDIR /app

COPY --from=frontend-builder /app/frontend/dist ./public
COPY --from=backend-builder /app/backend .
COPY --from=backend-builder /usr/local/bundle /usr/local/bundle

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]