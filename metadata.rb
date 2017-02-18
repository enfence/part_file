name 'part_file'
maintainer 'Andrey Klyachkin'
maintainer_email 'andrey.klyachkin@enfence.com'
license 'Apache 2.0'
description 'Provides part_file resource to change only one part of a file'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
source_url 'https://github.com/enfence/part_file'
issues_url 'https://github.com/enfence/part_file/issues'
chef_version '>= 12.1' if respond_to?(:chef_version)
