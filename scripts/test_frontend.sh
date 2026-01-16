#!/bin/bash
set -e

GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m" # No Color

echo -e "${YELLOW}Checking HTML validity...${NC}"
if npx html-validate public/**/*.html; then
  echo -e "${GREEN}HTML validation completed successfully.${NC}"
else
  echo -e "${RED}HTML validation failed.${NC}"
  exit 1
fi

echo -e "${YELLOW}Checking CSS validity...${NC}"
if npx stylelint "public/**/*.css"; then
  echo -e "${GREEN}CSS validation completed successfully.${NC}"
else
  echo -e "${RED}CSS validation failed.${NC}"
  exit 1
fi

echo -e "${YELLOW}Checking JavaScript validity...${NC}"
if npx eslint "public/**/*.js"; then
  echo -e "${GREEN}JavaScript validation completed successfully.${NC}"
else
  echo -e "${RED}JavaScript validation failed.${NC}"
  exit 1
fi

echo -e "${YELLOW}Checking broken links...${NC}"
if npx linkinator public --silent; then
  echo -e "${GREEN}Link checking completed successfully.${NC}"
else
  echo -e "${RED}Broken links found.${NC}"
  exit 1
fi

echo -e "${YELLOW}Checking basic UI security...${NC}"
if grep -R 'type="text".*password' public; then
  echo -e "${RED}Password field must not be type=text${NC}"
  exit 1
else
  echo -e "${GREEN}UI security check passed.${NC}"
fi

echo -e "${GREEN}All frontend tests completed successfully!${NC}"
