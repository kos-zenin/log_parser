# Description

This is an application to parse log files

## There are 3 modules of the app:

### file readers

Responsible for file reading and parsing, handles file errors.

File reader streams each row directly to consumer to support huge files, lazy enumerator allows not to load enormous file into memory

### analyzers

Strategy to gather data. Analyzers are injectable and could be turned off\on if necessary

### reporters

Strategy for reporting data.

There is only one reporting to stdout, there could be email\file reporters

# Usage

## Installation

- install ruby 2.7.1
- install bundler
- run `bundle install`

## Run

To run the parser
  `bin/parser.rb spec/files/webserver.log`

## Tests

- code linter:
  `bin/rubocop`

- specs:
  `bin/rspec`
