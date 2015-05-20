include_recipe 'cluster-mesos::docker_install'
docker_container 'docker-registry' do
  image 'registry'
  detach true
  port '5000:5000'
  env 'SETTINGS_FLAVOR=local'
  volume '/mnt/docker:/docker-storage'
end

images = [{name: "boune/nginx", source: "/vagrant/docker/nginx-hello/Dockerfile", action: :build_if_missing},
 {name: "boune/nginxtodo", source: "/vagrant/docker/nginx-todo/Dockerfile", action: :build_if_missing},
 {name: "boune/todolist", source: "/vagrant/docker/todolist/Dockerfile", action: :build_if_missing},
 {name: "tutum/hello-world", action: :pull_if_missing},
 {name: "mongo:3.0.2", action: :pull_if_missing}
]
images.each do |image|
  docker_image image[:name] do
    # tag "localhost:5000/#{image[:name]}:latest"
    source image[:source] unless image[:source].nil?
    action image[:action]
    # timeout set to 5 hours 'cause, you know, slow internet connexion
    cmd_timeout 18000
  end
end
docker_registry 'http://localhost:5000/' do
  username 'admin'
  password 'docker'
end
images.each do |image|
  docker_image image[:name] do
    tag "localhost:5000/#{image[:name]}:latest"
    action :push
    #notifies :remove, "docker_image[#{image[:name]}]", :immediately
  end
  # if the notifies is not correct buts that's a chef resource with the same name
  # docker_image "localhost:5000/#{image[:name]}:latest" do
  #   action :remove
  # end
end
