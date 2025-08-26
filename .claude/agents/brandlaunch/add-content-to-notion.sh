#!/bin/bash
# Script to add content to Notion pages

NOTION_TOKEN="${NOTION_TOKEN}"
PROJECT_DIR="/Users/danielbatten/Library/CloudStorage/Dropbox/CODING/Infinite Ad Garden/V1/Infinite Ad Garden V1/Apertur Brand Launch"

# Function to add content to a Notion page
add_content_to_page() {
    local PAGE_ID="$1"
    local MD_FILE="$2"
    local TITLE="$3"
    
    if [ ! -f "$MD_FILE" ]; then
        echo "File not found: $MD_FILE"
        return 1
    fi
    
    echo "Adding content from $MD_FILE to page $PAGE_ID..."
    
    # Read the first 2000 characters of content (Notion limit per block)
    CONTENT=$(head -c 2000 "$MD_FILE" | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')
    
    # Create JSON payload with proper escaping
    JSON_PAYLOAD=$(cat <<EOF
{
  "children": [
    {
      "object": "block",
      "type": "heading_2",
      "heading_2": {
        "rich_text": [{
          "type": "text",
          "text": {"content": "$TITLE"}
        }]
      }
    },
    {
      "object": "block",
      "type": "paragraph",
      "paragraph": {
        "rich_text": [{
          "type": "text",
          "text": {"content": "$CONTENT"}
        }]
      }
    }
  ]
}
EOF
)
    
    # Make the API call
    RESPONSE=$(curl -s -X PATCH "https://api.notion.com/v1/blocks/$PAGE_ID/children" \
        -H "Authorization: Bearer $NOTION_TOKEN" \
        -H "Content-Type: application/json" \
        -H "Notion-Version: 2022-06-28" \
        -d "$JSON_PAYLOAD")
    
    if echo "$RESPONSE" | grep -q '"object":"list"'; then
        echo "✅ Content added successfully"
    else
        echo "❌ Error adding content"
        echo "$RESPONSE" | head -100
    fi
}

# Main page ID
MAIN_PAGE_ID="25b35e2a-ddf7-81bf-a2b5-e638540a2ed7"

# Add Project Dashboard to main page
echo "Adding Project Overview Dashboard to main page..."
add_content_to_page "$MAIN_PAGE_ID" \
    "$PROJECT_DIR/07_Project_Management/Project_Overview_Dashboard.md" \
    "Project Overview Dashboard"

# Add Market Intelligence Report to its page (if it exists)
MR_DOC_ID="25b35e2a-ddf7-81f8-ad9f-eb8b1e5e1b3d"  # You'll need to get this ID
if [ -n "$MR_DOC_ID" ]; then
    echo "Adding Market Intelligence Report content..."
    add_content_to_page "$MR_DOC_ID" \
        "$PROJECT_DIR/01_Market_Research/Market_Intelligence_Report_Apertur_Brand_Launch.md" \
        "Market Intelligence Details"
fi

# Add Brand Strategy Document to its page (if it exists)
BS_DOC_ID="25b35e2a-ddf7-81d5-bf33-ebf642595b5a"  # Using the existing ID we found
if [ -n "$BS_DOC_ID" ]; then
    echo "Adding Brand Strategy Document content..."
    add_content_to_page "$BS_DOC_ID" \
        "$PROJECT_DIR/02_Brand_Strategy/Apertur_Brand_Strategy_Document.md" \
        "Brand Strategy Details"
fi

echo ""
echo "✅ Content addition complete!"