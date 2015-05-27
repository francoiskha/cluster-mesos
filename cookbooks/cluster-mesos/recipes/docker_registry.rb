include_recipe 'cluster-mesos::docker_install'
# timeout set to 2 hours 'cause, you know, slow internet connexion
cmd_timeout_for_download = 7200
docker_container 'docker-registry' do
  image 'registry'
  detach true
  port '5000:5000'
  cmd_timeout cmd_timeout_for_download
end

images = node['mesos']['docker']['images']
images.each do |image|
  docker_image image[:name] do
    tag image[:tag] unless image[:tag].nil?
    source image[:source] unless image[:source].nil?
    action image[:action]
    cmd_timeout cmd_timeout_for_download
  end
  tag = "latest"
  tag = image[:tag] unless image[:tag].nil?
  execute "docker tag -f #{image[:name]}:#{tag} #{node['vagrant']['ipaddress']}:5000/#{image[:name]}:#{tag}"
  execute "docker push #{node['vagrant']['ipaddress']}:5000/#{image[:name]}:#{tag}"
end