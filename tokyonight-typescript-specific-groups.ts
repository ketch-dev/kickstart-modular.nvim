// Directive-like string fragments use cyan because they behave like parser/runtime switches instead of ordinary data.
// Color: #7dcfff
// Highlight groups: @keyword.directive (#7dcfff)
"use strict";
("use strict");

// Require-source strings are underlined instead of recolored so module targets still read like strings but stay visually distinct.
// Color/style: underline
// Highlight groups: @string.special.url (underline)
import FsModule = require('node:fs');
import PathModule = require('node:path');

declare const window: unknown;
declare const document: unknown;
declare const self: unknown;
declare const module: unknown;

// Special marker tokens such as namespace-import stars and regex flags share bright cyan because they are compact signal tokens.
// Color: #2ac3de
// Highlight groups: @character.special (#2ac3de)
import * as StarModule from 'node:fs';
const flaggedPattern = /tokyo\d+/gi;

// Decorators share cyan because they annotate declarations from the outside instead of acting like ordinary values.
// Color: #7dcfff
// Highlight groups: @attribute (#7dcfff)
function sealed<T extends Function>(target: T): T {
  return target;
}

function track(_target: object, _key: string): void {}

@sealed
class DecoratedExample {
  @track
  value = 1;
}

// TS access and mutability modifiers share soft violet because they refine declarations rather than control flow.
// Color: #9d7cd8
// Highlight groups: @keyword.modifier (#9d7cd8)
abstract class ModifiedBase {
  protected abstract name?: string;
}

class ModifiedExample extends ModifiedBase {
  public readonly id = 1;
  private cache!: Map<string, number>;
  protected name = 'tokyo';
}

// Exception-flow keywords use the stronger violet because they reroute control abruptly.
// Color: #bb9af7
// Highlight groups: @keyword.exception (#bb9af7)
try {
  throw new Error('boom');
} catch (error) {
  console.error(error);
} finally {
  console.info('cleanup');
}

// The ternary punctuation is promoted to the same violet as other branch-starting syntax.
// Color: #bb9af7
// Highlight groups: @keyword.conditional.ternary (#bb9af7)
const ternarySource = Math.random() > 0.5 ? 'tokyo' : 'night';
const ternaryMode = ternarySource ? ternarySource : 'fallback';

// Type-oriented operator keywords use operator cyan because they behave more like syntax operators than declarations.
// Color: #89ddff
// Highlight groups: @keyword.operator (#89ddff)
const rawValue: unknown = { kind: 'demo' };
const typedRecord = rawValue as { kind?: string };
const typedCheck = { kind: 'tokyo' } satisfies { kind: string };
const keyName: keyof typeof typedRecord = 'kind';
const isObject = typeof rawValue === 'object' && rawValue instanceof Object && 'kind' in typedRecord;

// Optional and non-null punctuation markers use the same operator cyan because they are tiny high-signal syntax markers.
// Color: #89ddff
// Highlight groups: @punctuation.special (#89ddff)
type OptionalUser = { name?: string; title?: string };
const maybeUser: OptionalUser = {};
const optionalName = maybeUser?.name ?? 'anonymous';
const forcedLength = optionalName!.length;

// TokyoNight intentionally leaves the ${ ... } container itself uncolored so only the embedded expression carries emphasis.
// Color: none
// Highlight groups: @none (none)
const plainContainer = `${optionalName}-${typedRecord.kind ?? 'none'}`;

// Builtin namespaces like Intl use red so they read like ambient platform objects, not project modules.
// Color: #f7768e
// Highlight groups: @module.builtin (#f7768e)
const dateFormatter = Intl.DateTimeFormat();
const numberFormatter = Intl.NumberFormat();

// Builtin receiver/global variables use the same red because they come from the runtime environment, not local scope.
// Color: #f7768e
// Highlight groups: @variable.builtin (#f7768e)
class BuiltinCollector {
  title = 'tokyo';

  report(): void {
    console.log(this.title, window, document, self, module, arguments.length);
  }
}

const builtinCollector = new BuiltinCollector();

void FsModule;
void PathModule;
void StarModule;
void flaggedPattern;
void DecoratedExample;
void ModifiedExample;
void ternaryMode;
void typedCheck;
void keyName;
void isObject;
void forcedLength;
void plainContainer;
void dateFormatter;
void numberFormatter;
void builtinCollector;

export {};
