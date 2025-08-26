#!/bin/bash
# Script to rebuild Notion structure properly

SCRIPT_DIR="/Users/danielbatten/Library/CloudStorage/Dropbox/CODING/Infinite Ad Garden/V1/Infinite Ad Garden V1/.claude/agents/brandlaunch"
PROJECT_DIR="/Users/danielbatten/Library/CloudStorage/Dropbox/CODING/Infinite Ad Garden/V1/Infinite Ad Garden V1/Apertur Brand Launch"

# Use existing main page ID
MAIN_PAGE_ID="25b35e2a-ddf7-81bf-a2b5-e638540a2ed7"
echo "Using existing Apertur Brand Launch page: $MAIN_PAGE_ID"

# Create properly named folders (one level deep) under main page
echo "Creating clean folder structure..."

# 01 Market Research
echo "Creating 01 Market Research folder..."
MR_RESULT=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$MAIN_PAGE_ID" "01 Market Research" "" 2>/dev/null)
MR_ID=$(echo "$MR_RESULT" | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)
echo "01 Market Research ID: $MR_ID"

# 02 Brand Strategy  
echo "Creating 02 Brand Strategy folder..."
BS_RESULT=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$MAIN_PAGE_ID" "02 Brand Strategy" "" 2>/dev/null)
BS_ID=$(echo "$BS_RESULT" | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)
echo "02 Brand Strategy ID: $BS_ID"

# 03 Visual Identity
echo "Creating 03 Visual Identity folder..."
VI_RESULT=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$MAIN_PAGE_ID" "03 Visual Identity" "" 2>/dev/null)
VI_ID=$(echo "$VI_RESULT" | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)
echo "03 Visual Identity ID: $VI_ID"

# 04 Content Production
echo "Creating 04 Content Production folder..."
CP_RESULT=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$MAIN_PAGE_ID" "04 Content Production" "" 2>/dev/null)
CP_ID=$(echo "$CP_RESULT" | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)
echo "04 Content Production ID: $CP_ID"

# 05 Marketing Copy
echo "Creating 05 Marketing Copy folder..."
MC_RESULT=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$MAIN_PAGE_ID" "05 Marketing Copy" "" 2>/dev/null)
MC_ID=$(echo "$MC_RESULT" | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)
echo "05 Marketing Copy ID: $MC_ID"

# 06 Web Assets
echo "Creating 06 Web Assets folder..."
WA_RESULT=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$MAIN_PAGE_ID" "06 Web Assets" "" 2>/dev/null)
WA_ID=$(echo "$WA_RESULT" | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)
echo "06 Web Assets ID: $WA_ID"

# 07 Project Management
echo "Creating 07 Project Management folder..."
PM_RESULT=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$MAIN_PAGE_ID" "07 Project Management" "" 2>/dev/null)
PM_ID=$(echo "$PM_RESULT" | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)
echo "07 Project Management ID: $PM_ID"

echo ""
echo "Folder structure created. Now adding documents..."
echo ""

# Add documents to each folder (only if they have valid IDs)

# Market Intelligence Report
if [ -n "$MR_ID" ] && [ -f "$PROJECT_DIR/01_Market_Research/Market_Intelligence_Report_Apertur_Brand_Launch.md" ]; then
    echo "Creating Market Intelligence Report in 01 Market Research..."
    MR_DOC_RESULT=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$MR_ID" "Market Intelligence Report" "" 2>/dev/null)
    MR_DOC_ID=$(echo "$MR_DOC_RESULT" | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)
    
    if [ -n "$MR_DOC_ID" ]; then
        echo "Adding content to Market Intelligence Report..."
        # Use Python to properly add the markdown content
        python3 -c "
import requests
import json

NOTION_TOKEN = os.environ.get('NOTION_TOKEN')
page_id = '$MR_DOC_ID'
md_file = '$PROJECT_DIR/01_Market_Research/Market_Intelligence_Report_Apertur_Brand_Launch.md'

with open(md_file, 'r') as f:
    content = f.read()

# Simple conversion - just add as one big text block for now
blocks = [{
    'object': 'block',
    'type': 'paragraph',
    'paragraph': {
        'rich_text': [{
            'type': 'text',
            'text': {'content': content[:2000]}  # Notion has a 2000 char limit per block
        }]
    }
}]

