require 'optparse'
require 'bread/basket'

module Bread
  module Basket
    class CLI
      def parse!(args)
        options = OptionParser.new do |opts|
          opts.program_name = 'bread-basket'
          opts.banner = "Usage: #{opts.program_name} -p  filename.md"
          opts.separator ''
          opts.separator 'Options:'
          poster_opt(opts)
        end

        options.parse!(args)
        options
      end

      def poster_opt(opts)
        description = 'create a scientific poster'
        opts.on('-p', '--poster FILE', description) do |filename|
          if File.file?(filename)
            ::Bread::Basket::PosterMaker.new filename
          else
            puts "bread-basket can't find the file you specified"
            exit(0)
          end
        end
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
