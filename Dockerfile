FROM elixir:1.6

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - "https://www.postgresql.org/media/keys/ACCC4CF8.asc" | apt-key add -

# Install dependencies:
RUN apt-get update && apt-get install -qq -y postgresql-client-10 postgis --fix-missing --no-install-recommends

ENV INSTALL_PATH /app
WORKDIR $INSTALL_PATH
