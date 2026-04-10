# TokyoNight Grouped Highlight Demo

This combines the previous shared, TypeScript-specific, and Go-specific grouped demos into one file.
Open it in Neovim and inspect the fenced `ts` and `go` blocks. The language-specific groups are labeled inline as `TS-specific` or `Go-specific`. Shared groups are left unlabeled.

## Muted Prose `#565f89`

Comments and doc comments share TokyoNight's muted prose color so explanatory text stays in the background.

Highlight groups: `@comment (#565f89)`, `@comment.documentation (#565f89)`

```ts
// Shared comments stay visually quiet.
/**
 * Shared doc comments stay visually quiet too.
 */
const commentAnchor = true;
```

## Boundary Cyan `#7dcfff`

Module aliases use cyan because they point at code boundaries and things that come from elsewhere.

Highlight groups: `@module (#7dcfff)`

```ts
import * as SharedFS from "node:fs";
import { readFileSync as sharedRead } from "node:fs";
```

Constant identifiers, enum members, and builtin nullish sentinels use the same cyan lane so fixed named values read as language-level signals rather than ordinary data.

Highlight groups: `@constant (#7dcfff)`, `@constant.builtin (#7dcfff)`, `@lsp.type.enumMember (#7dcfff, LSP)`, `@lsp.typemod.enumMember.defaultLibrary (#7dcfff, LSP)`

```ts
const HTTP_OK = 200;
const sharedNothing = null;
const sharedMissing = undefined;

enum SharedStatus {
  Ready = 1,
}

const sharedStatus = SharedStatus.Ready;
```

## Type Cyan `#2ac3de`

Type names stay on the same bright cyan lane whether they are user-defined, builtin, or surfaced by LSP as interface symbols.

Highlight groups: `@type (#2ac3de)`, `@type.builtin (#2ac3de)`, `@lsp.type.interface (#2ac3de, LSP)`, `@type.definition (#2ac3de, Go-specific)`

```ts
type UserName = string;
type ThemeName = string;

interface UserRecord {
  name: UserName;
  theme: ThemeName;
}

const sharedPromise: Promise<string> = Promise.resolve("night");
const sharedMap: Map<string, number> = new Map<string, number>();
```

```go
type Score int
type Status string
type Profile struct {
  Name string
}
```

Special marker tokens like namespace-import stars and regex flags use the same bright cyan because they are compact syntax signals.

Highlight groups: `@character.special (#2ac3de, TS-specific)`

```ts
import * as StarModule from "node:fs";
const flaggedPattern = /tokyo\d+/gi;
```

## Keyword Gray `#8c8c8c`

Function-introducing words plus branch, loop, exception, and the generic Treesitter/LSP keyword lane all use the same dim gray now. The generic keyword lane is also non-italic in the overlay.

Highlight groups: `@keyword (#8c8c8c)`, `@keyword.coroutine (#8c8c8c)`, `@keyword.return (#8c8c8c)`, `@keyword.function (#8c8c8c)`, `@keyword.conditional (#8c8c8c)`, `@keyword.repeat (#8c8c8c)`, `@keyword.exception (#8c8c8c, TS-specific)`, `@keyword.conditional.ternary (#8c8c8c, TS-specific)`, `@lsp.type.keyword (#8c8c8c, LSP)`, `@lsp.typemod.keyword.async (#8c8c8c, LSP)`

```ts
interface SharedFlag {
  ready: boolean;
}

const buildSharedText = async (input: string): Promise<string> => {
  return await Promise.resolve(input.trim());
};

function countReadyFlags(flags: SharedFlag[]): number {
  let readyCount = 0;

  for (const flag of flags) {
    if (flag.ready) {
      readyCount += 1;
    }
  }

  try {
    throw new Error("boom");
  } catch (error) {
    console.error(error);
  } finally {
    console.info("cleanup");
  }

  return readyCount > 0 ? readyCount : 0;
}
```

Import words, directive fragments, operator captures, selected punctuation including delimiters, optional markers, and brackets, plus escape sequences and constructors share the same dim gray because they are syntax-control markers rather than values or structure.

Highlight groups: `@keyword.import (#8c8c8c)`, `@keyword.directive (#8c8c8c, TS-specific)`, `@operator (#8c8c8c)`, `@keyword.operator (#8c8c8c, TS-specific)`, `@punctuation.delimiter (#8c8c8c)`, `@punctuation.special (#8c8c8c, TS-specific)`, `@punctuation.bracket (#8c8c8c)`, `@constructor (#8c8c8c)`, `@string.escape (#8c8c8c)`, `@lsp.type.escapeSequence (#8c8c8c, LSP)`, `@lsp.type.operator (#8c8c8c, LSP)`

