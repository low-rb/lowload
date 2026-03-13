<a href="https://rubygems.org/gems/lowload" title="Install gem"><img src="https://badge.fury.io/rb/lowload.svg" alt="Gem version" height="18"></a> <a href="https://github.com/low-rb/lowload" title="GitHub"><img src="https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white" alt="GitHub repo" height="18"></a> <a href="https://codeberg.org/Iow/load" title="Codeberg"><img src="https://img.shields.io/badge/Codeberg-2185D0?style=for-the-badge&logo=Codeberg&logoColor=white" alt="Codeberg repo" height="18"></a>

# LowLoad

LowLoad is really dumb; like a bull in a china shop, smashing through fragile dependencies to autoload your code without manual `require_relative` calls.

First LowLoad goes through all your files and notes their constant definitions and their file paths. Then it goes through the same directories again and loads each file into Ruby, but this time loading that file's dependencies first which we now know the location of. It doesn't wait to encounter an unknown constant then load that constant from a module namespace that matches your folder structure, that would be dumb.

## File Support

LowLoad supports normal Ruby (`.rb`) files as well as a few other embedded formats.

### RBX

LowLoad supports loading RBX files. RBX files are Ruby files containing HTML markup with the file extension `.rbx`.

### Antlers

[Antlers](https://github.com/raindeer-rb/antlers) syntax such as `<{ ChildNode }>` can be embedded inside the `render` method of your RBX file.

## Philosophy

- Folders are often organised by the kind of file it is, a bunch of views for example. But namespaces should be organised by your domain — they should be different
- You should be able to mix autoloading with manual `require` calls for stuff like gems, and `require_relative` when you need files outside the autoloaded directory

## Comparison

## Caveats

Like other autoloading libraries, LowLoad doesn't support circular dependencies at the class load stage (runtime is fine). Please don't do:
```ruby
class A
  include B
end

class B
  include C
end
```

Instead do:
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
