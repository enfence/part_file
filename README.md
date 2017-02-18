# part_file cookbook

The `part_file` cookbook introduces the missing Chef feature - changing just
part of a file. It searches for a pattern in a file and if it founds, it
changes the line or deletes it according to the specified action.

## Requirements

### Chef

The cookbook is written using ChefDK 1.0.3 and tested with Chef 12.16.42.
I didn't test it with other versions of Chef and right now there are no
unit tests in the cookbook.

### Cookbook Dependencies

The cookbook uses standard Chef `file` resource to change a file.

## Usage

Place a dependency on the `part_file` cookbook in your cookbok's metadata.rb:

```ruby
depends 'part_file', '~> 0.1.0'
```

Then in a recipe:

```ruby
part_file '/tmp/hello.txt' do
  content 'Goodbye World'
  match 'Hello World'
end
```

### Syntax

```ruby
part_file 'name' do
  all                   TrueClass, FalseClass
  backup                FalseClass, Integer
  content               String
  group                 String, Integer
  manage_symlink_source TrueClass, FalseClass
  match                 String
  mode                  String, Integer
  owner                 String, Integer
  path                  String # defaults to 'name' if not specified
end
```

### Actions

- `:change` - Find the pattern in a string and change it to the new contents
- `:delete` - Find the pattern in a string and delete it
- `:after` - Find a string using the pattern and insert new contents after it
- `:before` - Find a string using the pattern and insert new contents before it

Please note: actions `:after` and `:before` are not idempotent. You can use
standard Chef properties such as `not_if` and `only_if` if you want to make
a resource idempotent.

### Properties

- `all` - If true, perform the specified action on all matches of the pattern.
Default is `false`, which means, that the action will be performed only on the
first occurrence.
- `backup` - same as property backup of file resource.
- `content` - new content to be added to the file or to be changed in the file.
- `group` - same as property group of file resource.
- `manage_symlink_source` - same as property manage_symlink_source of file resource.
- `match` - pattern to search for in the file.
- `mode` - same as property mode of file resource.
- `owner` - same as property owner of file resource.
- `path` - the full path to the file.

### Examples

Find a line starting with `maintainer` in file metadata.rb and change it
to `maintainer 'Cookbook maintainer'`

```ruby
part_file 'metadata.rb' do
  content "maintainer 'Cookbook maintainer'"
  match '^maintainer .*$'
end
```

Find a line containing 'hello world' and delete it.

```ruby
part_file '/tmp/hello.txt' do
  match 'hello world'
  action :delete
end
```

Find all comment lines and delete them.

```ruby
part_file '/tmp/myscript.sh' do
  match '^#'
  all true
  action :delete
end
```

Find a line containing 'START HERE' and insert the text after it.

```ruby
part_file '/tmp/test.txt' do
  match 'START HERE'
  content 'our new line 1
our new line 2
END HERE
'
  action :after
end
```

Find a line containing 'END HERE' and insert the text before it.

```ruby
part_file '/tmp/test.txt' do
  match 'END HERE'
  content 'our new line 3
our new line 4
'
  action :before
end
```

## Troubleshooting

Please let me know if you have any [issues](https://github.com/enfence/part_file/issues).

## License

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author:**          | Andrey Klyachkin (<andrey.klyachkin@enfence.com>)
| **Copyright:**       | Copyright (c) 2017 eNFence
| **License:**         | Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
