# classification.rb

require 'open3'

def run_classification(script_path, uploaded_file)
    # Get the current working directory
    # Create the absolute path by joining the directory of the current file and the relative file path
    output = Open3.capture2("python3 #{script_path} #{uploaded_file}")

    # Add any additional processing or error handling here if needed
    return output
end
