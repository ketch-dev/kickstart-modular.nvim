// TokyoNight Go highlight demo.
// This file is intentionally dense and annotated for highlight inspection.

package main

// @keyword.import (#7dcfff), @module (#7dcfff), @string (#9ece6a)
import (
  "fmt"
  "regexp"
)

// Reader demonstrates @comment.documentation (#565f89), @keyword.type (#9d7cd8),
// @type.definition (#2ac3de), @function.method (#7aa2f7),
// @variable.parameter (#e0af68), @type.builtin (#27a1b9), and @keyword.return (#9d7cd8).
type Reader interface {
  Read(p []byte) (n int, err error)
}

// Item demonstrates @type.definition (#2ac3de), @property (#73daca),
// @variable.member (#73daca), and @type (#2ac3de).
type Item struct {
  Name  string
  Count int
}

// Status demonstrates @constant (#ff9e64), @constant.builtin (#2ac3de), and @number (#ff9e64).
const (
  StatusOK = iota
  StatusErr
)

// NewItem demonstrates @keyword.function (#bb9af7), @function (#7aa2f7),
// @variable.parameter (#e0af68), @type (#2ac3de), @type.builtin (#27a1b9),
// @string (#9ece6a), @operator (#89ddff), and @keyword.return (#9d7cd8).
func NewItem(name string) Item {
  return Item{Name: name, Count: 1}
}

// makeBuffer demonstrates @keyword.function (#bb9af7), @function (#7aa2f7),
// and a user-defined constructor-like call for @constructor (#bb9af7).
func makeBuffer() []byte {
  return []byte("buf")
}

// String demonstrates @keyword.function (#bb9af7), @function.method (#7aa2f7),
// @property (#73daca), and @type (#2ac3de) via selector fields and receiver types.
func (it Item) String() string {
  return fmt.Sprintf("%s:%d", it.Name, it.Count)
}

// useValues demonstrates @keyword.function (#bb9af7), @function (#7aa2f7),
// @variable (#c0caf5), @variable.parameter (#e0af68), @type.builtin (#27a1b9),
// @keyword.conditional (#bb9af7), @keyword.return (#9d7cd8), and @constant.builtin (#2ac3de).
func useValues(v any, ok bool) error {
  if ok {
    return nil
  }
  return fmt.Errorf("bad value: %v", v)
}

// demoRecover demonstrates @keyword.function (#bb9af7), @keyword (#9d7cd8),
// @function.builtin (#2ac3de), and @keyword.return (#9d7cd8).
func demoRecover() (msg string) {
  defer func() {
    if recovered := recover(); recovered != nil {
      msg = fmt.Sprint(recovered)
    }
  }()
  panic("boom")
}

func main() {
  // @comment (#565f89), @spell (no fg), @string (#9ece6a), @string.escape (#bb9af7),
  // @character (#9ece6a), @number (#ff9e64), @number.float (#ff9e64), @boolean (#ff9e64), @type.builtin (#27a1b9)
  var title string = "tokyo\nnight"
  var letter rune = 'g'
  var ratio float64 = 3.14
  var imagUnit = 2i
  var enabled bool = true
  var ch chan int = make(chan int, 1)
  values := map[string]int{"tokyo": 1, "night": 2}

  // @constructor (#bb9af7), @function.call (#7aa2f7), @function.method.call (#7aa2f7), @function.builtin (#2ac3de)
  item := NewItem("demo")
  buf := makeBuffer()
  ptr := new(Item)
  ptr.Count = len(buf)
  ptr.Name = item.String()

  // @string.regexp (#b4f9f8), @module (#7dcfff), @function.method.call (#7aa2f7), @string (#9ece6a)
  re := regexp.MustCompile(`tokyo-\d+`)
  matched := re.MatchString("tokyo-42")

  // @label (#7aa2f7), @keyword.repeat (#bb9af7), @keyword.conditional (#bb9af7),
  // @keyword (#9d7cd8), @operator (#89ddff), @number (#ff9e64)
loop:
  for index := 0; index < 4; index++ {
    switch index {
    case 0:
      continue
    case 1:
      fallthrough
    default:
      if matched && index > 2 {
        break loop
      }
    }
  }

  // @keyword.coroutine (#9d7cd8), @keyword (#9d7cd8), @keyword.conditional (#bb9af7)
  go func() {
    ch <- values["tokyo"]
  }()

  select {
  case got := <-ch:
    fmt.Println(title, letter, ratio, imagUnit, enabled, got, values["night"], item.Name)
  default:
    goto done
  }

done:
  // @function.builtin (#2ac3de), @constant (#ff9e64),
  // @constant.builtin (#2ac3de), @boolean (#ff9e64), @property (#73daca)
  values["extra"] = append([]int{StatusOK}, StatusErr)[0]
  clear(values)
  _ = cap(buf)
  _ = copy(buf, []byte("x"))
  delete(values, "tokyo")
  _ = complex(1, 2)
  _ = real(complex(1, 2))
  _ = imag(complex(1, 2))
  _ = min(1, 2)
  _ = max(1, 2)
  _ = matched == false
  _ = useValues(item.Name, enabled)
  _ = demoRecover()
  println(ptr.Name)
  _ = ptr
}
