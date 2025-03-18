# Readable Enums

Create string attributes that behave like rails enums

## Getting Started

```
gem install readable_enums
```


## Usage

Include the ReadableEnums module in the models you want to use it in, or in your base model.

```
class ModelName < ActiveRecord::Base
  include ReadableEnums

end
```

Add enum-like behavior to any existing string attribute by using the readable_enums method.

```
  readable_enums :status, [:active, :inactive, :pending]
```

ReadableEnums gives you enum-like methods and validations!

```
> model = ModelName.active.first
  ModelName Load (10.5ms) SELECT "model_names".* FROM "model_names" WHERE "model_names"."status" = $1 LIMIT 1[["status", "active"]]

> model.inactive?
=> false

> model.active?
=> true

> model.pending!
  BEGIN
  COMMIT

> model.pending?
=> true

> model.update(status: 'ending')
  BEGIN
  ROLLBACK

> model.errors.first
=> [:status, "ending is not a valid status"]
```


## Optional Arguments

#### allow_nil
`allow_nil (default false)`: allow nil values in your enum column

```
  readable_enums :status, [:active, :inactive, :pending], allow_nil: true
```

#### if
`if (default true)`: only validate the string attribute if the conditional returns true

```
  readable_enums :status, [:active, :inactive, :pending], if: :validate?

  def validate?
    ...
  end
```

#### with_scopes
`with_scopes (default true)`: prevent scopes from being setup for your enum values if you don't need them, or want to define them yourself

```
  readable_enums :status, [:active, :inactive, :pending], with_scopes: false

  scope :active, -> { where(status: :active).sort_by(&:created_at) }
```

#### with_methods
`with_methods (default true)`: prevent methods from being setup for your enum values if you don't need them or want to define them yourself

```
  readable_enums :status, [:active, :inactive, :pending], with_methods: false

  def active?
    status == 'active'
  end
```

#### prefix
`prefix (default nil)`: add a prefix to all generated method names

When `true` is provided, the enums name will be added to the beginning of each generated method's name
```
  readable_enums :status, [:active, :inactive, :pending], prefix: true

  # creates method names such as
  def status_active?
  def status_active!
  def status_inactive?
  ...
```

When any other value is provided, that value will be added to the beginning of each generated method's name
```
  readable_enums :status, [:active, :inactive, :pending], prefix: :example

  # creates method names such as
  def example_active?
  def example_active!
  def example_inactive?
```

#### suffix
`suffix (default nil)`: add a suffix to all generated method names

When `true` is provided, the enums name will be added to the end of each generated method's name
```
  readable_enums :status, [:active, :inactive, :pending], suffix: true

  # creates method names such as
  def active_status?
  def active_status!
  def inactive_status?
  ...
```

When any other value is provided, that value will be added to the end of each generated method's name
```
  readable_enums :status, [:active, :inactive, :pending], suffix: :example

  # creates method names such as
  def active_example?
  def active_example!
  def inactive_example?
```