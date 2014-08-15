set :application, 'Perl-Lint-Playground'
set :repo_url, 'git@github.com:moznion/Perl-Lint-Playground'
set :deploy_to, '/home/moznion/var/www'

set :bower_path, '/usr/local/bin/bower'
set :carton_path, '/home/moznion/.plenv/shims/carton'
set :cpanm_path, '/home/moznion/.plenv/shims/cpanm'
set :supervisorctl_path, '/usr/bin/supervisorctl'

task :deploy do
  release_path = File.join(fetch(:deploy_to), fetch(:application));

  on roles(:web) do
    if test("[ -d #{release_path} ]")
      execute "cd #{release_path}; git pull origin master"
    else
      execute "git clone #{fetch :repo_url} #{release_path}"
    end

    execute "cd #{release_path}; #{fetch :bower_path} install"
    execute "cd #{release_path}; #{fetch :carton_path} install"
    execute "cd #{release_path}; #{fetch :cpanm_path} -L local/ git://github.com/moznion/Perl-Lint"

    execute "#{fetch :supervisorctl_path} restart perl-lint-playground"
  end
end
