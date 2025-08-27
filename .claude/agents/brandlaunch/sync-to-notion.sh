#!/bin/bash
# Sync existing MD files to Notion after brand generation
# Usage: ./sync-to-notion.sh "Project Name"

PROJECT_NAME="${1:-Apertur Brand Launch}"
PROJECT_DIR="projects/$PROJECT_NAME"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check if Notion token is set
if [ -z "$NOTION_TOKEN" ]; then
    echo "❌ Error: NOTION_TOKEN environment variable not set"
    echo "Please set: export NOTION_TOKEN='your_token_here'"
    exit 1
fi

echo "🚀 Syncing $PROJECT_NAME to Notion..."

# 1. Create main project page
echo "Creating main project page..."
MAIN_PAGE=$("$SCRIPT_DIR/mcp-notion.sh" create-page "" "$PROJECT_NAME" "")
MAIN_PAGE_ID=$(echo "$MAIN_PAGE" | grep -o '"id":"[^"]*' | sed 's/"id":"//')
echo "✅ Main page created: $MAIN_PAGE_ID"

# 2. Create folder structure
echo "Creating folder structure..."
FOLDERS=(
    "01 Market Research"
    "02 Brand Strategy"
    "03 Visual Identity"
    "04 Content Production"
    "05 Marketing Copy"
    "06 Web Assets"
    "07 Project Management"
)

declare -A FOLDER_IDS
for folder in "${FOLDERS[@]}"; do
    echo "  Creating: $folder"
    RESULT=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$MAIN_PAGE_ID" "$folder" "")
    FOLDER_ID=$(echo "$RESULT" | grep -o '"id":"[^"]*' | sed 's/"id":"//')
    FOLDER_IDS["$folder"]=$FOLDER_ID
done

# 3. Add content to folders
echo "Adding content to folders..."

# Market Intelligence Report
if [ -f "$PROJECT_DIR/01_Market_Research/Market_Intelligence_Report_$PROJECT_NAME.md" ]; then
    echo "  Adding Market Intelligence Report..."
    MR_ID="${FOLDER_IDS["01 Market Research"]}"
    MR_DOC=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$MR_ID" "Market Intelligence Report" "")
    MR_DOC_ID=$(echo "$MR_DOC" | grep -o '"id":"[^"]*' | sed 's/"id":"//')
    
    # Add content from MD file
    CONTENT=$(cat "$PROJECT_DIR/01_Market_Research/Market_Intelligence_Report_$PROJECT_NAME.md")
    "$SCRIPT_DIR/mcp-notion.sh" add-content "$MR_DOC_ID" "paragraph" "" "$CONTENT"
fi

# Brand Strategy Document
if [ -f "$PROJECT_DIR/02_Brand_Strategy/Brand_Strategy_Document_$PROJECT_NAME.md" ]; then
    echo "  Adding Brand Strategy Document..."
    BS_ID="${FOLDER_IDS["02 Brand Strategy"]}"
    BS_DOC=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$BS_ID" "Brand Strategy Document" "")
    BS_DOC_ID=$(echo "$BS_DOC" | grep -o '"id":"[^"]*' | sed 's/"id":"//')
    
    # Add content from MD file
    CONTENT=$(cat "$PROJECT_DIR/02_Brand_Strategy/Brand_Strategy_Document_$PROJECT_NAME.md")
    "$SCRIPT_DIR/mcp-notion.sh" add-content "$BS_DOC_ID" "paragraph" "" "$CONTENT"
fi

# Creative Handoff Summary
if [ -f "$PROJECT_DIR/02_Brand_Strategy/Brand_Strategy_Creative_Handoff_Summary.md" ]; then
    echo "  Adding Creative Handoff Summary..."
    BS_ID="${FOLDER_IDS["02 Brand Strategy"]}"
    CH_DOC=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$BS_ID" "Creative Handoff Summary" "")
    CH_DOC_ID=$(echo "$CH_DOC" | grep -o '"id":"[^"]*' | sed 's/"id":"//')
    
    # Add content from MD file
    CONTENT=$(cat "$PROJECT_DIR/02_Brand_Strategy/Brand_Strategy_Creative_Handoff_Summary.md")
    "$SCRIPT_DIR/mcp-notion.sh" add-content "$CH_DOC_ID" "paragraph" "" "$CONTENT"
fi

# Project Overview Dashboard
if [ -f "$PROJECT_DIR/07_Project_Management/Project_Overview_Dashboard.md" ]; then
    echo "  Adding Project Overview Dashboard..."
    CONTENT=$(cat "$PROJECT_DIR/07_Project_Management/Project_Overview_Dashboard.md")
    "$SCRIPT_DIR/mcp-notion.sh" add-content "$MAIN_PAGE_ID" "paragraph" "" "$CONTENT"
fi

echo "✅ Sync complete! View your project at: https://notion.so/$MAIN_PAGE_ID"