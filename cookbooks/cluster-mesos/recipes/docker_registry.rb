include_recipe 'cluster-mesos::docker_install'
# execute "docker stop registry:2.0"
# execute "docker run --detach=true --publish='5000:5000' --env='SETTINGS_FLAVOR=local' --volume='/mnt/docker:/docker-storage' registry:2.0"
# [{name: "boune/nginx", directory: "/vagrant/docker/nginx-hello/", action: "build"},
#  {name: "boune/nginxtodo", directory: "/vagrant/docker/nginx-todo/", action: "build"},
#  {name: "boune/todolist", directory: "/vagrant/docker/todolist/", action: "build"},
#  {name: "mongo:3.0.2", action: "pull"},
#  {name: "tutum/hello-world", action: "pull"}
# ].each do |image|
#   if image[:action] == "build"
#     execute "docker #{image[:action]} -t #{image[:name]} #{image[:directory]}"
#   else
#     execute "docker #{image[:action]}  #{image[:name]}"
#   end
#   execute "docker tag #{image[:name]}:latest localhost:5000/#{image[:name]}:latest"
#   execute "docker push localhost:5000/#{image[:name]}:latest"
# end
