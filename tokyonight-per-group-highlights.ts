// TokyoNight per-group TypeScript highlight demo.
// Ordered by resolved foreground color, with exact matches kept adjacent.
// Groups marked LSP depend on semantic tokens from the attached TypeScript server.
// `@spell` only becomes visible when `:set spell` is enabled.

export {};

// @comment (#565f89)
// muted prose line comments stay visually quiet
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

// @comment.documentation (#565f89)
/** documentation comments use the same muted prose lane */
//  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

// @punctuation.bracket (#a9b1d6)
const bracketArrayPerGroup = [1, 2];
//                           ^    ^
const bracketObjectPerGroup = { pair: "tokyo" };
//                            ^               ^
const bracketParenPerGroup = (1 + 2) * 3;
//                           ^     ^

// @variable (#c0caf5)
const plainVariablePerGroup = 1;
//    ^^^^^^^^^^^^^^^^^^^^^

// @lsp.type.generic (#c0caf5, LSP)
function genericValuePerGroup<TItem, TKey extends keyof TItem>(
  item: TItem,
  //    ^^^^^
  key: TKey,
  //   ^^^^
): TItem[TKey] {
  //^^^^ ^^^^
  return item[key];
}

// @module (#7dcfff)
import * as ModuleAliasPerGroup from "node:fs";
//          ^^^^^^^^^^^^^^^^^^^

// @attribute (#7dcfff)
function sealedAttributePerGroup<T extends Function>(target: T): T {
  return target;
}

@sealedAttributePerGroup
//^^^^^^^^^^^^^^^^^^^^^^
class DecoratedAttributePerGroup {}

// @lsp.type.namespace (#7dcfff, LSP)
namespace SemanticNamespacePerGroup {
  //      ^^^^^^^^^^^^^^^^^^^^^^^^^
  export const value = 1;
}

const semanticNamespaceValuePerGroup = SemanticNamespacePerGroup.value;
//                                     ^^^^^^^^^^^^^^^^^^^^^^^^^

// @type (#2ac3de)
type TypeAliasPerGroup = { name: string; theme: string };
//   ^^^^^^^^^^^^^^^^^
const typeValuePerGroup: TypeAliasPerGroup = { name: "tokyo", theme: "night" };
//                       ^^^^^^^^^^^^^^^^^

// @type.builtin (#2ac3de)
const builtinTypeValuePerGroup: number = 1;
//                              ^^^^^^

// @constant.builtin (#2ac3de)
const nullishValuePerGroup = null;
//                           ^^^^
const missingValuePerGroup = undefined;
//                           ^^^^^^^^^

// @character.special (#2ac3de)
const regexFlagsPerGroup = /tokyo\d+/gi;
//                                   ^^

// @lsp.type.interface (#2ac3de, LSP)
interface SemanticInterfacePerGroup {
  //      ^^^^^^^^^^^^^^^^^^^^^^^^^
  label: string;
}
const semanticInterfaceValuePerGroup: SemanticInterfacePerGroup = {
  //                                  ^^^^^^^^^^^^^^^^^^^^^^^^^
  label: "tokyo",
};

// @lsp.type.builtinType (#2ac3de, LSP)
function semanticBuiltinTypePerGroup(input: string): number {
  //                                        ^^^^^^   ^^^^^^
  return input.length;
}

// @lsp.type.enum (#2ac3de, LSP)
enum SemanticEnumPerGroup {
  // ^^^^^^^^^^^^^^^^^^^^
  First = 1,
  Second = 2,
}

// @lsp.type.typeAlias (#2ac3de, LSP)
type SemanticAliasPerGroup = "tokyo" | "night";
//   ^^^^^^^^^^^^^^^^^^^^^
let semanticAliasValuePerGroup: SemanticAliasPerGroup = "tokyo";
//                              ^^^^^^^^^^^^^^^^^^^^^

// @lsp.typemod.class.defaultLibrary (#2ac3de, LSP)
const defaultLibraryClassPerGroup = new Map<string, number>();
//                                      ^^^

// @lsp.typemod.type.defaultLibrary (#2ac3de, LSP)
const defaultLibraryTypePerGroup: Promise<string> = Promise.resolve("night");
//                                ^^^^^^^

// @lsp.typemod.typeAlias.defaultLibrary (#2ac3de, LSP)
type DefaultLibraryAliasPerGroup = Partial<{ count: number }>;
//   ^^^^^^^^^^^^^^^^^^^^^^^^^^^   ^^^^^^^

// @lsp.typemod.enumMember.defaultLibrary (#2ac3de, LSP, server-dependent)
const defaultLibraryEnumMemberPerGroup = Node.DOCUMENT_POSITION_FOLLOWING;
//                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

// @string.regexp (#b4f9f8)
const regexpPatternPerGroup = /tokyo\d+/;
//                             ^^^^^^^^

// @punctuation.delimiter (#89ddff)
type DelimiterRecordPerGroup = { left: string; right: string };
//                                   ^              ^
const delimiterUnionPerGroup: string | number = 1;
const delimiterDotPerGroup = delimiterUnionPerGroup.toString();
//                                                 ^

