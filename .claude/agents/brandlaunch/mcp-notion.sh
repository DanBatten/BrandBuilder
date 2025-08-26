#!/bin/bash
# Notion API Bridge for Claude Code Agents
# Provides conversational Notion functionality for brandlaunch CEO system

NOTION_TOKEN="${NOTION_TOKEN:-$NOTION_TOKEN}"
NOTION_VERSION="2022-06-28"
BASE_URL="https://api.notion.com/v1"

case "$1" in
    "create-page")
        if [ -z "$3" ]; then
            echo "Usage: mcp-notion.sh create-page <parent_id> <title> [content]"
            echo "  Use empty string \"\" for parent_id to create root page"
            exit 1
        fi
        PARENT_ID="$2"
        TITLE="$3"
        CONTENT="${4:-}"
        
        # Build children blocks if content is provided
        CHILDREN_JSON=""
        if [ -n "$CONTENT" ]; then
            CHILDREN_JSON=$(cat <<EOF
,
  "children": [
    {
      "object": "block",
      "type": "paragraph",
      "paragraph": {
        "rich_text": [
          {
            "type": "text",
            "text": {
              "content": "$CONTENT"
            }
          }
        ]
      }
    }
  ]
EOF
)
        fi
        
        # Handle root page vs child page creation
        if [ -z "$PARENT_ID" ] || [ "$PARENT_ID" = "" ]; then
            # Create in default workspace (will need manual parent later)
            JSON_PAYLOAD=$(cat <<EOF
{
  "parent": {"type": "page_id", "page_id": ""},
  "properties": {
    "title": {
      "title": [
        {
          "text": {
            "content": "$TITLE"
          }
        }
      ]
    }
  }$CHILDREN_JSON
}
EOF
)
        else
            # Child page creation
            JSON_PAYLOAD=$(cat <<EOF
{
  "parent": {"page_id": "$PARENT_ID"},
  "properties": {
    "title": {
      "title": [
        {
          "text": {
            "content": "$TITLE"
          }
        }
      ]
    }
  }$CHILDREN_JSON
}
EOF
)
        fi
        
        curl -s -X POST "$BASE_URL/pages" \
          -H "Authorization: Bearer $NOTION_TOKEN" \
          -H "Content-Type: application/json" \
          -H "Notion-Version: $NOTION_VERSION" \
          -d "$JSON_PAYLOAD"
        ;;
        
    "search")
        QUERY="${2:-}"
        if [ -n "$QUERY" ]; then
            JSON_PAYLOAD="{\"query\": \"$QUERY\"}"
        else
            JSON_PAYLOAD="{}"
        fi
        
        curl -s -X POST "$BASE_URL/search" \
          -H "Authorization: Bearer $NOTION_TOKEN" \
          -H "Content-Type: application/json" \
          -H "Notion-Version: $NOTION_VERSION" \
          -d "$JSON_PAYLOAD"
        ;;
        
    "add-content")
        if [ -z "$2" ]; then
            echo "Usage: mcp-notion.sh add-content <page_id> <content_type> [title] [content]"
            echo "Content types: paragraph, heading1, heading2, heading3, callout, divider, bulleted_list"
            exit 1
        fi
        PAGE_ID="$2"
        CONTENT_TYPE="$3"
        TITLE="${4:-}"
        CONTENT="${5:-}"
        
        case "$CONTENT_TYPE" in
            "paragraph")
                BLOCK="{\"type\": \"paragraph\", \"paragraph\": {\"rich_text\": [{\"type\": \"text\", \"text\": {\"content\": \"$CONTENT\"}}]}}"
                ;;
            "heading1")
                BLOCK="{\"type\": \"heading_1\", \"heading_1\": {\"rich_text\": [{\"type\": \"text\", \"text\": {\"content\": \"$TITLE\"}}]}}"
                ;;
            "heading2")
                BLOCK="{\"type\": \"heading_2\", \"heading_2\": {\"rich_text\": [{\"type\": \"text\", \"text\": {\"content\": \"$TITLE\"}}]}}"
                ;;
            "heading3")
                BLOCK="{\"type\": \"heading_3\", \"heading_3\": {\"rich_text\": [{\"type\": \"text\", \"text\": {\"content\": \"$TITLE\"}}]}}"
                ;;
            "callout")
                BLOCK="{\"type\": \"callout\", \"callout\": {\"icon\": {\"emoji\": \"💡\"}, \"rich_text\": [{\"type\": \"text\", \"text\": {\"content\": \"$CONTENT\"}}]}}"
                ;;
            "divider")
                BLOCK="{\"type\": \"divider\", \"divider\": {}}"
                ;;
            "bulleted_list")
                BLOCK="{\"type\": \"bulleted_list_item\", \"bulleted_list_item\": {\"rich_text\": [{\"type\": \"text\", \"text\": {\"content\": \"$CONTENT\"}}]}}"
                ;;
            *)
                echo "Unknown content type: $CONTENT_TYPE"
                exit 1
                ;;
        esac
        
        curl -s -X PATCH "$BASE_URL/blocks/$PAGE_ID/children" \
          -H "Authorization: Bearer $NOTION_TOKEN" \
          -H "Content-Type: application/json" \
          -H "Notion-Version: $NOTION_VERSION" \
          -d "{\"children\": [$BLOCK]}"
        ;;
        
    "create-database")
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo "Usage: mcp-notion.sh create-database <parent_id> <title>"
            exit 1
        fi
        PARENT_ID="$2"
        TITLE="$3"
        
        JSON_PAYLOAD=$(cat <<EOF
{
  "parent": {"page_id": "$PARENT_ID"},
  "title": [
    {
      "type": "text",
      "text": {
        "content": "$TITLE"
      }
    }
  ],
  "properties": {
    "Name": {
      "title": {}
    },
    "Status": {
      "select": {
        "options": [
          {"name": "Not Started", "color": "red"},
          {"name": "In Progress", "color": "yellow"},
          {"name": "Complete", "color": "green"}
        ]
      }
    },
    "Priority": {
      "select": {
        "options": [
          {"name": "Low", "color": "gray"},
          {"name": "Medium", "color": "yellow"},
          {"name": "High", "color": "red"}
        ]
      }
    },
    "Notes": {
      "rich_text": {}
    }
  }
}
EOF
)
        
        curl -s -X POST "$BASE_URL/databases" \
          -H "Authorization: Bearer $NOTION_TOKEN" \
          -H "Content-Type: application/json" \
          -H "Notion-Version: $NOTION_VERSION" \
          -d "$JSON_PAYLOAD"
        ;;
        
    *)
        echo "Available commands:"
        echo "  create-page <parent_id> <title> [content]"
        echo "  search [query]"
        echo "  add-content <page_id> <content_type> [title] [content]"
        echo "  create-database <parent_id> <title>"
        echo ""
        echo "Content types for add-content:"
        echo "  paragraph, heading1, heading2, heading3, callout, divider, bulleted_list"
        exit 1
        ;;
esac