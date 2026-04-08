// @keyword.directive (#7dcfff)
"use strict";

// @comment (#565f89), @spell (no fg)
// TokyoNight TypeScript highlight demo for plain .ts files.

/**
 * @comment.documentation (#565f89), @spell (no fg)
 * This file is intentionally dense and is meant for highlight inspection,
 * not as production code.
 */

// @keyword.import (#7dcfff), @character.special (#2ac3de), @module (#7dcfff), @string (#9ece6a)
import * as FS from 'node:fs';

// @keyword.import (#7dcfff), @string.special.url (underline), @type (#2ac3de)
import PathModule = require('node:path');

// @keyword.import (#7dcfff), @module (#7dcfff), @string (#9ece6a)
import { readFileSync as readText } from 'node:fs';

// @attribute (#7dcfff), @keyword.function (#bb9af7), @function (#7aa2f7), @variable.parameter (#e0af68), @type.builtin (#27a1b9), @keyword.return (#9d7cd8)
function sealed<T extends Function>(target: T): T {
  return target;
}

// @attribute (#7dcfff), @keyword.function (#bb9af7), @function (#7aa2f7), @variable.parameter (#e0af68), @type.builtin (#27a1b9), @keyword.return (#9d7cd8)
function field(_target: object, _key: string): void {}

// @keyword.type (#9d7cd8), @type (#2ac3de), @variable.member (#73daca), @function.method (#7aa2f7), @variable.parameter (#e0af68)
interface Box<T> {
  value: T;
  run?(input: T): T;
}

// @keyword.type (#9d7cd8), @type (#2ac3de), @constant (#ff9e64), @number (#ff9e64)
enum Mode {
  OFF = 0,
  ON = 1,
}

// @keyword.type (#9d7cd8), @module (#7dcfff), @keyword.import (#7dcfff), @constant (#ff9e64), @boolean (#ff9e64)
namespace DemoNamespace {
  export const ENABLED = true;
}

// @keyword.import (#7dcfff), @module (#7dcfff), @keyword.type (#9d7cd8), @type (#2ac3de), @variable.member (#73daca)
declare global {
  interface Window {
    demoValue: number;
  }
}

// @keyword (#9d7cd8), @type (#2ac3de), @keyword.operator (#89ddff), @keyword.conditional.ternary (#bb9af7)
type ElementType<T> = T extends (infer U)[] ? U : T;

// @keyword.function (#bb9af7), @function (#7aa2f7), @variable.parameter (#e0af68), @type.builtin (#27a1b9), @keyword.return (#9d7cd8), @keyword.operator (#89ddff)
function isString(value: unknown): value is string {
  return typeof value === 'string';
}

// @keyword.function (#bb9af7), @function (#7aa2f7), @variable.parameter (#e0af68), @keyword.exception (#bb9af7), @keyword.return (#9d7cd8)
function assertString(value: unknown): asserts value is string {
  if (!isString(value)) {
    throw new TypeError('expected a string');
  }
}

// @attribute (#7dcfff), @keyword.type (#9d7cd8), @keyword.modifier (#9d7cd8), @type (#2ac3de), @variable.member (#73daca), @constructor (#bb9af7)
@sealed
abstract class ExampleBase {
  public static readonly VERSION: number = 1;
  protected abstract label?: string;

  constructor(public readonly id: number) {}

  // @function.method (#7aa2f7), @variable.parameter (#e0af68), @string (#9ece6a), @keyword.return (#9d7cd8), @none (none), @punctuation.special (#89ddff), @variable.builtin (#f7768e)
  greet(message: string): string {
    return `${message} ${this.id}`;
  }
}

// @attribute (#7dcfff), @keyword.type (#9d7cd8), @type (#2ac3de), @keyword (#9d7cd8), @keyword.modifier (#9d7cd8), @variable.member (#73daca)
@sealed
class Example extends ExampleBase implements Box<string> {
  @field
  private cache?: Map<string, number>;

  public value = 'box';

  private ready!: boolean;

  constructor(public readonly name: string) {
    super(1);
    this.ready = true;
    this.cache = new Map<string, number>();
  }

  // @keyword (#9d7cd8), @function.method (#7aa2f7), @keyword.return (#9d7cd8), @variable.member (#73daca), @variable.builtin (#f7768e)
  override greet(message: string): string {
    const data = { message, name: this.name, Example };
    return `${super.greet(message)} ${data.name}`;
  }

  run(input: string): string {
    return input.toUpperCase();
  }
}

// @constant (#ff9e64), @number (#ff9e64)
const HTTP_OK = 200;

// @function (#7aa2f7), @variable.parameter (#e0af68), @type (#2ac3de), @keyword.return (#9d7cd8)
const makeUpper = (input: string): string => input.toUpperCase();

// @keyword.coroutine (#9d7cd8), @keyword.function (#bb9af7), @function (#7aa2f7), @variable.parameter (#e0af68), @type.builtin (#27a1b9), @keyword.return (#9d7cd8)
async function loadValue(value: number): Promise<number> {
  return await Promise.resolve(value + 1);
}

// @variable (#c0caf5), @constructor (#bb9af7), @function.call (#7aa2f7), @function.method.call (#7aa2f7), @function.builtin (#2ac3de)
const example = new Example('tokyo');
const upper = makeUpper(example.greet('night'));
const parsed = parseInt('10', 10);

// @string (#9ece6a), @string.escape (#bb9af7)
const escapedText = 'tokyo\nnight';

// @string.regexp (#b4f9f8), @character.special (#2ac3de), @operator (#89ddff)
const pattern = /tokyo\d+/gi;

// @keyword.operator (#89ddff), @type (#2ac3de), @constant.builtin (#2ac3de), @boolean (#ff9e64)
const maybeRecord = { kind: 'demo' } as const satisfies { kind: string };
const nothing = null;
const missing = undefined;

// @keyword.conditional (#bb9af7), @keyword.operator (#89ddff), @variable.builtin (#f7768e), @module.builtin (#f7768e), @function.method.call (#7aa2f7)
if ('name' in example && example instanceof Example && typeof upper === 'string') {
  console.log(Intl.DateTimeFormat().format(new Date()), window.document, self, FS, PathModule, readText, pattern);
}

// @keyword.exception (#bb9af7), @function.builtin (#2ac3de), @string (#9ece6a)
try {
  assertString(example.name);
  delete (maybeRecord as { kind?: string }).kind;
} catch (error) {
  console.error(error);
} finally {
  console.info('cleanup');
}

// @label (#7aa2f7), @keyword.repeat (#bb9af7), @keyword.conditional (#bb9af7), @number (#ff9e64)
outer: for (let index = 0; index < 3; index += 1) {
  if (index === 2) {
    break outer;
  }
}

// @keyword.conditional.ternary (#bb9af7)
const state = example.name ? Mode.ON : Mode.OFF;

// @variable.parameter (#e0af68), @punctuation.bracket (#a9b1d6), @punctuation.delimiter (#89ddff)
const first: ElementType<string[]> = example.run('demo');
void loadValue(parsed);
void escapedText;
void HTTP_OK;
void DemoNamespace.ENABLED;
void nothing;
void missing;
void state;
void first;

export { Example, Mode };
