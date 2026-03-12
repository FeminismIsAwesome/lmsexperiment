---
apply: always
---

# Rails 8 Project Rules

## Core philosophy

- Prefer simple, conventional Rails over clever abstractions.
- Favor server-rendered HTML and standard Rails patterns first.
- Keep JavaScript to a minimum.
- Do not introduce Action Cable, WebSockets, or real-time features unless explicitly requested.
- Optimize for maintainability, readability, and fast onboarding of new developers.

## Application design

- Prefer Rails conventions before introducing custom patterns.
- Keep controllers thin:
    - handle HTTP concerns
    - load records
    - authorize where applicable
    - delegate business logic elsewhere
- Put business logic in the appropriate domain object:
    - model methods for behavior intrinsic to a record
    - PORO/service object for multi-step workflows or cross-model operations
    - query object only when a query becomes complex and reused
- Avoid creating service objects for trivial CRUD logic.
- Prefer explicit, boring code over metaprogramming.
- Avoid deeply nested abstractions and custom DSLs.

## Views and frontend

- Prefer ERB and server-rendered responses.
- Prefer standard Rails helpers and partials for reusable UI.
- Use Turbo for navigation/form enhancements when it keeps the code simpler.
- Use Stimulus only for small, isolated UI behavior that cannot be handled cleanly on the server.
- Do not build SPA-style flows.
- Do not introduce frontend frameworks.
- Do not add JavaScript dependencies unless explicitly approved.
- Keep client-side state to a minimum.
- If a feature works well with a normal full-page request/response cycle, use that.

## JavaScript rules

- Write the least JavaScript necessary.
- Prefer HTML and CSS solutions before JavaScript solutions.
- Prefer one small Stimulus controller over large custom JS modules.
- Keep Stimulus controllers focused on presentation behavior, not business logic.
- Do not move validation, authorization, or workflow rules into JavaScript.
- Do not use Action Cable.
- Do not propose polling or real-time updates unless the requirement clearly demands it.

## Models

- Models may contain domain behavior, validations, scopes, and persistence-related logic.
- Avoid fat models full of unrelated procedural workflows.
- Prefer well-named instance methods and class methods over callback-heavy designs.
- Use callbacks sparingly and only when they are straightforward and predictable.
- Avoid callbacks that trigger external side effects or hide important workflow behavior.

## Controllers

- One responsibility: translate request to response.
- Do not place business workflows directly in controller actions.
- Keep actions concise and readable.
- Use strong parameters.
- Handle unhappy paths explicitly.
- Prefer redirects/rendering with clear flash/error messages over complicated controller branching.

## Routing

- Prefer conventional RESTful routes.
- Avoid non-RESTful member/collection actions unless clearly justified.
- Keep route design predictable.
- Namespaces are fine when they reflect real application boundaries, not speculation.

## Database and Active Record

- Prefer database constraints for important invariants in addition to model validations where appropriate.
- Use migrations that are reversible and easy to understand.
- Avoid mixing schema changes with data migrations unless necessary.
- Be explicit about nullability, defaults, indexes, and foreign keys.
- Add indexes for foreign keys and frequently queried columns.
- Prevent N+1 queries in controller/view-facing code.

## Security

- Follow Rails secure defaults.
- Never bypass authentication, authorization, CSRF protection, or strong parameters without a clear reason.
- Do not expose sensitive data in logs, views, or serialized responses.
- Prefer allowlists over denylists for params and permitted behavior.

## Dependencies

- Prefer the standard library and Rails built-ins before adding gems.
- Do not add new gems without clear justification in the change description.
- When proposing a dependency, explain:
    - why built-in Rails is insufficient
    - the maintenance cost
    - the narrowest scope of use

## Testing philosophy

- Every meaningful behavior change should include or update tests.
- Prefer fewer, high-value tests over many low-value brittle tests.
- Test at the lowest level that gives confidence:
    - unit tests for isolated domain logic
    - integration/request tests for HTTP behavior and app flows
    - system tests only for critical end-to-end user journeys
- Avoid overusing system tests for behavior that can be verified faster elsewhere.

## Test expectations by layer

### Model/unit-level tests
Use model or PORO tests for:
- validations
- domain rules
- small business logic methods
- query objects
- service objects with isolated behavior

These tests should be fast and focused.

### Request/integration tests
Prefer request/integration tests for:
- controller behavior
- authentication/authorization outcomes
- redirects and rendered responses
- parameter handling
- important multi-step server-side flows

For most feature work, request tests should be the default choice.

### System tests
Use system tests selectively for:
- critical user journeys
- flows involving Turbo behavior that must be verified in-browser
- regressions involving form interaction, navigation, or JS-enhanced UI

Do not add system tests for every CRUD path.
Do not test implementation details of HTML/CSS/JS unless they are user-critical.

## What to avoid in tests

- Do not test private methods directly.
- Do not mock Active Record or Rails internals unnecessarily.
- Avoid brittle assertions tied to incidental markup.
- Avoid excessive fixture/setup complexity for simple cases.
- Do not use system tests when a request or unit test is sufficient.

## Preferred testing balance

For a typical feature:
1. Add unit tests for new domain logic.
2. Add request/integration tests for the endpoint behavior.
3. Add a system test only if the user interaction itself is important or browser behavior could regress.

## Code style

- Prefer small methods with clear names.
- Prefer guard clauses over deep nesting.
- Prefer explicit names over abbreviations.
- Leave code simpler than you found it.
- Match the style of the existing codebase unless there is a strong reason to improve it.
- Do not perform drive-by refactors unless they directly support the task.

## Comments and documentation

- Write self-explanatory code first.
- Add comments only when they explain intent, tradeoffs, or non-obvious constraints.
- Do not add comments that merely restate the code.

## AI change guidelines

- Make the smallest change that fully solves the problem.
- Preserve existing architecture unless the task calls for refactoring.
- When editing, avoid unrelated rewrites.
- If a tradeoff exists, prefer the more conventional Rails solution.
- If JavaScript is optional, choose the non-JavaScript or Turbo-first approach.
- If uncertain between multiple implementations, prefer the one with simpler tests and lower long-term maintenance cost.