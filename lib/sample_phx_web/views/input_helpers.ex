defmodule SamplePhxWeb.InputHelpers do
  use Phoenix.HTML

  def input_tag(form, field, opts \\ []) do
    form_input_type = Phoenix.HTML.Form.input_type(form, field)

    required = required_field?(form, field)

    wrapper_class_names = Keyword.get_values(opts, :wrapper_class) ++ ["form-group"]

    wrapper_opts = [class: Enum.join(wrapper_class_names, " ")]

    inputs_class_names =
      cond do
        # This field has an error.
        form.errors[field] ->
          Keyword.get_values(opts, :input_class) ++ ["form-control is-invalid"]

        # Other input fields have an error, not this field.
        # The "action" key exists in the changeset but not in conn.
        Map.get(form.source, :action) ->
          Keyword.get_values(opts, :input_class) ++ ["form-control is-valid"]

        true ->
          Keyword.get_values(opts, :input_class) ++ ["form-control"]
      end

    input_opts =
      [class: Enum.join(inputs_class_names, " ")] ++
        Keyword.drop(opts, [:wrapper_class, :input_class])

    label_text = Keyword.get(opts, :label) || humanize(field)

    content_tag :div, wrapper_opts do
      [
        label_tag(form, field, label_text, required),
        apply(Phoenix.HTML.Form, form_input_type, [form, field, input_opts]),
        SamplePhxWeb.ErrorHelpers.error_tag(form, field)
      ]
    end
  end

  def required_field?(form, field) do
    input_validations(form, field) |> Keyword.get(:required)
  end

  def label_tag(form, field, label_text, required \\ false) do
    if required,
      do: label(form, field, label_text <> " *"),
      else: label(form, field, label_text)
  end
end
