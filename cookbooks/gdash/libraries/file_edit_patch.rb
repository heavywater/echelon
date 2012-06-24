# This backports a few file edit helpers that became available
# in 0.10.9. It will only affect chef versions <= 0.10.8 and can
# be removed completely once support for pre-0.10.10 installs
# is no longer required
unless(Chef::Util::FileEdit.public_instance_methods(false).map(&:to_sym).include?(:insert_line_if_no_match))
  class Chef::Util::FileEdit
    def insert_line_after_match(regex, newline)
      search_match(regex, newline, 'i', 1)
    end

    def insert_line_if_no_match(regex, newline)
      search_match(regex, newline, 'i', 2)
    end

    private

    def search_match(regex, replace, command, method)

      #convert regex to a Regexp object (if not already is one) and store it in exp.
      exp = Regexp.new(regex)

      #loop through contents and do the appropriate operation depending on 'command' and 'method'
      new_contents = []

      contents.each do |line|
        if line.match(exp)
          self.file_edited = true
          case
          when command == 'r'
            new_contents << ((method == 1) ? replace : line.gsub!(exp, replace))
          when command == 'd'
            if method == 2
              new_contents << line.gsub!(exp, "")
            end
          when command == 'i'
            new_contents << line
            new_contents << replace unless method == 2
          end
        else
          new_contents << line
        end
      end
      if command == 'i' && method == 2 && ! file_edited
        new_contents << replace
        self.file_edited = true
      end

      self.contents = new_contents
    end
  end
end
