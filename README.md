# Nostalgic

A Rails engine gem that adds effective-dated attribute versioning to ActiveRecord models. Declare an attribute as "nostalgic" and the gem transparently stores its full history — you can query any attribute's value as of any past or future date without changing your application's existing interface.

## Requirements

- Ruby >= 3.0, < 3.5
- Rails >= 7.0

## Installation

Add to your application's Gemfile:

```ruby
gem "nostalgic"
```

Then run:

```bash
bundle install
```

Install the migration:

```bash
bin/rails nostalgic:install:migrations
bin/rails db:migrate
```

## Setup

Include the JavaScript and stylesheet in your asset pipeline. In `app/assets/javascripts/application.js`:

```js
//= require nostalgic
```

In `app/assets/stylesheets/application.css`:

```css
/*
 *= require nostalgic
 */
```

Nostalgic's JavaScript requires **jQuery** and **jQuery UI** (datepicker). These must be provided by your application.

## Usage

### Declaring versioned attributes

Call `nostalgic_attr` in your model with the attribute names you want to version:

```ruby
class User < ApplicationRecord
  nostalgic_attr :tel, :salary
end
```

This is all you need. The gem hooks into `after_find` and `after_save` — no other changes required to your model or controller.

### Versioned belongs_to associations

Pass `nostalgic: true` to `belongs_to` to version the foreign key:

```ruby
class User < ApplicationRecord
  belongs_to :company, nostalgic: true
end
```

This records the effective-dated history of which company the user belongs to.

### Reading the current value

Load a record normally — the attribute reflects the most recent value effective on or before today:

```ruby
user = User.find(1)
user.tel         # => "222-123-4567"  (current value)
user.company     # => <Company id=1>  (current association)
```

### Point-in-time queries

Use `#<attr>_on(date)` or `#<attr>_at(date)` (alias) to retrieve the value effective on a specific date:

```ruby
user.tel_on(Date.today - 1.day)   # => "111-123-4567"
user.tel_on(Date.today)           # => "222-123-4567"
user.tel_on(Date.today + 1.day)   # => "333-123-4567"

user.company_on(Date.today - 1.day)  # => <Company id=1>
user.company_on(Date.today + 1.day)  # => <Company id=2>
```

Passing `nil` returns the current value.

### Accessing history

Each versioned attribute gets a `has_many` association for its full history, ordered most-recent first:

```ruby
user.tels          # => [<Nostalgic::Attr value="222-123-4567" effective_at=...>, ...]
user.tels.size     # => 3
```

### Saving a new version

Set the attribute value and the effective date, then save:

```ruby
user.tel = "444-123-4567"
user.tel_effective_at = Date.today
user.save
```

If a record already exists for that `(model, attribute, effective_at)` combination, it is updated in place. Otherwise a new history entry is created.

## Form Helpers

Nostalgic provides two `FormBuilder` helpers that render a table showing the current value with a date picker and an expandable history list.

### `nostalgic_text_field`

```erb
<%= form_with model: @user do |f| %>
  <%= f.nostalgic_text_field :tel %>
<% end %>
```

Renders a text input for the current value alongside a hidden datepicker for `tel_effective_at`. Clicking the list icon expands the version history with delete buttons.

### `nostalgic_collection_select`

```erb
<%= form_with model: @user do |f| %>
  <%= f.nostalgic_collection_select :company_id, Company.all, :id, :name %>
<% end %>
```

Same layout as `nostalgic_text_field` but renders a `<select>` for the current value.

### Controller setup

Accept nested attributes in your controller's strong parameters:

```ruby
def user_params
  params.require(:user).permit(
    :name,
    tels_attributes: [:id, :value, :effective_at, :_destroy]
  )
end
```

## API Reference

### Class methods

| Method | Description |
|---|---|
| `nostalgic_attr(*attrs)` | Declares one or more attributes for effective-dated versioning |
| `belongs_to(name, nostalgic: true)` | Versions the foreign key of a `belongs_to` association |

### Instance methods

For each declared attribute `<attr>`:

| Method | Description |
|---|---|
| `<attr>` | Current effective value (as of today) |
| `<attr>_effective_at` | Effective date of the current value |
| `<attr>_effective_at=` | Set the effective date before saving a new version |
| `<attr>_on(date)` | Value effective on the given date |
| `<attr>_at(date)` | Alias for `<attr>_on` |
| `<attr.pluralize>` | `has_many` association returning all history records |

For each `belongs_to` declared with `nostalgic: true`:

| Method | Description |
|---|---|
| `<assoc>_on(date)` | Associated record effective on the given date |
| `<assoc>_at(date)` | Alias for `<assoc>_on` |

## Database Schema

The gem creates a single shared table for all versioned attributes across all models:

```
nostalgic_attrs
  id          integer
  model_type  string   (e.g. "User")
  model_id    integer
  name        string   (e.g. "tel")
  value       string
  effective_at date
  created_at  datetime
  updated_at  datetime
```

All values are stored as strings. Type coercion is the responsibility of the calling code.

## Contributing

Bug reports and pull requests are welcome at [https://github.com/ichylinux/nostalgic](https://github.com/ichylinux/nostalgic).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
