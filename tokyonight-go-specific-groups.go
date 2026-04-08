package main

// Declared Go type names on the left side of type use bright cyan because they introduce new named types.
// Color: #2ac3de
// Highlight groups: @type.definition (#2ac3de)
type Score int
type Status string
type Profile struct {
  Name    string
  Count   int
  Enabled bool
}
type Reader interface {
  Read(p []byte) (n int, err error)
}

// Struct field names and selector fields share teal because both are property-like member names.
// Color: #73daca
// Highlight groups: @property (#73daca)
func useProfile(profile Profile) {
  profile.Name = "tokyo"
  profile.Count = profile.Count + 1
  profile.Enabled = true
}

// Rune literals use the text-green family, but Go gives them their own dedicated character capture.
// Color: #9ece6a
// Highlight groups: @character (#9ece6a)
var firstRune = 'g'
var secondRune = 'o'
var newlineRune = '\n'

// Floating-point literals get a dedicated numeric capture so decimals stand apart from integer-only numbers.
// Color: #ff9e64
// Highlight groups: @number.float (#ff9e64)
var pi = 3.14
var half = 0.5
var tiny = 1e-9

func main() {
  profile := Profile{Name: "night", Count: 2, Enabled: false}
  useProfile(profile)

  _, _, _ = firstRune, secondRune, newlineRune
  _, _, _ = pi, half, tiny
}
