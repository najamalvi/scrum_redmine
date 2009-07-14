default_run_options[:pty] = true

set :application, "redmine"
set :repository,  "git@github.com:scrumalliance/redmine.git"
set :scm, 'git'
set :git_enable_submodules, 1

set :deploy_to, "/home/sa_deploy/#{application}"
set :branch, "master"
set :deploy_via, :remote_cache

set :scm_verbose, true

set :user, "sa_deploy"
set :group, "sa_deploy"

role :app, "scrum01.managed.contegix.com"
role :web, "scrum01.managed.contegix.com"
role :db, "scrum01.managed.contegix.com", :primary => true

after "deploy:update_code", :redmine_symlinks
task :redmine_symlinks do
  run "ln -fns  #{shared_path}/dblogin.yml #{release_path}/config/dblogin.yml"
  run "ln -fns  #{shared_path}/email.yml #{release_path}/config/email.yml"
  run "ln -fns  #{shared_path}/files #{release_path}/files"
end

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end