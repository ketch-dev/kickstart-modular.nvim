// TokyoNight per-group TypeScript highlight demo.
// Ordered by resolved foreground color, with exact matches kept adjacent.
// Groups marked LSP depend on semantic tokens from the attached TypeScript server.
// `@spell` only becomes visible when `:set spell` is enabled.

export {};

// @comment (#565f89)
// muted prose line comments stay visually quiet
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

// @comment.documentation (#565f89)
/** documentation comments use the same muted prose lane */
//  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

// @punctuation.bracket (#8c8c8c)
const bracketArrayPerGroup = [];
//                           ^^
const bracketObjectPerGroup = {};
//                            ^^
const bracketParenPerGroup = 0;
//                           ^ ^

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
function sealedAttributePerGroup() {}

@sealedAttributePerGroup
//^^^^^^^^^^^^^^^^^^^^^^
class DecoratedAttributePerGroup {}

// @lsp.type.namespace (#7dcfff, LSP)
namespace SemanticNamespacePerGroup {
  //      ^^^^^^^^^^^^^^^^^^^^^^^^^
}

const semanticNamespaceValuePerGroup = SemanticNamespacePerGroup.value;
//                                     ^^^^^^^^^^^^^^^^^^^^^^^^^

// @type (#2ac3de)
type TypeAliasPerGroup = {};
//   ^^^^^^^^^^^^^^^^^
const typeValuePerGroup: TypeAliasPerGroup = {};
//                       ^^^^^^^^^^^^^^^^^

// @type.builtin (#2ac3de)
const builtinTypeValuePerGroup: number = 1;
//                              ^^^^^^

// @constant.builtin (#7dcfff)
const nullishValuePerGroup = null;
//                           ^^^^
const missingValuePerGroup = undefined;
//                           ^^^^^^^^^

// @character.special (#2ac3de)
const regexFlagsPerGroup = /tokyo\d+/gi;
//                                   ^^

// @lsp.type.interface (#2ac3de, LSP)
interface SemanticInterfacePerGroup {}
//        ^^^^^^^^^^^^^^^^^^^^^^^^^
const semanticInterfaceValuePerGroup: SemanticInterfacePerGroup = {};
//                                    ^^^^^^^^^^^^^^^^^^^^^^^^^

// @lsp.type.builtinType (#2ac3de, LSP)
function semanticBuiltinTypePerGroup(input: string): number {}
//                                          ^^^^^^   ^^^^^^

// @lsp.type.enum (#2ac3de, LSP)
enum SemanticEnumPerGroup {}
//   ^^^^^^^^^^^^^^^^^^^^

// @lsp.type.typeAlias (#2ac3de, LSP)
type SemanticAliasPerGroup = "t";
//   ^^^^^^^^^^^^^^^^^^^^^
let semanticAliasValuePerGroup: SemanticAliasPerGroup = "t";
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

// @lsp.typemod.enumMember.defaultLibrary (#7dcfff, LSP, server-dependent)
const defaultLibraryEnumMemPerGroup = Node.DOCUMENT_POSITION_FOLLOWING;
//                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

// @string.regexp (#b4f9f8)
const regexpPatternPerGroup = /tokyo\d+/;
//                             ^^^^^^^^

// @punctuation.delimiter (#8c8c8c)
type DelimiterRecordPerGroup = { left: string; right: string };
//                                   ^              ^
const delimiterUnionPerGroup: string | number = 1;
const delimiterDotPerGroup = delimiterUnionPerGroup.toString();
//                                                 ^

// @punctuation.special (#8c8c8c)
type OptionalPerGroup = { name?: string };
//                             ^
const maybeUserPerGroup: OptionalPerGroup = {};
const optionalNamePerGroup = maybeUserPerGroup?.name!;
//                                            ^^    ^

// @keyword (#8c8c8c)
let keywordCountPerGroup = 1;
//^

// @keyword.coroutine (#8c8c8c)
async function keywordCoroutinePerGroup(): Promise<string> {
  return await Promise.resolve("tokyo");
  //     ^^^^^
}

// @keyword.return (#8c8c8c)
function keywordReturnPerGroup(input: string): string {
  return input.trim();
  //^^^^
}

// @keyword.function (#8c8c8c)
function keywordFunctionPerGroup(): void {}
//^^^^^^

// @keyword.conditional (#8c8c8c)
const conditionalInputPerGroup = 2;
if (conditionalInputPerGroup > 1) {
  //^
  const conditionalBranchPerGroup = "greater";
} else {
  //^^
  const conditionalFallbackPerGroup = "smaller";
}

// @keyword.repeat (#8c8c8c)
for (const repeatItemPerGroup of ["tokyo"]) {
  //^
  continue;
  //^^^^^^
}

