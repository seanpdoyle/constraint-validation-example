# Constraint Validation Example

## How to read this repository

The [commits][] are structured to form a sequential narrative, iteratively and
incrementally building toward integrated client- and server-side validation
message rendering.

The commits earlier in the sequence use workable and somewhat naive
implementations to achieve the desired behavior, and are all covered by tests.

The later commits refine the implementation to a point where some valuable
abstractions emerge.

While reading the commits, feel free to skip over commits prefaced by
`[GENERATED]` or `[SKIP]`.

## Goals

While most of this code strives to be exemplary user-land integrations with some
of these new concepts, it's a best-effort attempt. The authentication code might
not be production-grade security, but it serves its purpose here.

Any concepts that are intended to be extracted to their corresponding frameworks
are declared in directories separate from the application code. For example,
when possible, Rails extensions are declared within the `lib/rails_ext`
directory, and the `app/javascript/initializers/` directory on the
JavaScript-side.

As exceptions to that rule, the `app/models/concerns` and
`app/controllers/concerns` declare extract-able code.

### Turbo

The first commit contains the only _truly_ Turbo-specific work. It
addresses the Turbo requirements for form submission redirects through a
workaround that combines the `FlashHash` and `ActiveRecord::SessionStore`.

The rest of the work is Turbo-adjacent.

### ActionView and Accessibility

The current ActionView default configurations for `<form>` element construction
don't create accessible forms and fields.

Some of this work explores some possible extensions to ActionView that could
improve Rails' baked in accessibility.

### ActionView and the Constraint Validations API

In addition to building more accessible forms and fields, the ActionView
extensions introduce some new concepts and patterns to improve the developer
experience around rendering ActiveModel validations in server-generated
HTML.

There are also complementary client-side patterns introduced to integrate with
the Browser-provided Constraint Validations API (you know, that thing that every
Rails app on the planet opts-out of by declaring `[novalidate]` attributes).

The inception of the concepts behind the JavaScript changes occurred with
RailsUJS-integration in mind, but it seems that Turbo will supplant RailsUJS and
make it obsolete and deprecated.

There ended up being **zero** lines of Turbo-dependent JavaScript code.

## Testing it out locally

To test this out on your own, clone the repository and run the `bin/setup`
script, then run the test suite by running `bin/rails test:all`.

[commits]: https://github.com/seanpdoyle/constraint-validation-example/commits/main
