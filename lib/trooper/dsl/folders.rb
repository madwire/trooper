module Trooper
  module DSL
    module Folders
      
      def cd(path)
        run "cd #{path}"
      end

      def create_folder(path)
        run "mkdir -p #{path}"
      end
      alias :mkdir :create_folder

      def delete_folder(path)
        run "rm -rf #{path}"
      end

      def create_folders(*folders)
        folders.each { |folder| create_folder folder }
      end
      
    end
  end
end