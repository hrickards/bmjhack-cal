# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Cal2::Application.initialize!

require 'yaml'
consts = YAML.load_file 'config/filters.yaml'
COURSES = consts['courses']
YEARS = consts['years']
TAGS = consts['tags']
