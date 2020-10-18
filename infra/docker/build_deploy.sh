sudo docker build --no-cache -f infra/docker/Dockerfile -t senyo/blog:latest .
echo $DOCKER_ACCESS_TOKEN | sudo docker login -u $DOCKER_USERNAME --password-stdin
sudo docker push senyo/blog:latest