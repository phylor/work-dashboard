require "json"
require "faraday"
require "faraday/net_http"
Faraday.default_adapter = :net_http

class GrafanaQuery
  def call
    conn = Faraday.new(
      url: ENV["GRAFANA_DISK_URL"],
      params: {
        db: "telegraf",
        q: %{
          SELECT mean("used_percent") FROM "disk" WHERE time >= #{start_time.to_i}000ms and time <= #{Time.now.to_i}000ms GROUP BY time(1m), "host", "device" fill(null)
        },
        epoch: "ms"
      },
      headers: {:Authorization => "Bearer #{api_token}", "Content-Type" => "application/json"}
    )

    response = conn.get
    body = JSON.parse response.body

    body.dig("results").first.dig("series").map do |entry|
      percentage_used = entry.dig("values").sort { |e| e.first }.select { |e| e.last }.last.last.round

      {
        label: "#{entry.dig("tags", "host")}: #{entry.dig("tags", "device")}",
        value: percentage_used,
        status: percentage_used < 90 ? "ok" : "failed"
      }
    end
  end

  private

  def api_token
    ENV["GRAFANA_API_TOKEN"]
  end

  def start_time
    Time.now - ten_minutes
  end

  def ten_minutes
    10 * 60
  end
end
