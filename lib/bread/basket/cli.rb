require 'optparse'
require 'bread/basket'

module Bread
  module Basket
    class CLI
      def parse!(args)
        options = OptionParser.new do |opts|
          opts.program_name = 'bread-basket'
          opts.banner = <<-EOS
Usage: #{opts.program_name} -p  filename.md
          EOS
          opts.separator ''
          opts.separator 'Options:'

          opts.on('-p', '--poster FILENAME', 'create a scientific poster') do |filename|
            if File.file?(filename)
              ::Bread::Basket::PosterMaker.new filename
            else
              puts "bread-basket can't find the file you specified"
              exit(0)
            end
          end
        end

        options.parse!(args)
        options
      end

      def run(args)
        if args.empty?
          puts opts.banner
          puts "Try '#{opts.program_name} --help' for more information"
          exit(0)
        else
          parse!(args)
        end
      end
    end
  end
end
