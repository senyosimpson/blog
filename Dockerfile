FROM nixos/nix:2.15.0

WORKDIR /app

RUN nix-channel --update
RUN nix-env -iA nixpkgs.hugo
COPY . /app
CMD [ "hugo", "server", "--bind", "0.0.0.0", "--port", "8080", "--environment", "production", "--baseURL", "https://senyosimpson.fly.dev", "--appendPort=false" ]