defmodule Servy.Plugins do
  require Logger

  def rewrite_path(%{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path_captures(conv, %{"thing" => thing, "id" => id}) do
    %{conv | path: "/#{thing}/#{id}"}
  end

  def rewrite_path_captures(conv, nil), do: conv

  @doc "Logs requests"
  def log(conv) do
    Logger.info("Logging request: #{inspect(conv)}")
    conv
  end

  def track(%{status: 404, path: path} = conv) do
    IO.puts("Warning: #{path} is on the loose!")
    conv
  end

  def track(conv), do: conv

  def emojify(%{status: 200} = conv) do
    %{conv | resp_body: "🥳 \n" <> conv.resp_body <> "\n🥳"}
  end

  def emojify(conv), do: conv
end
