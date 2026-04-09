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

Imports and module names use cyan because they point at code boundaries and things that come from elsewhere.

Highlight groups: `@keyword.import (#7dcfff)`, `@module (#7dcfff)`

```ts
import * as SharedFS from "node:fs";
import { readFileSync as sharedRead } from "node:fs";
```

Directive-like fragments and decorators use the same cyan because they act like external annotations on surrounding code.

Highlight groups: `@keyword.directive (#7dcfff, TS-specific)`, `@attribute (#7dcfff, TS-specific)`

```ts
"use strict";

function sealed<T extends Function>(target: T): T {
  return target;
}

function track(_target: object, _key: string): void {}

@sealed
class DecoratedExample {
  @track value = 1;
}
```

## Type Cyan `#2ac3de`

User-defined type names use bright cyan so custom types stand out from primitives and ordinary values.

Highlight groups: `@type (#2ac3de)`, `@type.definition (#2ac3de, Go-specific)`

```ts
type UserName = string;
type ThemeName = string;

interface UserRecord {
  name: UserName;
  theme: ThemeName;
}
```

```go
type Score int
type Status string
type Profile struct {
  Name string
}
```

Runtime-provided builtin functions and builtin sentinel values use the same bright cyan because they come from the language/runtime, not from your code.

Highlight groups: `@function.builtin (#2ac3de)`, `@constant.builtin (#2ac3de)`

```ts
const parsedCount = parseInt("42", 10);
const parsedAgain = parseInt("7", 10);
const sharedNothing = null;
const sharedMissing = undefined;
```

Special marker tokens like namespace-import stars and regex flags use the same bright cyan because they are compact syntax signals.

Highlight groups: `@character.special (#2ac3de, TS-specific)`

```ts
import * as StarModule from "node:fs";
const flaggedPattern = /tokyo\d+/gi;
```

## Builtin Type Teal `#27a1b9`

Builtin type names use a darker teal variant so primitives and standard library types read differently from project-defined types.

Highlight groups: `@type.builtin (#27a1b9)`

```ts
const sharedPromise: Promise<string> = Promise.resolve("night");
const sharedMap: Map<string, number> = new Map<string, number>();
```

## Strong Violet `#bb9af7`

Function-introducing words plus branch, loop, exception, and the generic Treesitter/LSP keyword lane all use the stronger violet now. The generic keyword lane is also non-italic in the overlay.

Highlight groups: `@keyword (#bb9af7)`, `@keyword.coroutine (#bb9af7)`, `@keyword.return (#bb9af7)`, `@keyword.function (#bb9af7)`, `@keyword.conditional (#bb9af7)`, `@keyword.repeat (#bb9af7)`, `@keyword.exception (#bb9af7, TS-specific)`, `@keyword.conditional.ternary (#bb9af7, TS-specific)`

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

Constructor names get the same strong violet, but they are kept separate because they represent type construction rather than branching.

Highlight groups: `@constructor (#bb9af7)`

```ts
class SharedPair {
  constructor() {}
}

class SharedBucket {
  constructor() {}
}

const pair = new SharedPair();
const bucket = new SharedBucket();
```

Escape sequences also use strong violet because they are small but highly syntactic control markers inside text.

Highlight groups: `@string.escape (#bb9af7)`

```ts
const escapedBanner = "tokyo\nnight\tmode";
const escapedPath = "one\\two\\three";
```

## Callable Blue `#7aa2f7`

Function names and method names share blue because they are all callables, whether being declared or invoked.

Highlight groups: `@function (#7aa2f7)`, `@function.call (#7aa2f7)`, `@function.method (#7aa2f7)`, `@function.method.call (#7aa2f7)`

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

Plain variable names keep the default foreground because they are the baseline identifiers of ordinary code.

Highlight groups: `@variable (#c0caf5)`

```ts
const baseValue = 1;
const totalValue = baseValue + 2;
const finalValue = totalValue + 3;
```

## Member Teal `#73daca`

Member names and struct-field-like names share teal because they are named parts hanging off another value.

Highlight groups: `@variable.member (#73daca)`, `@property (#73daca, Go-specific)`

```ts
const sharedUser = { name: "tokyo", ready: true };
const sharedName = sharedUser.name;
const sharedReady = sharedUser.ready;
```

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

## Parameter Yellow `#e0af68`

Parameter names use warm yellow so inputs stand apart from surrounding locals and members.

Highlight groups: `@variable.parameter (#e0af68)`

```ts
const stitchParts = (leftPart: string, rightPart: string): string =>
  leftPart + rightPart;
const joinThree = (
  firstPart: string,
  secondPart: string,
  thirdPart: string,
): string => firstPart + secondPart + thirdPart;
```

## Value Orange `#ff9e64`

Constant identifiers, numeric literals, and booleans share orange because they read as direct data rather than structure.

Highlight groups: `@constant (#ff9e64)`, `@number (#ff9e64)`, `@boolean (#ff9e64)`, `@number.float (#ff9e64, Go-specific)`

```ts
const HTTP_OK = 200;
const retryLimit = 3;
const isReady = true;
const isActive = false;
```

```go
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

## Operator Cyan `#89ddff`

Operator words and symbols use bright blue-cyan because they actively transform or compare values.

Highlight groups: `@operator (#89ddff)`, `@keyword.operator (#89ddff, TS-specific)`

```ts
const rawValue: unknown = { kind: "demo" };
const typedRecord = rawValue as { kind?: string };
const keyName: keyof typeof typedRecord = "kind";
const typedCheck = { kind: "tokyo" } satisfies { kind: string };
const isObject =
  typeof rawValue === "object" &&
  rawValue instanceof Object &&
  "kind" in typedRecord;
```

Punctuation that glues syntax together uses the same blue-cyan, but it is kept separate because delimiters and optional markers are structural separators rather than operators.

Highlight groups: `@punctuation.delimiter (#89ddff)`, `@punctuation.special (#89ddff, TS-specific)`

```ts
type OptionalUser = { name?: string; title?: string };
const maybeUser: OptionalUser = {};
const optionalName = maybeUser?.name ?? "anonymous";
const forcedLength = optionalName!.length;
const delimiterRecord = { left: "tokyo", right: "night" };
const delimiterLine = delimiterRecord.left + ":" + delimiterRecord.right;
```

## Bracket Blue-Gray `#a9b1d6`

Brackets use a quieter blue-gray because they frame structure rather than carrying much meaning on their own.

Highlight groups: `@punctuation.bracket (#a9b1d6)`

```ts
const bracketExample = [1, 2, { pair: ["tokyo", "night"] }];
const anotherBracketExample = { value: bracketExample[0] };
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
