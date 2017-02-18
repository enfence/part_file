#
# Author:: Andrey Klyachkin <andrey.klyachkin@enfence.com>
# Copyright:: Copyright 2017, eNFence GmbH
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

resource_name :part_file
default_action :change

property :path, String, name_property: true, identity: true
property :match, String, required: true, identity: true
property :content, String
property :all, [FalseClass, TrueClass], default: false
property :backup, [FalseClass, Integer]
property :group, [String, Integer]
property :manage_symlink_source, [TrueClass, FalseClass]
property :mode, [String, Integer]
property :owner, [String, Integer]

action :change do
  Chef::Log.debug('part_file::change')
  if ::File.exist?(path)
    file_contents = []
    matched = false
    ::IO.read(path).lines.each do |line|
      if line =~ /#{match}/
        line.sub!(/#{match}/, new_resource.content) unless matched
        matched = true if new_resource.all == false
      end
      file_contents << line
    end
    file new_resource.path do
      content file_contents.join
      backup new_resource.backup unless new_resource.backup.nil?
      owner new_resource.owner unless new_resource.owner.nil?
      group new_resource.group unless new_resource.group.nil?
      mode new_resource.mode unless new_resource.mode.nil?
      manage_symlink_source new_resource.manage_symlink_source unless new_resource.manage_symlink_source.nil?
    end
  else
    Chef::Log.debug("part_file::delete: File #{path} doesn't exist")
  end
end

action :delete do
  Chef::Log.debug('part_file::delete')
  if ::File.exist?(path)
    file_contents = []
    matched = false
    ::IO.read(path).lines.each do |line|
      if line =~ /#{match}/
        file_contents << line if matched
        matched = true if new_resource.all == false
      else
        file_contents << line
      end
    end
    file new_resource.path do
      content file_contents.join
      backup new_resource.backup unless new_resource.backup.nil?
      owner new_resource.owner unless new_resource.owner.nil?
      group new_resource.group unless new_resource.group.nil?
      mode new_resource.mode unless new_resource.mode.nil?
      manage_symlink_source new_resource.manage_symlink_source unless new_resource.manage_symlink_source.nil?
    end
  else
    Chef::Log.debug("part_file::delete: File #{path} doesn't exist")
  end
end

action :after do
  Chef::Log.debug('part_file::after')
  if ::File.exist?(path)
    file_contents = []
    matched = false
    ::IO.read(path).lines.each do |line|
      file_contents << line
      if line =~ /#{match}/
        file_contents << new_resource.content unless matched
        matched = true if new_resource.all == false
      end
    end
    file new_resource.path do
      content file_contents.join
      backup new_resource.backup unless new_resource.backup.nil?
      owner new_resource.owner unless new_resource.owner.nil?
      group new_resource.group unless new_resource.group.nil?
      mode new_resource.mode unless new_resource.mode.nil?
      manage_symlink_source new_resource.manage_symlink_source unless new_resource.manage_symlink_source.nil?
    end
  else
    Chef::Log.debug("part_file::after: File #{path} doesn't exist - creating it")
    file new_resource.path do
      content new_resource.content
      backup new_resource.backup unless new_resource.backup.nil?
      owner new_resource.owner unless new_resource.owner.nil?
      group new_resource.group unless new_resource.group.nil?
      mode new_resource.mode unless new_resource.mode.nil?
      manage_symlink_source new_resource.manage_symlink_source unless new_resource.manage_symlink_source.nil?
    end
  end
end

action :before do
  Chef::Log.debug('part_file::before')
  if ::File.exist?(path)
    file_contents = []
    matched = false
    ::IO.read(path).lines.each do |line|
      if line =~ /#{match}/
        file_contents << new_resource.content unless matched
        matched = true if new_resource.all == false
      end
      file_contents << line
    end
    file new_resource.path do
      content file_contents.join
      backup new_resource.backup unless new_resource.backup.nil?
      owner new_resource.owner unless new_resource.owner.nil?
      group new_resource.group unless new_resource.group.nil?
      mode new_resource.mode unless new_resource.mode.nil?
      manage_symlink_source new_resource.manage_symlink_source unless new_resource.manage_symlink_source.nil?
    end
  else
    Chef::Log.debug("part_file::before: File #{path} doesn't exist - creating it")
    file new_resource.path do
      content new_resource.content
      backup new_resource.backup unless new_resource.backup.nil?
      owner new_resource.owner unless new_resource.owner.nil?
      group new_resource.group unless new_resource.group.nil?
      mode new_resource.mode unless new_resource.mode.nil?
      manage_symlink_source new_resource.manage_symlink_source unless new_resource.manage_symlink_source.nil?
    end
  end
end
