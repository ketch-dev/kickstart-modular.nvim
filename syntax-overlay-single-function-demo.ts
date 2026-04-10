import * as PathModule from "node:path";

export async function showSyntaxOverlayDemo(): Promise<void> {
  "use strict";

  // This function intentionally gathers examples for the main overlay color families.
  // It is a playground file, so one unresolved symbol is left on purpose at the end.

  function traceDecorator<T extends Function>(target: T): T {
    return target;
  }

  function blendName(left: string, right: string): string {
    return `${left}-${right}`;
  }

  type UserName = string;

  interface UserRecord {
    name: UserName;
    active: boolean;
  }

  type Config = {
    theme: string;
    retries: number;
  };

  enum Status {
    Ready = 1,
  }

  @traceDecorator
  class DecoratedExample {
    value = 1;

    render(label: string): string {
      return `${label}:${this.value}`;
    }
  }

  const HTTP_OK = 200;
  const retryCount = 3;
  const isReady = true;
  const sampleName = "forest";
  const sampleRegex = /forest-\d+/gi;

  const config: Config = { theme: "noir", retries: retryCount };
  const user: UserRecord = {
    name: blendName(sampleName, "trail"),
    active: isReady,
  };
  const memberName = user.name;
  const memberTheme = config.theme;

  const queue = new Map<string, number>();
  const pending: Promise<string> = Promise.resolve(memberName);
  queue.set(memberName, Status.Ready);

  const pathLabel = PathModule.join("forest", memberTheme);
  const dateLabel = new Intl.DateTimeFormat("en-US").format(new Date());

  if (isReady && retryCount > 0) {
    for (const step of [1, 2, 3]) {
      if (!sampleRegex.test(`${sampleName}-${step}`)) {
        continue;
      }

      const line = new DecoratedExample().render(`${pathLabel}:${dateLabel}`);
      console.log(line, queue.get(memberName), pending, HTTP_OK);
      break;
    }
  } else {
    throw new Error("demo failed");
  }

  outerLoop: for (const attempt of [0, 1]) {
    if (attempt === 1) {
      break outerLoop;
    }
  }

  const unresolvedValue = MISSING_PALETTE_SYMBOL;
  console.log(unresolvedValue);
}
