// Regular comments and doc comments share TokyoNight's muted prose color so notes stay quiet.
// Color: #565f89
// Highlight groups: @comment (#565f89), @comment.documentation (#565f89)
// Extra style-only overlay: @spell (no fg)
/**
 * Shared comments stay subdued on purpose.
 */

// Import words and imported namespace names both use cyan because they point at module boundaries.
// Color: #7dcfff
// Highlight groups: @keyword.import (#7dcfff), @module (#7dcfff)
import * as SharedFS from "node:fs";
import { readFileSync as sharedRead } from "node:fs";

// User-defined type names use bright cyan so custom types stand out from builtin ones.
// Color: #2ac3de
// Highlight groups: @type (#2ac3de)
type SharedLabel = string;
type SharedRecord = {
  title: SharedLabel;
  ready: boolean;
};

// Builtin type names use the darker teal variant so primitives and standard containers read differently.
// Color: #27a1b9
// Highlight groups: @type.builtin (#27a1b9)
const sharedPromise: Promise<string> = Promise.resolve("night");

// Reserved words that declare values, mark async work, return from blocks, or enter type space share soft violet.
// Color: #9d7cd8
// Highlight groups: @keyword (#9d7cd8), @keyword.coroutine (#9d7cd8), @keyword.return (#9d7cd8), @keyword.type (#9d7cd8)
interface SharedFlag {
  ready: boolean;
}

const buildSharedText = async (input: string): Promise<string> => {
  return await Promise.resolve(input.trim());
};

// Function introducers plus branch and loop starters use the stronger violet because they kick off larger control-flow shapes.
// Color: #bb9af7
// Highlight groups: @keyword.function (#bb9af7), @keyword.conditional (#bb9af7), @keyword.repeat (#bb9af7)
function countReadyFlags(flags: SharedFlag[]): number {
  let readyCount = 0;

  for (const flag of flags) {
    if (flag.ready) {
      readyCount += 1;
    }
  }

  return readyCount;
}

// Regular function names and method names share the same blue because they are all callables.
// Color: #7aa2f7
// Highlight groups: @function (#7aa2f7), @function.call (#7aa2f7), @function.method (#7aa2f7), @function.method.call (#7aa2f7)
class SharedRunner {
  static join(left: string, right: string): string {
    return left + "-" + right;
  }
}

const sharedJoined = SharedRunner.join("tokyo", "night");
const sharedCount = countReadyFlags([{ ready: true }, { ready: false }]);

// The literal constructor name gets its own emphatic violet treatment.
// Color: #bb9af7
// Highlight groups: @constructor (#bb9af7)
class SharedPair {
  constructor() {}
}

class SharedBucket {
  constructor() {}
}

// Builtin callable names use bright cyan to read like language/runtime helpers instead of project functions.
// Color: #2ac3de
// Highlight groups: @function.builtin (#2ac3de)
const parsedCount = parseInt("42", 10);
const parsedAgain = parseInt("7", 10);

// Builtin constant-like sentinel values use the same bright cyan as other language-provided primitives.
// Color: #2ac3de
// Highlight groups: @constant.builtin (#2ac3de)
const sharedNothing = null;
const sharedMissing = undefined;

// Plain variable names keep the default foreground because they are the neutral baseline of code.
// Color: #c0caf5
// Highlight groups: @variable (#c0caf5)
const baseValue = parsedCount;
const totalValue = baseValue + sharedCount;

// Member/property names use teal because they are named parts hanging off another value.
// Color: #73daca
// Highlight groups: @variable.member (#73daca)
const sharedUser = { name: "tokyo", ready: true };
const sharedName = sharedUser.name;
const sharedReady = sharedUser.ready;

// Parameter names use warm yellow so function inputs are easy to pick out from surrounding locals.
// Color: #e0af68
// Highlight groups: @variable.parameter (#e0af68)
const stitchParts = (leftPart: string, rightPart: string): string =>
  leftPart + rightPart;
const stitched = stitchParts("storm", "mode");

// Value-like literals and constant identifiers share orange because they are direct data, not structure.
// Color: #ff9e64
// Highlight groups: @constant (#ff9e64), @number (#ff9e64), @boolean (#ff9e64)
const HTTP_OK = 200;
const retryLimit = 3;
const isReady = true;

// Plain string content uses green so textual data stays distinct from numbers and identifiers.
// Color: #9ece6a
// Highlight groups: @string (#9ece6a)
const plainCity = "tokyo";
const plainTheme = "night";

// Escape sequences get violet because the tiny control markers are more syntactic than textual.
// Color: #bb9af7
// Highlight groups: @string.escape (#bb9af7)
const escapedBanner = "tokyo\nnight\tmode";

// Regular-expression bodies use pale cyan to read as a special text dialect.
// Color: #b4f9f8
// Highlight groups: @string.regexp (#b4f9f8)
const sharedPattern = /tokyo\d+/;

// Operators use bright blue-cyan because they are active syntax that transforms values.
// Color: #89ddff
// Highlight groups: @operator (#89ddff)
const operatorResult = (parsedCount + 1) * 2 >= 10 && retryLimit !== 0;

// Delimiters use the same blue-cyan because commas, dots, and colons are the glue between syntax parts.
// Color: #89ddff
// Highlight groups: @punctuation.delimiter (#89ddff)
const delimiterRecord = { left: "tokyo", right: "night" };
const delimiterLine = delimiterRecord.left + ":" + delimiterRecord.right;

// Brackets use a quieter gray-blue because they frame structure instead of carrying meaning themselves.
// Color: #a9b1d6
// Highlight groups: @punctuation.bracket (#a9b1d6)
const bracketExample = [
  countReadyFlags([{ ready: true }]),
  { pair: ["tokyo", "night"] },
];

// Labels share callable blue so named jump targets are easy to spot in the flow of code.
// Color: #7aa2f7
// Highlight groups: @label (#7aa2f7)
sharedOuterLoop: for (const outerIndex of [0, 1, 2]) {
  sharedInnerLoop: for (const innerIndex of [0, 1, 2]) {
    if (outerIndex === 2 || innerIndex === 2) {
      break sharedOuterLoop;
    }

    break sharedInnerLoop;
  }
}

void SharedFS;
void sharedRead;
void sharedPromise;
void buildSharedText;
void SharedPair;
void SharedBucket;
void sharedJoined;
void parsedAgain;
void sharedNothing;
void sharedMissing;
void totalValue;
void sharedName;
void sharedReady;
void stitched;
void HTTP_OK;
void isReady;
void plainCity;
void plainTheme;
void escapedBanner;
void sharedPattern;
void operatorResult;
void delimiterLine;
void bracketExample;

export {};
