include_recipe 'cluster-mesos::docker_install'
docker_container 'docker-registry' do
  image 'registry'
  detach true
  port '5000:5000'
  env 'SETTINGS_FLAVOR=local'
  volume '/mnt/docker:/docker-storage'
end
docker_registry 'http://localhost:5000'
[{name: "boune/nginx", source: "/vagrant/docker/nginx-hello/Dockerfile"},
 {name: "boune/nginxtodo", source: "/vagrant/docker/nginx-todo/Dockerfile"},
 {name: "boune/todolist", source: "/vagrant/docker/todolist/Dockerfile"}].each do |image|
  docker_image image[:name] do
    tag "localhost:5000/#{image[:name]}:latest"
    source image[:source]
    action :build_if_missing
  end
  docker_image "push #{image[:name]}" do
    action :push
  end
  # docker_image "push #{image[:name]}" do
  #   action :remove
  # end
end

%w(mongo:3.0.2 tutum/hello-world).each do |image_name|
  docker_image image_name do
    tag "localhost:5000/#{image_name}:latest"
    action :pull_if_missing
  end
  docker_image "push #{image_name}" do
    action :push
  end
  # docker_image "push #{image[:name]}" do
  #   action :remove
  # end
end