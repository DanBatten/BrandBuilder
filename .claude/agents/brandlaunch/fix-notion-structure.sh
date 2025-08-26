#!/bin/bash
# Script to fix Notion structure and add content properly

SCRIPT_DIR="/Users/danielbatten/Library/CloudStorage/Dropbox/CODING/Infinite Ad Garden/V1/Infinite Ad Garden V1/.claude/agents/brandlaunch"
PROJECT_DIR="/Users/danielbatten/Library/CloudStorage/Dropbox/CODING/Infinite Ad Garden/V1/Infinite Ad Garden V1/Apertur Brand Launch"

# Main project page ID (we'll search for it first)
echo "Searching for existing Apertur project..."
SEARCH_RESULT=$("$SCRIPT_DIR/mcp-notion.sh" search "Apertur Brand Launch")

# Create main project page
echo "Creating main Apertur Brand Launch page..."
MAIN_PAGE=$("$SCRIPT_DIR/mcp-notion.sh" create-page "" "Apertur Brand Launch" "")
MAIN_PAGE_ID=$(echo $MAIN_PAGE | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)
echo "Main page ID: $MAIN_PAGE_ID"

# Create properly named folders (one level deep)
echo "Creating folder structure..."

# 01 Market Research
MR_PAGE=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$MAIN_PAGE_ID" "01 Market Research" "")
MR_ID=$(echo $MR_PAGE | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)

# 02 Brand Strategy  
BS_PAGE=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$MAIN_PAGE_ID" "02 Brand Strategy" "")
BS_ID=$(echo $BS_PAGE | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)

# 03 Visual Identity
VI_PAGE=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$MAIN_PAGE_ID" "03 Visual Identity" "")
VI_ID=$(echo $VI_PAGE | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)

# 04 Content Production
CP_PAGE=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$MAIN_PAGE_ID" "04 Content Production" "")
CP_ID=$(echo $CP_PAGE | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)

# 05 Marketing Copy
MC_PAGE=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$MAIN_PAGE_ID" "05 Marketing Copy" "")
MC_ID=$(echo $MC_PAGE | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)

# 06 Web Assets
WA_PAGE=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$MAIN_PAGE_ID" "06 Web Assets" "")
WA_ID=$(echo $WA_PAGE | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)

# 07 Project Management
PM_PAGE=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$MAIN_PAGE_ID" "07 Project Management" "")
PM_ID=$(echo $PM_PAGE | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)

echo "Folder structure created"

# Now add the documents to each folder
echo "Adding documents to folders..."

# Add Market Intelligence Report to 01 Market Research
if [ -f "$PROJECT_DIR/01_Market_Research/Market_Intelligence_Report_Apertur_Brand_Launch.md" ]; then
    echo "Creating Market Intelligence Report..."
    MR_DOC=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$MR_ID" "Market Intelligence Report" "")
    MR_DOC_ID=$(echo $MR_DOC | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)
    echo "Updating with content..."
    "$SCRIPT_DIR/mcp-notion.sh" update-page "$MR_DOC_ID" "$PROJECT_DIR/01_Market_Research/Market_Intelligence_Report_Apertur_Brand_Launch.md"
fi

# Add Brand Strategy Document to 02 Brand Strategy
if [ -f "$PROJECT_DIR/02_Brand_Strategy/Apertur_Brand_Strategy_Document.md" ]; then
    echo "Creating Brand Strategy Document..."
    BS_DOC=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$BS_ID" "Brand Strategy Document" "")
    BS_DOC_ID=$(echo $BS_DOC | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)
    echo "Updating with content..."
    "$SCRIPT_DIR/mcp-notion.sh" update-page "$BS_DOC_ID" "$PROJECT_DIR/02_Brand_Strategy/Apertur_Brand_Strategy_Document.md"
fi

# Add Creative Handoff to 02 Brand Strategy
if [ -f "$PROJECT_DIR/02_Brand_Strategy/Brand_Strategy_Creative_Handoff_Summary.md" ]; then
    echo "Creating Creative Handoff Summary..."
    CH_DOC=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$BS_ID" "Creative Handoff Summary" "")
    CH_DOC_ID=$(echo $CH_DOC | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)
    echo "Updating with content..."
    "$SCRIPT_DIR/mcp-notion.sh" update-page "$CH_DOC_ID" "$PROJECT_DIR/02_Brand_Strategy/Brand_Strategy_Creative_Handoff_Summary.md"
fi

# Add Project Overview Dashboard to main page (below the list)
if [ -f "$PROJECT_DIR/07_Project_Management/Project_Overview_Dashboard.md" ]; then
    echo "Adding Project Dashboard to main page..."
    "$SCRIPT_DIR/mcp-notion.sh" update-page "$MAIN_PAGE_ID" "$PROJECT_DIR/07_Project_Management/Project_Overview_Dashboard.md"
fi

echo "✅ Notion structure fixed and documents added!"
echo ""
echo "Page IDs for reference:"
echo "Main Project: $MAIN_PAGE_ID"
echo "01 Market Research: $MR_ID"
echo "02 Brand Strategy: $BS_ID"
echo "03 Visual Identity: $VI_ID"
echo "04 Content Production: $CP_ID"
echo "05 Marketing Copy: $MC_ID"
echo "06 Web Assets: $WA_ID"
echo "07 Project Management: $PM_ID"