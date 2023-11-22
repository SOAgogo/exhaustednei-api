# classification.rb

require 'open3'

def run_classification(script_path, uploaded_file)
    # Get the current working directory
    # Create the absolute path by joining the directory of the current file and the relative file path
    output, error, status = Open3.capture3("python3 #{script_path} #{uploaded_file}")
    return output
end
