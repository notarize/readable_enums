# Readable Enums

Create string attributes that behave like rails enums

## Getting Started

TODO


## Usage

Include the ReadableEnums module in the models you want to use it in, or in your base model.

```
class ModelName << ActiveRecord::Base
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
