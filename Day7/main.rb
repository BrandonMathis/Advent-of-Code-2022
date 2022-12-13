require 'bundler'
Bundler.require(:default)

# TODO
# File.open("#{__dir__}/input.txt") do |f|
#   f.each_line do |line|
#     ap line
#   end
# end

class ElfDir
  attr_accessor :parent, :children, :name

  def initialize(parent:, children: [], name:)
    @parent = parent
    @children = children
    @name = name
  end

  def size
    children.map(&:size).sum
  end

  def ls(level)
    puts "Dir #{name} [#{size}]".prepend(" "*level)
    children.each do |c|
      c.ls(level + 1)
    end
  end

  def sub_100k
    elf_dirs = children.filter { |c| c.class == ElfDir }
    elf_dirs.map { |c| [c.size <= 100_000 ? c.size : 0, c.sub_100k] }
  end

  def find_dir_at_least(num)
    return [] if children.length == 0

    elf_dirs = children.filter { |c| c.class == ElfDir }
    elf_dirs.map { |c| [c.size >= num ? c.size : nil, c.find_dir_at_least(num)].compact }.flatten
  end
end

class ElfFile
  attr_accessor :size, :name

  def initialize(name:, size:)
    @size = size.to_i
    @name = name
  end

  def ls(level)
    puts "File #{name} [#{size}]".prepend(" "*level)
  end
end

class ElfFileSystem
  attr_accessor :current_dir, :debug

  def initialize
    @current_dir = ElfDir.new(name: '/', parent: nil)
    @root_dir = @current_dir
  end

  def cd(path)
    puts "cd #{path}" if debug
    cd_back and return if path == '..'
    cd_root and return if path == '/'

    change_to_dir = current_dir.children.find { |node| node.class == ElfDir && node.name == path }

    @current_dir = change_to_dir
  end

  def ls
    puts @current_dir.name

    level = 1
    @current_dir.children.each do |node|
      node.ls(level)
    end
  end

  def create_file(name, size)
    puts "create file #{name} [#{size}]" if @debug

    current_dir.children << ElfFile.new(name: name, size: size)
  end

  def create_dir(name)
    puts "create dir #{name}" if @debug

    current_dir.children << ElfDir.new(parent: current_dir, name: name)
  end

  def root_dir
    @root_dir
  end

  def find_dir_at_least(num)
    current_dir.find_dir_at_least(num)
  end

  private

  def cd_root
    @current_dir = @root_dir
  end

  def cd_back
    parent = current_dir.parent
    raise 'cannot cd out of filesystem' if parent == nil
    @current_dir = parent
  end
end

class ElfCli
  attr_reader :fs

  def initialize(fs:)
    @fs = fs
  end

  def process_line(line)
    pline = line.split(' ')

    case pline[0]
    when '$'
      case pline[1]
      when 'cd'
        fs.cd(pline[2])
      when 'ls'
      end
    else
      case pline[0]
      when 'dir'
        fs.create_dir(pline[1])
      else
        fs.create_file(pline[1], pline[0])
      end
    end
  end
end

fs = ElfFileSystem.new
cli = ElfCli.new(fs: fs)

File.open("#{__dir__}/input.txt") do |f|
  f.each_line do |line|
    cli.process_line(line)
  end
end

fs.cd('/')

remaining_space = 70000000 - fs.current_dir.size
to_delete = 30000000 - remaining_space

puts 'To Delete'
puts to_delete

puts 'Smallest file to delete'
ap fs.find_dir_at_least(to_delete).min
