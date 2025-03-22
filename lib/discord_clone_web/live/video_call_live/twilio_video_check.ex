defmodule DiscordCloneWeb.VideoCallLive.TwilioVideoCheck do

  @twilio_account_sid "AC4560fd3b4a0e9c096f0d0763bd743e91"
  @twilio_api_key "SJyIIEROfDkpNsJbg1Q4QaBKUZxjd7hV"
  @twilio_api_secret "db20bd8614fd3b1dc247db8b5819f7ef"
  # @twilio_url "https://video.twilio.com/v1/Rooms"
  @twilio_url "https://video.twilio.com/token"


  def create_room(unique_name \\ "DailyStandup") do
    body = %{
      "UniqueName" => unique_name,
      "Type" => "group", # Options: "go", "peer-to-peer", "group-small", "group"
      "MaxParticipants" => 10,
      "RecordParticipantsOnConnect" => true
    }
    |> Jason.encode!()

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Basic " <> Base.encode64("#{@twilio_account_sid}:#{@twilio_api_secret}")}
    ]

    case HTTPoison.get(@twilio_url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 201, body: response_body}} ->
        {:ok, Jason.decode!(response_body)}

      {:ok, %HTTPoison.Response{status_code: status, body: error_body}} ->
        {:error, "Failed with status #{status}: #{error_body}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "HTTP request failed: #{reason}"}
    end
  end

  def get_token() do
    headers = [
      {"Authorization", "Basic " <> Base.encode64("#{@api_key}:#{@api_secret}")},
      {"Content-Type", "application/json"}
    ]

    case :hackney.request(:get, @twilio_url, headers, "", [:with_body]) do
      {:ok, 200, _headers, body} ->
        {:ok, body}
      {:ok, status, _headers, body} ->
        {:error, "Failed with status #{status}: #{body}"}
      {:error, reason} ->
        {:error, "Request failed: #{inspect(reason)}"}
    end
  end




end
