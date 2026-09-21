require "test_helper"

class StatusControllerTest < ActionDispatch::IntegrationTest
  test "GET / returns the project identifier" do
    get root_path
    assert_response :success
    assert_equal "Project 5 - EKS Kubernetes Platform", @response.body
  end

  test "GET /health returns 200 and healthy" do
    get "/health"
    assert_response :ok
    assert_equal "healthy", @response.body
  end

  test "GET /ready returns 200 and ready" do
    get "/ready"
    assert_response :ok
    assert_equal "ready", @response.body
  end
end