// @keyword.exception (#8c8c8c)
try {
  throw new Error("boom");
  //^^^
} catch (caughtPerGroup) {
  //^^^
} finally {
  //^^^^^
}

// @keyword.import (#8c8c8c)
import { readFileSync as importedReadPerGroup } from "node:fs";
//^^^^                                          ^^^^

// @keyword.directive (#8c8c8c)
("use strict");
//^^^^^^^^^^

// @keyword.operator (#8c8c8c)
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

// @keyword.type (#8c8c8c)
interface KeywordTypeInterfacePerGroup {}
//^^^^^^^
enum KeywordTypeEnumPerGroup {}
//^^
namespace KeywordTypeNamespacePerGroup {}
//^^^^^^^

// @keyword.modifier (#8c8c8c)
class KeywordModifierPerGroup {
  public readonly label = "tokyo";
  //^^^^ ^^^^^^^^
  private hiddenCount = 1;
  //^^^^^
}

// @keyword.conditional.ternary (#8c8c8c)
const ternaryValuePerGroup = true ? "yes" : "no";
//                                ^       ^

// @operator (#8c8c8c)
const operatorValuePerGroup = 2 + 3 * 4 === 14 && 14 > 0;
//                              ^   ^   ^^^    ^^    ^

// @constructor (#8c8c8c)
class ConstructorTargetPerGroup {
  constructor() {}
  //^^^^^^^^^^^
}
const constructorValuePerGroup = new ConstructorTargetPerGroup();
//                                   ^^^^^^^^^^^^^^^^^^^^^^^^^

// @string.escape (#8c8c8c)
const escapedBannerPerGroup = "tokyo\nnight\tmode";
//                                  ^^     ^^
const escapedPathPerGroup = "one\\two\\three";
//                              ^^   ^^

// @lsp.type.keyword (#8c8c8c, LSP)
if (true) {
  //^
}

// @lsp.typemod.keyword.async (#8c8c8c, LSP)
async function semanticAsyncKeywordPerGroup(): Promise<number> {
  //^
  return await Promise.resolve(42);
}

// @lsp.type.escapeSequence (#8c8c8c, LSP)
const semanticEscapePerGroup = "line-one\nline-two\tindent";
//                                      ^^        ^^

// @lsp.type.operator (#8c8c8c, LSP)
const semanticOperatorValuePerGroup = 5 * 2 - 1;
//                                      ^   ^

// @function (#7aa2f7)
function namedFunctionPerGroup() {
  //     ^^^^^^^^^^^^^^^^^^^^^
}

// @function.call (#7aa2f7)
namedFunctionPerGroup();
//^^^^^^^^^^^^^^^^^^^

// @function.method (#7aa2f7)
class MethodCarrierPerGroup {
  combine() {
    //^^^
  }
}

// @function.method.call (#7aa2f7)
new MethodCarrierPerGroup().combine();
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
const callableVariablePerGroup = () => {};
//    ^^^^^^^^^^^^^^^^^^^^^^^^

// @lsp.typemod.function.defaultLibrary (#7aa2f7, LSP)
const semanticDefaultFunctionPerGroup = parseFloat("3.14");
//                                      ^^^^^^^^^^

// @lsp.typemod.method.defaultLibrary (#7aa2f7, LSP)
console.log("");
//      ^^^

// @variable.member (#c0caf5)
const memSourcePerGroup = { name: "" };
//                          ^^^^
const memNamePerGroup = memSourcePerGroup.name;
//                                        ^^^^

// @lsp.type.property (#73daca, LSP)
const semanticPropertySourcePerGroup: { title: string } = {
  //                                    ^^^^^
  title: "night",
  //^^^
};
const semanticPropertyValuePerGroup = semanticPropertySourcePerGroup.title;
//                                                                   ^^^^^

// @string (#9ece6a)
const plainStringCityPerGroup = "tokyo";
//                              ^^^^^^^

// @lsp.type.string (#9ece6a, LSP)
const semanticStringPerGroup = "semantic string";
//                             ^^^^^^^^^^^^^^^^^

// @variable.parameter (#c0caf5)
function parameterValuePerGroup(
  leftPartPerGroup: string,
  //^^^^^^^^^^^^^^
): string {
  return leftPartPerGroup;
}

// @lsp.type.parameter (#c0caf5, LSP)
function semanticParameterPerGroup(
  firstSemanticPerGroup: string,
  //^^^^^^^^^^^^^^^^^^^
): string {
  return firstSemanticPerGroup;
}

// @constant (#7dcfff)
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

// @lsp.type.enumMember (#7dcfff, LSP)
enum LocalEnumMemPerGroup {
  First = 1,
  //^^^
}
const localEnumMemValuePerGroup = LocalEnumMemPerGroup.First;
//                                                     ^^^^^

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
  chain() {
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
