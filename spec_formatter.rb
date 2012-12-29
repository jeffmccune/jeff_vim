# RSpec < 2.0 support

require 'spec/runner/formatter/base_text_formatter'
require 'pathname'

# Format spec results for display in the Vim quickfix window
# To test: spec -r ~/.vim/ruby/spec_formatter -f Spec::Runner::Formatter::VimSpecFormatter spec
# From https://wincent.com/blog/running-rspec-specs-from-inside-vim

module Spec
  module Runner
    module Formatter
      class VimSpecFormatter < BaseTextFormatter
        def dump_failure counter, failure
          path = $1 if failure.exception.backtrace.find do |frame|
            frame =~ %r{\b(spec/.*_spec\.rb:\d+)(?::|\z)}
          end
          message = failure.exception.message.gsub("\n", ' ')
          if path
            @output.puts "#{relativize_path(path)}: #{message}"
          else
            @output.puts "ruby-test: could not find path?!"
          end
        end

        def dump_pending
        end

        def dump_summary duration, example_count, failure_count, pending_count
        end

      private

        def relativize_path path
          @wd ||= Pathname.new Dir.getwd
          begin
            return Pathname.new(path).relative_path_from(@wd)
          rescue ArgumentError
            # raised unless both paths relative, or both absolute
            return path
          end
        end
      end # class VimFormatter
    end # module Formatter
  end # module Runner
end # module Spec
