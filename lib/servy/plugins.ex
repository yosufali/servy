defmodule Servy.Plugins do
  require Logger

  alias Servy.Conv

  def rewrite_path(%Conv{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path_captures(%Conv{} = conv, %{"thing" => thing, "id" => id}) do
    %{conv | path: "/#{thing}/#{id}"}
  end

  def rewrite_path_captures(conv, nil), do: conv

  @doc "Logs requests"
  def log(%Conv{} = conv) do
    Logger.info("Logging request: #{inspect(conv)}")
    conv
  end

  def track(%Conv{status: 404, path: path} = conv) do
    IO.puts("Warning: #{path} is on the loose!")
    conv
  end

  def track(%Conv{} = conv), do: conv

  def emojify(%Conv{status: 200} = conv) do
    %{conv | resp_body: "🥳 \n" <> conv.resp_body <> "\n🥳"}
  end

  def emojify(%Conv{} = conv), do: conv
end
