clearing :on

# https://github.com/guard/guard-rspec
guard :rspec, cmd: "bundle exec rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_files)
  dsl.watch_spec_files_for(%r{^app/(.+)\.rb$})
end

guard :bundler do
  require "guard/bundler"

  watch("Gemfile")
end
