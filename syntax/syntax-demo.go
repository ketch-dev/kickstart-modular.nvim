package forestdemo

import (
	fmtpkg "fmt"
	regexppkg "regexp"
	timepkg "time"
)

// In Go Treesitter, @module applies to package identifiers in package/import declarations.

// UserName is a lightweight type alias used in the demo.
type UserName string

// Renderer demonstrates interface and method-element highlighting.
type Renderer interface {
	Render(label string) string
}

// UserRecord demonstrates field names and builtin types.
type UserRecord struct {
	Name   UserName
	Active bool
}

// Config demonstrates struct fields and ordinary type definitions.
type Config struct {
	Theme   string
	Retries int
}

type demoRunner struct {
	title string
	count int
}

func (runner *demoRunner) Render(label string) string {
	return fmtpkg.Sprintf("%s:%d", label, runner.count)
}

// ShowSyntaxOverlayDemo gathers examples for the main Go-side highlight families.
func ShowSyntaxOverlayDemo() {
	const HTTPOK = 200

	retryCount := 3
	retryRatio := 1.5
	isReady := true
	sampleName := "forest"
	markerRune := 'g'
	samplePattern := regexppkg.MustCompile(`forest-\d+`)

	config := Config{Theme: "noir", Retries: retryCount}
	user := UserRecord{Name: UserName(sampleName), Active: isReady}

	memberName := user.Name
	memberTheme := config.Theme
	queue := make(map[string]int)
	queue[string(memberName)] = HTTPOK

	runner := new(demoRunner)
	runner.title = "path"
	runner.count = retryCount

	var renderer Renderer = runner
	pathLabel := fmtpkg.Sprintf("%s:%s", memberTheme, timepkg.Now().Format(timepkg.RFC3339))

	if isReady && retryCount > 0 {
		go fmtpkg.Println("background", markerRune)

		for _, step := range []int{1, 2, 3} {
			candidate := fmtpkg.Sprintf("%s-%d", sampleName, step)
			if !samplePattern.MatchString(candidate) {
				continue
			}

			line := renderer.Render(pathLabel)
			fmtpkg.Printf("line=%s count=%d ready=%t ratio=%.1f\n", line, queue[string(memberName)], isReady, retryRatio)
			break
		}
	} else {
		panic("demo failed")
	}

outerLoop:
	for attempt := 0; attempt < 2; attempt++ {
		if attempt == 1 {
			break outerLoop
		}
	}

	var maybeNil error = nil
	_ = maybeNil
}
