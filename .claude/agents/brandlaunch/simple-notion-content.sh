#!/bin/bash
# Simple script to add content to Notion

NOTION_TOKEN="${NOTION_TOKEN}"
MAIN_PAGE_ID="25b35e2a-ddf7-81bf-a2b5-e638540a2ed7"

# Add a simple dashboard summary to the main page
echo "Adding dashboard summary to main page..."

curl -X PATCH "https://api.notion.com/v1/blocks/$MAIN_PAGE_ID/children" \
  -H "Authorization: Bearer $NOTION_TOKEN" \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  -d '{
    "children": [
      {
        "object": "block",
        "type": "divider",
        "divider": {}
      },
      {
        "object": "block",
        "type": "heading_2",
        "heading_2": {
          "rich_text": [{
            "type": "text",
            "text": {"content": "📊 Project Overview Dashboard"}
          }]
        }
      },
      {
        "object": "block",
        "type": "paragraph",
        "paragraph": {
          "rich_text": [{
            "type": "text",
            "text": {"content": "Project: Apertur Brand Launch"}
          }]
        }
      },
      {
        "object": "block",
        "type": "paragraph",
        "paragraph": {
          "rich_text": [{
            "type": "text",
            "text": {"content": "Status: Market Intelligence Phase Complete ✅ | Brand Strategy Complete ✅"}
          }]
        }
      },
      {
        "object": "block",
        "type": "heading_3",
        "heading_3": {
          "rich_text": [{
            "type": "text",
            "text": {"content": "Company Overview"}
          }]
        }
      },
      {
        "object": "block",
        "type": "bulleted_list_item",
        "bulleted_list_item": {
          "rich_text": [{
            "type": "text",
            "text": {"content": "Company: Apertur (Founded 2016)"}
          }]
        }
      },
      {
        "object": "block",
        "type": "bulleted_list_item",
        "bulleted_list_item": {
          "rich_text": [{
            "type": "text",
            "text": {"content": "Founder: Dr. Lynn McGrath, Neurosurgeon"}
          }]
        }
      },
      {
        "object": "block",
        "type": "bulleted_list_item",
        "bulleted_list_item": {
          "rich_text": [{
            "type": "text",
            "text": {"content": "Product: PupilScreen - smartphone-based digital pupillometry"}
          }]
        }
      },
      {
        "object": "block",
        "type": "bulleted_list_item",
        "bulleted_list_item": {
          "rich_text": [{
            "type": "text",
            "text": {"content": "Technology: 8-second brain health assessment via AI"}
          }]
        }
      },
      {
        "object": "block",
        "type": "heading_3",
        "heading_3": {
          "rich_text": [{
            "type": "text",
            "text": {"content": "Key Strategic Findings"}
          }]
        }
      },
      {
        "object": "block",
        "type": "bulleted_list_item",
        "bulleted_list_item": {
          "rich_text": [{
            "type": "text",
            "text": {"content": "Market Validation Score: 8.5/10"}
          }]
        }
      },
      {
        "object": "block",
        "type": "bulleted_list_item",
        "bulleted_list_item": {
          "rich_text": [{
            "type": "text",
            "text": {"content": "TAM: Digital pupillometry market $423.9M (2023) → $674M (2030)"}
          }]
        }
      },
      {
        "object": "block",
        "type": "bulleted_list_item",
        "bulleted_list_item": {
          "rich_text": [{
            "type": "text",
            "text": {"content": "Positioning: Pioneer of accessible, AI-powered brain health diagnostics"}
          }]
        }
      },
      {
        "object": "block",
        "type": "bulleted_list_item",
        "bulleted_list_item": {
          "rich_text": [{
            "type": "text",
            "text": {"content": "Value Prop: Your smartphone is now a medical device"}
          }]
        }
      },
      {
        "object": "block",
        "type": "heading_3",
        "heading_3": {
          "rich_text": [{
            "type": "text",
            "text": {"content": "Next Steps"}
          }]
        }
      },
      {
        "object": "block",
        "type": "to_do",
        "to_do": {
          "rich_text": [{
            "type": "text",
            "text": {"content": "Visual Identity Development"}
          }],
          "checked": false
        }
      },
      {
        "object": "block",
        "type": "to_do",
        "to_do": {
          "rich_text": [{
            "type": "text",
            "text": {"content": "Content Production"}
          }],
          "checked": false
        }
      },
      {
        "object": "block",
        "type": "to_do",
        "to_do": {
          "rich_text": [{
            "type": "text",
            "text": {"content": "Marketing Copy Creation"}
          }],
          "checked": false
        }
      },
      {
        "object": "block",
        "type": "to_do",
        "to_do": {
          "rich_text": [{
            "type": "text",
            "text": {"content": "Web Assets Development"}
          }],
          "checked": false
        }
      }
    ]
  }'

echo ""
echo "✅ Dashboard content added to main Notion page!"