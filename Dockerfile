FROM oven/bun:1.3.14-alpine AS deps

WORKDIR /app

ENV ASTRO_TELEMETRY_DISABLED=1

COPY package.json bun.lock ./
COPY site/package.json ./site/package.json

RUN bun install --frozen-lockfile

FROM deps AS build

COPY tsconfig.json ./
COPY site ./site

RUN bun run build

FROM nginx:stable-alpine AS runtime

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/site/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
