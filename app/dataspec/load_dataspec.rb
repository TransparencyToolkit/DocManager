module LoadDataspec
  # Load in all the dataspecs
  def load_all_dataspecs
    find_projects.each do |project_path|
      load_project(project_path)
    end
  end

  # Find the projects in the project dir
  def find_projects
    project_dir = "dataspec_files/projects"
    return Dir.glob("#{project_dir}/*")
  end

  # Load in a project
  def load_project(path)
    found_project = project_exists?(path)

    # Create new project if none found
    if !found_project
      return create_project(path)
    else # If one found, return that
      return update_project(found_project, path)
    end
  end

  # Update a project if it exists already
  def update_project(found_project, path)
    updated_project = found_project.parse_config(path)
    updated_project.save
    return updated_project
  end

  # Create a new project
  def create_project(path)
    project = Project.create
    project.parse_config(path)
    project.save
    return project
  end

  # Check if project exists
  def project_exists?(path)
    project_config = JSON.parse(File.read(path))
    index = project_config["index_name"]
    found_project = Project.where(index_name: index).first
    found_project ? (return found_project) : (return false)
  end
end
