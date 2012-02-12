module Hopper
  class Loc < Probe
    def description
      "A simple lines of code count."
    end

    def files
      Dir.glob(File.join(path,"*"))
    end

    def lines
      files.inject(0) do |sum,file|
        sum + File.read(file).lines.count
      end
    end
  end
end