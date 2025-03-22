defmodule DiscordCloneWeb.VideoCallLive.TwilioVideoCheck do



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
