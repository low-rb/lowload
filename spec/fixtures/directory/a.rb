# frozen_string_literal: true

autoload(:B, File.expand_path('spec/fixtures/directory/b.rb', Dir.pwd))

module A
  include B
end
