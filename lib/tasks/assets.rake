# frozen_string_literal: true

namespace :shakapacker do
  # Ensure Node dependencies are installed before compiling packs.
  task :compile => "pnpm:install"
end

namespace :assets do
  desc "Compile all the assets"
  task :precompile => "pnpm:install"
end
