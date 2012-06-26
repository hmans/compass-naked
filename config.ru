require 'rack'
require 'tilt'
require 'compass'

# The goal is to have compass add its stylesheets to the Sass load path
# with as little user interaction as possible (maybe even just by requiring
# the compass gem?)
#
# @chriseppstein's proposed solution:
# Compass.configure_sass_plugin!
#
# @hmans' solution (works, but is a bit of a hack):
# Sass::Engine::DEFAULT_OPTIONS[:load_paths] << Compass::Frameworks["compass"].stylesheets_directory
#
# Using Compass.configuration.to_sass_engine_options:
Compass.configuration.to_sass_engine_options[:load_paths].each do |p|
  Sass::Engine::DEFAULT_OPTIONS[:load_paths] << p
end

class SassRenderer
  def call(env)
    Rack::Response.new.tap do |response|
      response['Content-type'] = 'text/css'
      response.body << Tilt.new('./views/test.scss').render
    end
  end
end

run SassRenderer.new
