class StatusController < ApplicationController
  def index
    render plain: "Project 5 - EKS Kubernetes Platform"
  end

  def health
    render plain: "healthy", status: :ok
  end

  def ready
    render plain: "ready", status: :ok
  end
end