```ts
"use strict";
import * as SharedFS from "node:fs";

const rawValue: unknown = { kind: "demo" };
const typedRecord = rawValue as { kind?: string };
const keyName: keyof typeof typedRecord = "kind";
const typedCheck = { kind: "tokyo" } satisfies { kind: string };
const isObject =
  typeof rawValue === "object" &&
  rawValue instanceof Object &&
  "kind" in typedRecord;

type OptionalUser = { name?: string; title?: string };
const maybeUser: OptionalUser = {};
const optionalName = maybeUser?.name ?? "anonymous";
const forcedLength = optionalName!.length;
const delimiterRecord = { left: "tokyo", right: "night" };
const delimiterLine = delimiterRecord.left + ":" + delimiterRecord.right;
const bracketExample = [1, 2, { pair: ["tokyo", "night"] }];
const anotherBracketExample = { value: bracketExample[0] };

class SharedPair {
  constructor() {}
}

const escapedBanner = "tokyo\nnight\tmode";
const escapedPath = "one\\two\\three";
```

## Callable Blue `#7aa2f7`

Function names, method names, and builtin functions share blue because they are all callables, whether being declared or invoked.

Highlight groups: `@function (#7aa2f7)`, `@function.call (#7aa2f7)`, `@function.method (#7aa2f7)`, `@function.method.call (#7aa2f7)`, `@function.builtin (#7aa2f7)`

```ts
function stitch(left: string, right: string): string {
  return left + "-" + right;
}

class SharedRunner {
  join(left: string, right: string): string {
    return stitch(left, right);
  }
}

const runner = new SharedRunner();
const joined = runner.join("tokyo", "night");
const parsedCount = parseInt("42", 10);
const parsedAgain = parseInt("7", 10);
```

Decorator names use the same blue callable lane because in TypeScript they are user-defined functions applied through decorator syntax.

Highlight groups: `@attribute (#7aa2f7, TS-specific)`

```ts
function sealed<T extends Function>(target: T): T {
  return target;
}

function track(_target: object, _key: string): void {}

@sealed
class DecoratedExample {
  @track value = 1;
}
```

Labels use the same blue, but they are kept separate because they are jump targets rather than callables.

Highlight groups: `@label (#7aa2f7)`

```ts
outerLoop: for (const outerIndex of [0, 1, 2]) {
  innerLoop: for (const innerIndex of [0, 1, 2]) {
    if (outerIndex === 2 || innerIndex === 2) {
      break outerLoop;
    }

    break innerLoop;
  }
}
```

## Neutral Foreground `#c0caf5`

Plain variable names, member references, and parameter names keep the default foreground because they are the baseline identifiers of ordinary code.

Highlight groups: `@variable (#c0caf5)`, `@variable.member (#c0caf5)`, `@variable.parameter (#c0caf5)`, `@lsp.type.parameter (#c0caf5, LSP)`

```ts
const baseValue = 1;
const totalValue = baseValue + 2;
const finalValue = totalValue + 3;

const plainUser = { name: "tokyo" };
const plainName = plainUser.name;

const stitchParts = (leftPart: string, rightPart: string): string =>
  leftPart + rightPart;
```

## Property Teal `#73daca`

Struct-field-like property names stay teal because they are named parts hanging off another value.

Highlight groups: `@property (#73daca, Go-specific)`

```go
type Profile struct {
  Name    string
  Count   int
  Enabled bool
}

func useProfile(profile Profile) {
  profile.Name = "tokyo"
  profile.Count = profile.Count + 1
  profile.Enabled = true
}
```

## Value Orange `#ff9e64`

Numeric literals and booleans share orange because they read as direct data rather than structure.

Highlight groups: `@number (#ff9e64)`, `@boolean (#ff9e64)`, `@number.float (#ff9e64, Go-specific)`

```ts
const retryLimit = 3;
const isReady = true;
const isActive = false;
```

```go
const statusOK = 200
const retryLimit = 3

var pi = 3.14
var half = 0.5
var tiny = 1e-9
```

## Text Green `#9ece6a`

Plain string content uses green so textual data stays distinct from identifiers and numbers.

Highlight groups: `@string (#9ece6a)`, `@character (#9ece6a, Go-specific)`

```ts
const plainCity = "tokyo";
const plainTheme = "night";
```

```go
var firstRune = 'g'
var secondRune = 'o'
var newlineRune = '\n'
```

## Regex Cyan `#b4f9f8`

Regular-expression bodies use pale cyan so they read as a special text dialect rather than as ordinary strings.

Highlight groups: `@string.regexp (#b4f9f8)`

```ts
const sharedPattern = /tokyo\d+/;
const sharedWords = /(storm|night)/;
```

## Runtime Red `#f7768e`

Builtin namespaces and builtin receiver/global variables use red because they come from the runtime environment rather than from local code.

Highlight groups: `@module.builtin (#f7768e, TS-specific)`, `@variable.builtin (#f7768e, TS-specific)`

```ts
class BuiltinCollector {
  title = "tokyo";

  report(): void {
    console.log(
      this.title,
      window,
      document,
      self,
      module,
      Intl.DateTimeFormat(),
      Intl.NumberFormat(),
      arguments.length,
    );
  }
}
```

## Style-Only Groups

These do not introduce their own foreground color, but they are still part of the grouped reference.

Highlight groups: `@spell (no fg)`, `@string.special.url (underline, TS-specific)`, `@none (none, TS-specific)`

```ts
// Spell checking can sit on top of comments without changing the base comment color.
/** URL-like require targets are underlined rather than recolored. */
import FsModule = require("node:fs");

const plainContainer = `${"tokyo"}-${"night"}`;
```