// @punctuation.special (#89ddff)
type OptionalPerGroup = { name?: string };
//                             ^
const maybeUserPerGroup: OptionalPerGroup = {};
const optionalNamePerGroup = maybeUserPerGroup?.name!;
//                                            ^^    ^

// @keyword (#bb9af7)
let keywordCountPerGroup = 1;
//^

// @keyword.coroutine (#bb9af7)
async function keywordCoroutinePerGroup(): Promise<string> {
  return await Promise.resolve("tokyo");
  //     ^^^^^
}

// @keyword.return (#bb9af7)
function keywordReturnPerGroup(input: string): string {
  return input.trim();
  //^^^^
}

// @keyword.function (#bb9af7)
function keywordFunctionPerGroup(): void {}
//^^^^^^

// @keyword.conditional (#bb9af7)
const conditionalInputPerGroup = 2;
if (conditionalInputPerGroup > 1) {
  //^
  const conditionalBranchPerGroup = "greater";
} else {
  //^^
  const conditionalFallbackPerGroup = "smaller";
}

// @keyword.repeat (#bb9af7)
for (const repeatItemPerGroup of ["tokyo"]) {
  //^
  continue;
  //^^^^^^
}

// @keyword.exception (#bb9af7)
try {
  throw new Error("boom");
  //^^^
} catch (caughtPerGroup) {
  //^^^
} finally {
  //^^^^^
}

// @keyword.import (#bb9af7)
import { readFileSync as importedReadPerGroup } from "node:fs";
//^^^^                                          ^^^^

// @keyword.directive (#bb9af7)
("use strict");
//^^^^^^^^^^

// @keyword.operator (#bb9af7)
const operatorObjectPerGroup = { label: "tokyo" };
const typeofResultPerGroup = typeof operatorObjectPerGroup;
//                           ^^^^^^
const inResultPerGroup = "label" in operatorObjectPerGroup;
//                               ^^
const instanceofResultPerGroup = operatorObjectPerGroup instanceof Object;
//                                                      ^^^^^^^^^^
const deleteTargetPerGroup: { temp?: string } = { temp: "night" };
delete deleteTargetPerGroup.temp;
//^^^^

// @keyword.type (#bb9af7)
interface KeywordTypeInterfacePerGroup {
  //^^^^^
  value: string;
}
enum KeywordTypeEnumPerGroup {
  //^
  Left,
  Right,
}
namespace KeywordTypeNamespacePerGroup {
  //^^^^^
  export const value = 1;
}

// @keyword.modifier (#bb9af7)
class KeywordModifierPerGroup {
  public readonly label = "tokyo";
  //^^^^ ^^^^^^^^
  private hiddenCount = 1;
  //^^^^^
}

// @keyword.conditional.ternary (#bb9af7)
const ternaryValuePerGroup = true ? "yes" : "no";
//                                ^       ^

// @operator (#bb9af7)
const operatorValuePerGroup = 2 + 3 * 4 === 14 && 14 > 0;
//                              ^   ^   ^^^    ^^    ^

// @constructor (#bb9af7)
class ConstructorTargetPerGroup {}
const constructorValuePerGroup = new ConstructorTargetPerGroup();
//                                   ^^^^^^^^^^^^^^^^^^^^^^^^^

// @string.escape (#bb9af7)
const escapedBannerPerGroup = "tokyo\nnight\tmode";
//                                  ^^     ^^
const escapedPathPerGroup = "one\\two\\three";
//                              ^^   ^^

// @lsp.type.keyword (#bb9af7, LSP)
if (true) {
  //^
}

// @lsp.typemod.keyword.async (#bb9af7, LSP)
async function semanticAsyncKeywordPerGroup(): Promise<number> {
  //^
  return await Promise.resolve(42);
}

// @lsp.type.escapeSequence (#bb9af7, LSP)
const semanticEscapePerGroup = "line-one\nline-two\tindent";
//                                      ^^        ^^

// @lsp.type.operator (#bb9af7, LSP)
const semanticOperatorValuePerGroup = 5 * 2 - 1;
//                                      ^   ^

// @function (#7aa2f7)
function namedFunctionPerGroup(left: string, right: string): string {
  //     ^^^^^^^^^^^^^^^^^^^^^
  return left + "-" + right;
}

// @function.call (#7aa2f7)
const calledFunctionValuePerGroup = namedFunctionPerGroup("tokyo", "night");
//                                  ^^^^^^^^^^^^^^^^^^^^^

// @function.method (#7aa2f7)
class MethodCarrierPerGroup {
  combine(left: string, right: string): string {
    //^^^
    return left + right;
  }
}

// @function.method.call (#7aa2f7)
new MethodCarrierPerGroup().combine("tokyo", "night");
//                          ^^^^^^^

// @function.builtin (#7aa2f7)
const builtinFunctionValuePerGroup = parseInt("42", 10);
//                                   ^^^^^^^^

