<a href="https://rubygems.org/gems/lowload" title="Install gem"><img src="https://badge.fury.io/rb/lowload.svg" alt="Gem version" height="18"></a> <a href="https://github.com/low-rb/lowload" title="GitHub"><img src="https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white" alt="GitHub repo" height="18"></a> <a href="https://codeberg.org/Iow/load" title="Codeberg"><img src="https://img.shields.io/badge/Codeberg-2185D0?style=for-the-badge&logo=Codeberg&logoColor=white" alt="Codeberg repo" height="18"></a>

# LowLoad

LowLoad is really dumb; like a bull in a china shop, smashing through fragile dependencies to autoload your code without manual `load`/`require`/`require_relative` calls.

1. First LowLoad goes through all your files and notes their constant definitions and file paths
2. Then it goes through the same files again and creates autoloads for each file's dependencies
3. Then it goes through every file again and loads it into Ruby

**Features:**
- Use any namespace structure you want (namespaces are not inferred from folder structure)
- Mix in manual requires in autoloaded files
- Supports RBX files

## Usage

### `lowload()`

Load an `.rb` or `.rbx` file with:
```ruby
LowLoad.lowload('spec/fixtures/html_node.rbx')
```

### `dirload()`

Load an entire directory with:
```ruby
LowLoad.dirload(File.expand_path('app', __FILE__))
```

## File Support

LowLoad supports normal Ruby (`.rb`) files as well as a few other embedded formats.

### RBX

LowLoad supports loading RBX files (`.rbx`). RBX files are Ruby files containing unescaped HTML markup:
```ruby
class MyClass
  def render
    <p>Hello</p>
  end
end
```

ℹ️ For more information see [LowNode](https://github.com/low-rb/low_node).

### Antlers

Antlers syntax can be embedded inside the `render` method of your RBX file:
```ruby
class MyClass
  def render
    <p><{ ChildNode }></p>
  end
end
```

ℹ️ For more information see [Antlers](https://github.com/raindeer-rb/antlers).

## Philosophy

- Folders are often organised by the kind of file it is, a bunch of views for example. But namespaces should be organised by your domain — different to your file structure
- You should be able to mix autoloading with manual `require` and `require_relative` calls. You often need files outside the autoloaded directory

## Caveats

Like other autoloading libraries, LowLoad doesn't support circular dependencies on class load (runtime is fine).

❌ Please don't do:
```ruby
class A
  include B
end

class B
  include A
end
```

✅ Instead do:
```ruby
class A
  include C
end

class B
  include C
end

class C
  # Code that both A and B share.
end
```

## Installation

Add `gem 'lowload'` to your Gemfile then:
```
bundle install
```
