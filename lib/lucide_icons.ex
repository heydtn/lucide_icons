defmodule LucideIcons do
  @moduledoc """
  Phoenix components for Lucide icons.

  This module provides a Phoenix component for each Lucide icon. Icons are generated
  at compile time from the lucide-static npm package.

  ## Usage

  Each icon is available as a function component that can be used in your Phoenix templates:

      <LucideIcons.home class="h-6 w-6" />
      <LucideIcons.arrow_right class="h-4 w-4 text-blue-500" />
      <LucideIcons.settings aria-hidden="true" />

  ## Available Icons

  You can get a list of all available icon names with `icon_names/0`:

      iex> LucideIcons.icon_names()
      [:accessibility, :activity, :air_vent, ...]

  ## Attributes

  All HTML attributes are supported and will be added to the SVG element:

  - `class` - CSS classes
  - `id` - Element ID
  - `aria-*` - Accessibility attributes
  - `data-*` - Data attributes
  - Any other valid HTML attribute

      <LucideIcons.user aria-label="User profile" data-testid="user-icon" />

  """
  use Phoenix.Component

  alias LucideIcons.Icon

  icon_paths =
    Mix.Project.deps_path()
    |> Path.join("/lucide_icons_static_icons/icons/*.svg")
    |> Path.wildcard()

  icons =
    for icon_path <- icon_paths do
      @external_resource Path.relative_to_cwd(icon_path)
      Icon.parse!(icon_path)
    end

  names = icons |> Enum.map(& &1.name) |> Enum.uniq()

  @icon_names names

  @doc "Returns a list of available icon names as atoms"
  @spec icon_names() :: [atom()]
  def icon_names(), do: @icon_names

  @doc """
  Searches for icon names that match a given pattern.

  Returns a list of icon names (as atoms) that contain the search term.
  The search is case-insensitive.

  ## Examples

      iex> LucideIcons.search_icons("arrow")
      [:arrow_big_down, :arrow_big_left, :arrow_big_right, :arrow_big_up,
       :arrow_down, :arrow_down_left, :arrow_down_right, :arrow_left,
       :arrow_left_right, :arrow_right, :arrow_up, :arrow_up_down, ...]

      iex> LucideIcons.search_icons("user")
      [:user, :user_check, :user_minus, :user_plus, :user_x, :users]

  """
  @spec search_icons(String.t()) :: [atom()]
  def search_icons(search_term) do
    search = String.downcase(search_term)

    @icon_names
    |> Enum.filter(fn icon_name ->
      icon_name
      |> to_string()
      |> String.downcase()
      |> String.contains?(search)
    end)
    |> Enum.sort()
  end

  @doc """
  Dynamically renders an icon

  ## Examples

      <LucideIcons.dynamic icon={:plane} />
      <LucideIcons.dynamic icon={:circle_check} class="h-6 w-6" />
      <LucideIcons.dynamic icon={:shield_minus} class="h-4 w-4 text-blue-500" aria-hidden="true" />
  """
  def dynamic(assigns) do
    icon = assigns.icon
    assigns = Map.delete(assigns, :icon)

    apply(LucideIcons, icon, [assigns])
  end

  for %Icon{name: name, file: file} <- icons do
    icon_name_string = name |> to_string() |> String.replace("_", "-")

    @doc """
    Renders the `#{icon_name_string}` icon.

    ## Examples

        <LucideIcons.#{name} />
        <LucideIcons.#{name} class="h-6 w-6" />
        <LucideIcons.#{name} class="h-4 w-4 text-blue-500" aria-hidden="true" />

    ## Attributes

    Accepts all HTML attributes that are valid for SVG elements.
    """
    def unquote(name)(assigns) do
      attrs = Icon.opts_to_attrs(assigns)
      icon_svg = Icon.insert_attrs(unquote(file), attrs)

      assigns = assign(assigns, raw: icon_svg)

      ~H"""
      <%= @raw %>
      """
    end
  end
end
