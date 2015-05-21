include_recipe 'cluster-mesos::docker_install'
# timeout set to 2 hours 'cause, you know, slow internet connexion
cmd_timeout_for_download = 7200
docker_container 'docker-registry' do
  image 'registry'
  detach true
  port '5000:5000'
  cmd_timeout cmd_timeout_for_download
end

images = [{name: "boune/nginx", source: "/vagrant/docker/nginx-hello/", action: :build_if_missing},
 {name: "boune/nginxtodo", source: "/vagrant/docker/nginx-todo/", action: :build_if_missing},
 {name: "boune/todolist", source: "/vagrant/docker/todolist/", action: :build_if_missing},
 {name: "tutum/hello-world", action: :pull_if_missing},
 {name: "mongo:3.0.2", action: :pull_if_missing}
]
images.each do |image|
  docker_image image[:name] do
    # tag "localhost:5000/#{image[:name]}:latest"
    source image[:source] unless image[:source].nil?
    action image[:action]
    cmd_timeout cmd_timeout_for_download
  end
end
# docker_registry "http://#{node['vagrant']['ipaddress']:5000/" do
#   username 'admin'
#   password 'docker'
#   email 'no@where.com'
# end
images.each do |image|
  docker_image image[:name] do
    registry "http://#{node['vagrant']['ipaddress']}:5000/"
    tag "http://#{node['vagrant']['ipaddress']}:5000/#{image[:name]}:latest"
    action :push
  end
  # docker_image "localhost:5000/#{image[:name]}:latest" do
  #   action :remove
  # end
end
