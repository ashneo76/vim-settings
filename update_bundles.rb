#!/usr/bin/env ruby

git_bundles = [ 
]

# Takes:
#   name: whatever you want the directory in the bundle to be called.
#   version: corresponds to the # (URL?src_id) you see for the specific version you wanna download. For instance:
#      For the script: http://www.vim.org/scripts/script.php?script_id=30
#      The latest version is 1.13, and the src_id of the link is
#      http://www.vim.org/scripts/download_script.php?src_id=9196
#      so 9196 is what I'd put here.
#   lambda: in case you need to do some kinda cleanup, you can supply a lambda function. The directory
#           you are currently in is the bundle/<name> (that you provided here)
vim_org_scripts = [
]

require 'fileutils'
require 'open-uri'

bundles_dir = File.join(File.dirname(__FILE__), "bundle")

FileUtils.cd(bundles_dir)

trash = ARGV.include?('--trash')

if trash
  puts "Trashing everything (lookout!)"
  Dir["*"].each {|d| FileUtils.rm_rf d }
end

git_bundles.each do |url|
  dir = url.split('/').last.sub(/\.git$/, '')
  if !trash && File.exists?(dir)
    puts "Skipping #{dir}"
    next
  end
  puts "  Unpacking #{url} into #{dir}"
  `git clone #{url} #{dir}`
  FileUtils.rm_rf(File.join(dir, ".git"))
end

vim_org_scripts.each do |script|
	name = script[0]
	script_id = script[1]
  if !trash && File.exists?(name)
    puts "Skipping #{name}"
    next
  end
  puts "Setup & Download #{name}"
  FileUtils.mkdir_p(name)
	FileUtils.cd(name)
	f = open("http://www.vim.org/scripts/download_script.php?src_id=#{script_id}")
	local_file = f.meta["content-disposition"].gsub(/attachment; filename=/,"")
	if local_file.end_with? 'vim'
		FileUtils.mkdir_p(File.dirname("plugin"))
		FileUtils.cd("plugin")
	end
  puts "  Writing #{local_file}"
  File.open(local_file, "w") do |file|
    file << f.read
  end
	if local_file.end_with? 'zip'
		puts "  Unzip"
    %x(unzip #{local_file})
  end
	if local_file.end_with? 'vba.gz'
		puts "  Vimball Gzip"
    %x(gunzip #{local_file})
		# launch vim and make it process the vimball the right way:
		local_folder = name
		unzipped_file = local_file.gsub(/.gz/,"")
		system("cd ../.. ; #{vim_command} +\"e bundle/#{local_folder}/#{unzipped_file}|UseVimball ~/.vim/bundle/#{local_folder}\"")
	elsif local_file.end_with? 'vba.tar.gz'
		puts "  Vimball Tar Gzip"
    %x(tar zxf #{local_file})
		# launch vim and make it process the vimball the right way:
		local_folder = name
		unzipped_file = local_file.gsub(/.tar.gz/,"")
		system("cd ../.. ; #{vim_command} +\"e bundle/#{local_folder}/#{unzipped_file}|UseVimball ~/.vim/bundle/#{local_folder}\"")
	elsif local_file.end_with? 'tar.gz'
		puts "  Tar Gunzip"
    %x(tar zxf #{local_file})
	elsif local_file.end_with? '.gz'
		puts "  Gunzip"
    %x(gunzip #{local_file})
  end
	if script.size == 3
		puts "  Custom setup"
		script[2].call
	end
	if local_file.end_with? 'vim'
		FileUtils.cd("..")
	end
	FileUtils.cd("..")
end

# vim:ft=ruby:
