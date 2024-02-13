#!/usr/bin/env ruby

require 'jruby/core_ext'

require 'maven_require'

maven_require do |deps|
  deps.jar 'org.apache.jena:jena-core:4.7.0'
  deps.jar 'org.apache.jena:jena-arq:4.7.0'
  deps.jar 'org.apache.logging.log4j:log4j-api:2.20.0'
  deps.jar 'org.apache.logging.log4j:log4j-core:2.20.0'
  deps.jar 'org.apache.logging.log4j:log4j-slf4j-impl:2.20.0'
end