// @label (#7aa2f7)
innerLabelPerGroup: for (const innerIndexPerGroup of [0, 1, 2]) {
  //^^^^^^^^^^^^^^
  break innerLabelPerGroup;
  //    ^^^^^^^^^^^^^^^^^^
}

// @lsp.typemod.variable.callable (#7aa2f7, LSP)
const callableVariablePerGroup = (input: string) => input.trim();
//    ^^^^^^^^^^^^^^^^^^^^^^^^

// @lsp.typemod.function.defaultLibrary (#7aa2f7, LSP)
const semanticDefaultFunctionPerGroup = parseFloat("3.14");
//                                      ^^^^^^^^^^

// @lsp.typemod.method.defaultLibrary (#7aa2f7, LSP)
console.log("semantic default library method per group");
//      ^^^

// @variable.member (#73daca)
const memberSourcePerGroup = { name: "tokyo" };
//                             ^^^^
const memberNamePerGroup = memberSourcePerGroup.name;
//                                              ^^^^

// @lsp.type.property (#73daca, LSP)
const semanticPropertySourcePerGroup: { title: string; count: number } = {
  //                                    ^^^^^
  title: "night",
  //^^^
  count: 2,
};
const semanticPropertyValuePerGroup = semanticPropertySourcePerGroup.title;
//                                                                   ^^^^^

// @string (#9ece6a)
const plainStringCityPerGroup = "tokyo";
//                              ^^^^^^^

// @lsp.type.string (#9ece6a, LSP)
const semanticStringPerGroup = "semantic string";
//                             ^^^^^^^^^^^^^^^^^

// @variable.parameter (#e0af68)
function parameterValuePerGroup(
  leftPartPerGroup: string,
  //^^^^^^^^^^^^^^
  rightPartPerGroup: string,
  //^^^^^^^^^^^^^^^
): string {
  return leftPartPerGroup + rightPartPerGroup;
}

// @lsp.type.parameter (#e0af68, LSP)
function semanticParameterPerGroup(
  firstSemanticPerGroup: number,
  //^^^^^^^^^^^^^^^^^^^
  secondSemanticPerGroup: number,
  //^^^^^^^^^^^^^^^^^^^^
): number {
  return firstSemanticPerGroup + secondSemanticPerGroup;
}

// @constant (#ff9e64)
const HTTP_OK_PER_GROUP = 200;
//    ^^^^^^^^^^^^^^^^^

// @number (#ff9e64)
const numberIntPerGroup = 42;
//                        ^^
const numberFloatPerGroup = 3.14;
//                          ^^^^
const numberExpPerGroup = 1e-9;
//                        ^^^^

// @boolean (#ff9e64)
const booleanReadyPerGroup = true;
//                           ^^^^
const booleanActivePerGroup = false;
//                            ^^^^^

// @lsp.type.boolean (#ff9e64, LSP)
const semanticBooleanPerGroup = true;
//                              ^^^^

// @lsp.type.number (#ff9e64, LSP)
const semanticNumberPerGroup = 108;
//                             ^^^

// @lsp.type.enumMember (#ff9e64, LSP)
enum LocalEnumMemberPerGroup {
  First = 1,
  Second = 2,
  //^^^^
}
const localEnumMemberValuePerGroup = LocalEnumMemberPerGroup.Second;
//                                                           ^^^^^^

// @module.builtin (#f7768e)
const moduleBuiltinValuePerGroup = Intl.NumberFormat();
//                                 ^^^^

// @variable.builtin (#f7768e)
function builtinVariablePerGroup(): void {
  console.log(window, document, self, arguments.length);
  //          ^^^^^^  ^^^^^^^^  ^^^^  ^^^^^^^^^
}

// @lsp.typemod.variable.defaultLibrary (#f7768e, LSP)
const defaultLibraryVariablePerGroup = window.location;
//                                     ^^^^^^

// @lsp.type.selfKeyword (#f7768e, LSP)
class SelfKeywordPerGroup {
  label = "tokyo";

  reveal(): string {
    return this.label;
    //     ^^^^
  }
}

// @lsp.type.selfTypeKeyword (#f7768e, LSP)
class SelfTypePerGroup {
  chain(): this {
    return this;
    //     ^^^^
  }
}

// @string.special.url (no fg, underline)
import UrlModulePerGroup = require("node:fs");
//                                 ^^^^^^^^^

// @none (no fg)
const nonePerGroup = `${"tokyo"}-${"night"}`;
//                   ^^^^^^^^^^   ^^^^^^^^^^

// @spell (no fg, spell)
// intentionally misspelled wrds make the spell overlay easy to inspect when spell is on
//                          ^^^^

// @lsp.type.variable (no fg, LSP)
const semanticVariablePerGroup = 5;
//    ^^^^^^^^^^^^^^^^^^^^^^^^

// @lsp.type.unresolvedReference (sp #db4b4b, undercurl, LSP)
const unresolvedReferencePerGroup = DOES_NOT_EXIST_PER_GROUP;
//                                  ^^^^^^^^^^^^^^^^^^^^^^^^
