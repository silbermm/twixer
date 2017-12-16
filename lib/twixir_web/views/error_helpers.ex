defmodule TwixirWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  use Phoenix.HTML

  @doc """
  returns the error class if the field is in an error state
  """
  def error_class(form, field) do
    if (form.errors[field]) do
      "has-error"
    else
      ""
    end
  end

  @doc """
  Generates tag for inlined form input errors.
  """
  def error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn (error) ->
      content_tag :span, translate_error(error), class: "help-block"
    end)
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(TwixirWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(TwixirWeb.Gettext, "errors", msg, opts)
    end
  end
end
