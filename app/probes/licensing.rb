module Hopper
  class Licensing < Probe
    # The data for this Probe.
    exposes :present, :mit, :gpl, :lgpl, :apache

    # The description.
    #
    # Returns a String.
    def self.description
      "LICENSE aggregation in projects."
    end

    # Is a license present?
    #
    # Returns an Integer. 1 if yes, 0 if no.
    def present
      licenses.size > 0 ? 1 : 0
    end

    # Does this project use the MIT License?
    #
    # Returns an Integer. 1 if yes, 0 if no.
    def mit
      count("Permission is hereby granted, free of charge,") > 0 ? 1 : 0
    end

    # Does this project use GPL?
    #
    # Returns an Integer. 1 if yes, 0 if no.
    def gpl
      count("GNU GENERAL PUBLIC LICENSE") > 0 ? 1 : 0
    end

    # Does this project use LGPL?
    #
    # Returns an Integer. 1 if yes, 0 if no.
    def lgpl
      count("GNU LESSER GENERAL PUBLIC LICENSE") > 0 ? 1 : 0
    end

    # Does this project use the Apache license?
    #
    # Returns an Integer. 1 if yes, 0 if no.
    def apache
      count("Apache License") > 0 ? 1 : 0
    end

    # Does the project use a BSD-style license?
    #
    # Returns an Integer. 1 if yes, 0 if no.
    def bsd
      count("Redistribution and use in source and binary forms") > 0 ? 1 : 0
    end

  private
    def licenses
      `ls #{project.path} | grep -i license`
    end

    def count(string)
      licenses.select do |license|
        `cat #{project.path}/#{license.chomp} | grep -i "#{string}"`.chomp.strip != ''
      end.count
    end
  end
end