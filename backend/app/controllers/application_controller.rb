# frozen_string_literal: true
require "connection_pool"
require "redis"

class ApplicationController < ActionController::API
  rescue_from ActionController::RoutingError, with: :not_found

  def index
    render json: { code: "ok" }
  end

  def not_found
    render json: { code: "not_found" }, status: :not_found
  end

  def redis
    @redis ||=
      ConnectionPool.new(
        size: ENV.fetch("RAILS_MAX_THREADS", 5),
        timeout: 5
      ) { Redis.new(ENV.fetch("REDIS_URL")) }
  end
  before_action do
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
  end

  def revalidate(path)
    HTTP.post(
      "#{ENV.fetch("FRONTEND_HOST", nil)}/api/next/revalidate",
      json: {
        path:
      }
    )
    Rails.cache.delete_matched(path)
  end
end
