# frozen_string_literal: true

autoload(:C, File.expand_path('spec/fixtures/directory/c.rb', Dir.pwd))

module B
  include C
end
