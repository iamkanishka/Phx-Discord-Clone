defmodule DiscordCloneWeb.VideoCallLive.TwilioVideo do

  alias DiscordCloneWeb.VideoCallLive.TwilioAccessToken
  alias ExTwilio.JWT.AccessToken.VideoGrant



  def create_video_room(unique_name \\ "Kanishka Naik") do
    with {:ok, room_data} <- create_room(unique_name),
         token <- get_the_token(unique_name, room_data["sid"]) do
      IO.inspect(token)
      {:ok, room_data["sid"], token}
    else
      {:error, error} ->
        {:error, error}
    end
  end

  def create_room(unique_name) do
    body =
      %{
        "UniqueName" => unique_name,
        # Options: "go", "peer-to-peer", "group-small", "group"
        "Type" => "group",
        "MaxParticipants" => 10,
        "RecordParticipantsOnConnect" => true
      }
      |> Jason.encode!()

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Basic " <> Base.encode64("#{@twilio_account_sid}:#{@twilio_api_secret}")}
    ]

    case HTTPoison.post(@twilio_url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 201, body: response_body}} ->
        {:ok, Jason.decode!(response_body)}

      {:ok, %HTTPoison.Response{status_code: status, body: error_body}} ->
        {:error, "Failed with status #{status}: #{error_body}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "HTTP request failed: #{reason}"}
    end
  end

  @doc """
  Generates a Twilio Access Token for a given identity and grant.
  """
 def generate(identity, room) do
  account_sid = @twilio_account_sid
  api_key = @twilio_api_key
  api_secret = @twilio_api_secret



  grant = video_grant(room)

  iat = :os.system_time(:second)
  exp = iat + 3600  # Token expires in 1 hour

  payload = %{
    "jti" => "#{api_key}-#{iat}",
    "iss" => api_key,  # API Key SID
    "sub" => account_sid,  # Account SID
    "iat" => iat,
    "nbf" => iat,
    "exp" => exp,
    "grants" => %{"identity" => identity} |> Map.merge(grant)
  }

  header = %{"alg" => "HS256", "typ" => "JWT", "cty" => "twilio-fpa;v=1"}

  # jwk = JOSE.JWK.from_oct(api_secret)
  # signed = JOSE.JWT.sign(jwk, header, payload)

  # token = JOSE.JWS.compact(signed) |> elem(1)


  signer =
    Joken.Signer.create("HS256", api_secret, header)

  token = Joken.generate_and_sign!(payload, %{}, signer)


   IO.puts("Generated Token: #{token}")  # Debugging

  token
end


def get_the_token(unique_name, room_id) do
  payload =  TwilioAccessToken.new(
    account_sid:  @twilio_account_sid,
    api_key: @twilio_api_key,
    api_secret: "secret",
    identity: "user@email.com",
    expires_in: 86_400,
    grants: [VideoGrant.new(room: room_id)]
  )

  token = TwilioAccessToken.to_jwt!(payload)
   token
end



  @doc """
  Example grant for Twilio Video.
  """
  defp video_grant(room \\ nil) do
    grant = %{"video" => %{}}
    if room, do: Map.put(grant, "video", %{"room" => room}), else: grant
  end

  # def create_video_token(identity) do
  #   room_name = "my-video-room-#{:rand.uniform(1000)}"

  #   payload = %{
  #     "Room" => %{
  #       "UniqueName" => room_name,
  #       "Type" => "group"
  #     },
  #     "Identity" => identity
  #   }

  #   headers = [
  #     {"Content-Type", "application/json"},
  #     {"Authorization", "Basic " <> Base.encode64("#{@twilio_account_sid}:#{@twilio_auth_token}")}
  #   ]

  #   case HTTPoison.post(@twilio_video_api_url, Jason.encode!(payload), headers) do
  #     {:ok, %HTTPoison.Response{status_code: 201, body: body}} ->
  #       {:ok, Jason.decode!(body)}

  #     {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
  #       {:error, "Failed to create video room. Status code: #{code}, Response: #{body}"}

  #     {:error, %HTTPoison.Error{reason: reason}} ->
  #       {:error, "HTTP request failed: #{reason}"}
  #   end
  # end
end
