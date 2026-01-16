
```
COS_journaA/
|
├── public/
│   ├── index.html
│   ├── css/
│   ├── js/
│   ├── images/
│   └── api/
|
├── src/
│   ├── php/
│   └── sql/
|
├── tests/
│   ├── frontend/
│   ├── backend/
│   ├── database/
│   ├── integration/
│   └── security/
|
├── scripts/
│   └── test_frontend.sh
|
├── .github/
│   └── workflows/
│       └── frontend-test.yml
|
├── package.json
└── directory.md
```

```
# 1. Validate HTML
html-validate public/**/*.html

# 2. Validate CSS
stylelint public/css/**/*.css

# 3. Check JS
eslint public/js/**/*.js

# 4. Check broken links
linkinator public --silent

# 5. Security pattern checks
grep -R 'type="text".*password' public && exit 1
grep -R '<script>alert' public && exit 1

cos_journa/
├── public/
│   ├── index.html
│   ├── pricing.html
│   ├── blog/
│   ├── docs/
│   ├── css/
│   └── js/
│
├── scripts/
│   └── test_frontend.sh
│
└── .github/workflows/
    └── frontend-tests.yml
```

```
                            Edit frontend
                            ↓
                            git push
                            ↓
                            (pre-push hook runs tests)
                            ↓
                            GitHub Actions runs tests
                            ↓
                            Manual deploy approval
```
---
Got it.
You want the **frontend-only testing guide**, rewritten **from the beginning**, **very simply**, **step by step**, with **plain language**, focused only on **frontend testing**, not Git hooks or backend.

Below is the **complete frontend testing setup**, explained as if this is your first time doing it.

---

# What you are building right now

At this stage, your project is:

* Static frontend only
* HTML, CSS, and vanilla JavaScript
* Public pages (landing, blog, docs, pricing, login UI)
* No backend
* No database
* No real authentication

Your goal is **not perfection**.
Your goal is to **catch obvious mistakes early** and **avoid deploying broken pages**.

---

# What frontend testing means (in simple terms)

Frontend testing here means automatically checking:

1. Your HTML is valid
2. Your CSS has no syntax errors
3. Your JavaScript has no obvious errors
4. Your pages do not reference missing files or broken links
5. You are not doing obviously unsafe things in UI code

That’s it.

---

# Step 1: Prepare your project

Your project should look like this:

```
cos_journa/
  public/
    home.html
```

We are going to **add files**, not change existing ones.

---

# Step 2: Install Node.js (tools only)

Node.js is required **only to run testing tools**.
It is **not part of your website**.

Check if it is installed:

```
node -v
npm -v
```

If both commands print versions, you are ready.
If not, install Node.js LTS from the official site.

---

# Step 3: Create a package.json file

From the root of your project, run:

```
npm init -y
```

This creates a file called `package.json`.

This file only exists to manage **development tools**.

---

# Step 4: Install frontend testing tools

Run this command once:

```
npm install --save-dev html-validate stylelint eslint linkinator
```

What each tool does:

* html-validate checks HTML files
* stylelint checks CSS files
* eslint checks JavaScript files
* linkinator checks for broken links and missing files

These tools do not affect your website.

---

# Step 5: Configure the tools (minimal rules)

We now create small configuration files so the tools know what to check.

---

## Step 5.1: HTML validation config

Create a file called:

```
.htmlvalidate.json
```

Put this inside it:

```
{
  "extends": ["html-validate:recommended"]
}
```

This tells the tool to check basic HTML correctness.

---

## Step 5.2: CSS validation config

Create a file called:

```
.stylelintrc.json
```

Put this inside it:

```
{
  "rules": {
    "block-no-empty": true,
    "color-no-invalid-hex": true,
    "declaration-block-no-duplicate-properties": true
  }
}
```

This catches common CSS mistakes.

---

## Step 5.3: JavaScript validation config

Create a file called:

```
.eslintrc.json
```

Put this inside it:

```
{
  "env": {
    "browser": true,
    "es2021": true
  },
  "extends": ["eslint:recommended"],
  "rules": {
    "no-undef": "error",
    "no-unused-vars": "warn"
  }
}
```

This catches missing variables and obvious JS errors.

---

# Step 6: Create one frontend test script

This is the most important part.

Create a folder:

```
scripts/
```

Inside it, create a file called:

```
scripts/test_frontend.sh
```

Put this inside the file:

```
#!/bin/sh
set -e

echo "Checking HTML"
npx html-validate public/**/*.html

echo "Checking CSS"
npx stylelint "public/**/*.css"

echo "Checking JavaScript"
npx eslint "public/**/*.js"

echo "Checking broken links"
npx linkinator public --silent

echo "Checking basic UI security rules"

if grep -R 'type="text".*password' public; then
  echo "Password field must not be type=text"
  exit 1
fi

echo "Frontend tests passed"
```

This script:

* Runs all frontend checks
* Stops immediately if anything fails
* Prints clear messages

---

# Step 7: Make the test script runnable

Run this once:

```
chmod +x scripts/test_frontend.sh
```

---

# Step 8: Run frontend tests locally

Now test everything by running:

```
./scripts/test_frontend.sh
```

If something fails:

* Read the error
* Fix the frontend code
* Run it again

Do not move on until this passes.

---

# Step 9: Automate frontend testing on GitHub

Now we make GitHub run the same checks.

Create this folder structure:

```
.github/
  workflows/
```

Create this file:

```
.github/workflows/frontend-tests.yml
```

Put this inside it:

```
name: Frontend Tests

on:
  push:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 18

      - run: npm install
      - run: ./scripts/test_frontend.sh
```

Now:

* Every push runs frontend tests automatically
* Failures block deployment

---

# Step 10: What happens when tests fail

If frontend tests fail:

* GitHub marks the push as failed
* Deployment is blocked
* Nothing goes live
* You fix the issue and push again

No manual cleanup required.

---

# Step 11: Manual deployment approval

In Vercel:

* Production deployments require manual approval
* Tests must pass first
* You decide when to deploy

This protects your public site.

---

# Final daily workflow (simple)

1. Edit frontend files
2. Run `git push origin main`
3. Tests run automatically
4. Fix errors if any
5. Approve deployment when ready

You do not need to remember test commands.

---

# Why this is the correct setup for this stage

* No frameworks
* Minimal tools
* Clear errors
* No backend assumptions
* Easy to extend later

This is a **professional but beginner-safe frontend testing workflow**.

---

If you want next, I can:

* Walk through a real HTML file and show what would fail
* Add accessibility checks
* Simplify rules even further

Just tell me the next step you want to understand.
