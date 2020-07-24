defmodule SamplePhxWeb.InputHelpers do
  use Phoenix.HTML

  # http://blog.plataformatec.com.br/2016/09/dynamic-forms-with-phoenix/
  def input_tag(form, field, opts \\ []) do
    form_input_type = opts[:using] || Phoenix.HTML.Form.input_type(form, field)
    required = input_validations(form, field) |> Keyword.get(:required)
    wrapper_opts = [class: "form-group"]
    input_opts = [class: "form-control #{form_state_class(form, field)}"]
    label_text = opts[:label] || humanize(field)

    content_tag :div, wrapper_opts do
      label = label_tag(form, field, label_text, required)
      input = apply(Phoenix.HTML.Form, form_input_type, [form, field, input_opts])
      error = SamplePhxWeb.ErrorHelpers.error_tag(form, field)

      [label, input, error]
    end
  end

  defp form_state_class(form, field) do
    cond do
      # The form was not yet submitted.
      # The "action" key exists in the changeset but not in conn.
      !Map.get(form.source, :action) -> ""
      # This field has an error.
      form.errors[field] -> "is-invalid"
      true -> "is-valid"
    end
  end

  def label_tag(form, field, label_text, required \\ false) do
    if required,
      do: label(form, field, label_text <> " *"),
      else: label(form, field, label_text)
  end
end