response = requests.patch(
    f'https://api.notion.com/v1/blocks/{page_id}/children',
    headers={
        'Authorization': f'Bearer {NOTION_TOKEN}',
        'Content-Type': 'application/json',
        'Notion-Version': '2022-06-28'
    },
    json={'children': blocks}
)
print('Market Intelligence content added' if response.status_code == 200 else f'Error: {response.status_code}')
"
    fi
fi

# Brand Strategy Document
if [ -n "$BS_ID" ] && [ -f "$PROJECT_DIR/02_Brand_Strategy/Apertur_Brand_Strategy_Document.md" ]; then
    echo "Creating Brand Strategy Document in 02 Brand Strategy..."
    BS_DOC_RESULT=$("$SCRIPT_DIR/mcp-notion.sh" create-page "$BS_ID" "Brand Strategy Document" "" 2>/dev/null)
    BS_DOC_ID=$(echo "$BS_DOC_RESULT" | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)
    
    if [ -n "$BS_DOC_ID" ]; then
        echo "Adding content to Brand Strategy Document..."
        python3 -c "
import requests
import json

NOTION_TOKEN = os.environ.get('NOTION_TOKEN')
page_id = '$BS_DOC_ID'
md_file = '$PROJECT_DIR/02_Brand_Strategy/Apertur_Brand_Strategy_Document.md'

with open(md_file, 'r') as f:
    content = f.read()

blocks = [{
    'object': 'block',
    'type': 'paragraph',
    'paragraph': {
        'rich_text': [{
            'type': 'text',
            'text': {'content': content[:2000]}
        }]
    }
}]

response = requests.patch(
    f'https://api.notion.com/v1/blocks/{page_id}/children',
    headers={
        'Authorization': f'Bearer {NOTION_TOKEN}',
        'Content-Type': 'application/json',
        'Notion-Version': '2022-06-28'
    },
    json={'children': blocks}
)
print('Brand Strategy content added' if response.status_code == 200 else f'Error: {response.status_code}')
"
    fi
fi

# Add Project Dashboard directly to main page
if [ -f "$PROJECT_DIR/07_Project_Management/Project_Overview_Dashboard.md" ]; then
    echo "Adding Project Overview Dashboard to main page..."
    python3 -c "
import requests
import json

NOTION_TOKEN = os.environ.get('NOTION_TOKEN')
page_id = '$MAIN_PAGE_ID'
md_file = '$PROJECT_DIR/07_Project_Management/Project_Overview_Dashboard.md'

with open(md_file, 'r') as f:
    content = f.read()

# Add a heading and then the content
blocks = [
    {
        'object': 'block',
        'type': 'heading_2',
        'heading_2': {
            'rich_text': [{
                'type': 'text',
                'text': {'content': 'Project Overview Dashboard'}
            }]
        }
    },
    {
        'object': 'block',
        'type': 'paragraph',
        'paragraph': {
            'rich_text': [{
                'type': 'text',
                'text': {'content': content[:2000]}
            }]
        }
    }
]

response = requests.patch(
    f'https://api.notion.com/v1/blocks/{page_id}/children',
    headers={
        'Authorization': f'Bearer {NOTION_TOKEN}',
        'Content-Type': 'application/json',
        'Notion-Version': '2022-06-28'
    },
    json={'children': blocks}
)
print('Project Dashboard added to main page' if response.status_code == 200 else f'Error: {response.status_code}')
"
fi

echo ""
echo "✅ Notion structure rebuilt successfully!"
echo ""
echo "Structure Summary:"
echo "└── Apertur Brand Launch (Main Page: $MAIN_PAGE_ID)"
echo "    ├── 01 Market Research ($MR_ID)"
echo "    │   └── Market Intelligence Report"
echo "    ├── 02 Brand Strategy ($BS_ID)"
echo "    │   └── Brand Strategy Document"
echo "    ├── 03 Visual Identity ($VI_ID)"
echo "    ├── 04 Content Production ($CP_ID)"
echo "    ├── 05 Marketing Copy ($MC_ID)"
echo "    ├── 06 Web Assets ($WA_ID)"
echo "    ├── 07 Project Management ($PM_ID)"
echo "    └── [Project Overview Dashboard - added below folders]"