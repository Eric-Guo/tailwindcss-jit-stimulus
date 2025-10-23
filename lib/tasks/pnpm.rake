# frozen_string_literal: true

namespace :pnpm do
  desc "Install JavaScript dependencies using pnpm"
  task :install do
    app_root = File.expand_path("../..", __dir__)
    Dir.chdir(app_root) do
      system("pnpm install") || abort("Command bin/pnpm install failed")
    end
  end
end
