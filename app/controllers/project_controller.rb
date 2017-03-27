class ProjectController < ApplicationController
  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.save
  end
end
