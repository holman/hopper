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
      binary_integer licenses
    end

    # Does this project use the MIT License?
    #
    # Returns an Integer. 1 if yes, 0 if no.
    def mit
      binary_integer instances_of("Permission is hereby granted, free of charge,")
    end

    # Does this project use GPL?
    #
    # Returns an Integer. 1 if yes, 0 if no.
    def gpl
      binary_integer instances_of("GNU GENERAL PUBLIC LICENSE")
    end

    # Does this project use LGPL?
    #
    # Returns an Integer. 1 if yes, 0 if no.
    def lgpl
      binary_integer instances_of("GNU LESSER GENERAL PUBLIC LICENSE")
    end

    # Does this project use the Apache license?
    #
    # Returns an Integer. 1 if yes, 0 if no.
    def apache
      binary_integer instances_of("Apache License")
    end

    # Does the project use a BSD-style license?
    #
    # Returns an Integer. 1 if yes, 0 if no.
    def bsd
      binary_integer instances_of("Redistribution and use in source and binary forms")
    end

  private
    def licenses
      tree = repo.lookup(revision).tree
      tree.select{|item| item[:name].downcase =~ /license/ }
    end

    def instances_of(string)
      licenses.map do |license|
        blob = license[:oid]
        content = Rugged::Blob.lookup(repo,blob).content

        content.scan(string)
      end.flatten
    end
  end
end