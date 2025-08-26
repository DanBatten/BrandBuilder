#!/bin/bash
# Script to populate Notion documents with actual content

NOTION_TOKEN="${NOTION_TOKEN}"
PROJECT_DIR="/Users/danielbatten/Library/CloudStorage/Dropbox/CODING/Infinite Ad Garden/V1/Infinite Ad Garden V1/Apertur Brand Launch"

# First, let's find the Market Intelligence Report page
echo "Finding Market Intelligence Report page..."
MR_SEARCH=$(curl -s -X POST "https://api.notion.com/v1/search" \
  -H "Authorization: Bearer $NOTION_TOKEN" \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  -d '{"query": "Market Intelligence Report", "filter": {"property": "object", "value": "page"}}')

MR_PAGE_ID=$(echo "$MR_SEARCH" | grep -o '"id":"[^"]*' | grep -v "25b35e2a-ddf7-81c8" | sed 's/"id":"//' | head -1)

if [ -z "$MR_PAGE_ID" ]; then
  # Create it in the 01 Market Research folder
  MR_FOLDER_ID="25b35e2a-ddf7-81b2-a36f-e6fa00e272f9"
  echo "Creating Market Intelligence Report page..."
  MR_RESULT=$(curl -s -X POST "https://api.notion.com/v1/pages" \
    -H "Authorization: Bearer $NOTION_TOKEN" \
    -H "Content-Type: application/json" \
    -H "Notion-Version: 2022-06-28" \
    -d "{
      \"parent\": {\"page_id\": \"$MR_FOLDER_ID\"},
      \"properties\": {
        \"title\": {
          \"title\": [{
            \"text\": {\"content\": \"Market Intelligence Report\"}
          }]
        }
      }
    }")
  MR_PAGE_ID=$(echo "$MR_RESULT" | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)
fi

echo "Market Intelligence Report Page ID: $MR_PAGE_ID"

# Add Market Intelligence content
if [ -n "$MR_PAGE_ID" ]; then
  echo "Adding Market Intelligence content..."
  
  curl -s -X PATCH "https://api.notion.com/v1/blocks/$MR_PAGE_ID/children" \
    -H "Authorization: Bearer $NOTION_TOKEN" \
    -H "Content-Type: application/json" \
    -H "Notion-Version: 2022-06-28" \
    -d '{
      "children": [
        {
          "type": "heading_1",
          "heading_1": {
            "rich_text": [{"text": {"content": "Market Intelligence Report: Apertur Brand Launch"}}]
          }
        },
        {
          "type": "paragraph",
          "paragraph": {
            "rich_text": [{"text": {"content": "Date: August 26, 2025 | Analyst: Market Intelligence Agent"}}]
          }
        },
        {
          "type": "divider",
          "divider": {}
        },
        {
          "type": "heading_2",
          "heading_2": {
            "rich_text": [{"text": {"content": "📊 Executive Summary"}}]
          }
        },
        {
          "type": "bulleted_list_item",
          "bulleted_list_item": {
            "rich_text": [{"text": {"content": "Key Finding: Apertur operates in a rapidly growing digital pupillometry market ($423.9M in 2023, expected to reach $674M by 2030)"}}]
          }
        },
        {
          "type": "bulleted_list_item",
          "bulleted_list_item": {
            "rich_text": [{"text": {"content": "Primary Opportunity: Smartphone-based neurological screening represents a blue ocean market with minimal direct competition"}}]
          }
        },
        {
          "type": "bulleted_list_item",
          "bulleted_list_item": {
            "rich_text": [{"text": {"content": "Recommended Positioning: Pioneer of accessible, AI-powered brain health diagnostics for healthcare democratization"}}]
          }
        },
        {
          "type": "bulleted_list_item",
          "bulleted_list_item": {
            "rich_text": [{"text": {"content": "Market Validation Score: 8.5/10 - Strong market fundamentals with clear differentiation opportunity"}}]
          }
        },
        {
          "type": "heading_2",
          "heading_2": {
            "rich_text": [{"text": {"content": "📈 Market Overview"}}]
          }
        },
        {
          "type": "heading_3",
          "heading_3": {
            "rich_text": [{"text": {"content": "Market Size and Growth"}}]
          }
        },
        {
          "type": "bulleted_list_item",
          "bulleted_list_item": {
            "rich_text": [{"text": {"content": "Digital Pupillometry Market: $423.9M (2023) → $674M (2030) at 6.4% CAGR"}}]
          }
        },
        {
          "type": "bulleted_list_item",
          "bulleted_list_item": {
            "rich_text": [{"text": {"content": "TBI Assessment Market: $2.9B (2023) → $5.2B (2032) at 7.4% CAGR"}}]
          }
        },
        {
          "type": "bulleted_list_item",
          "bulleted_list_item": {
            "rich_text": [{"text": {"content": "Concussion Market: $7.5B (2024) → $10.4B (2034) at 4.8% CAGR"}}]
          }
        },
        {
          "type": "heading_2",
          "heading_2": {
            "rich_text": [{"text": {"content": "🎯 Competitive Analysis"}}]
          }
        },
        {
          "type": "table",
          "table": {
            "table_width": 3,
            "has_column_header": true,
            "has_row_header": false,
            "children": [
              {
                "type": "table_row",
                "table_row": {
                  "cells": [
                    [{"text": {"content": "Competitor"}}],
                    [{"text": {"content": "Price Point"}}],
                    [{"text": {"content": "Weakness"}}]
                  ]
                }
              },
              {
                "type": "table_row",
                "table_row": {
                  "cells": [
                    [{"text": {"content": "Traditional Pupillometers"}}],
                    [{"text": {"content": "$10K-50K+"}}],
                    [{"text": {"content": "Expensive, non-portable"}}]
                  ]
                }
              },
              {
                "type": "table_row",
                "table_row": {
                  "cells": [
                    [{"text": {"content": "Tobii"}}],
                    [{"text": {"content": "$15K-100K+"}}],
                    [{"text": {"content": "Not medical-focused"}}]
                  ]
                }
              },
              {
                "type": "table_row",
                "table_row": {
                  "cells": [
                    [{"text": {"content": "Smart Eye"}}],
                    [{"text": {"content": "Enterprise pricing"}}],
                    [{"text": {"content": "Limited medical apps"}}]
                  ]
                }
              }
            ]
          }
        },
        {
          "type": "heading_2",
          "heading_2": {
            "rich_text": [{"text": {"content": "💡 Strategic Recommendations"}}]
          }
        },
        {
          "type": "numbered_list_item",
          "numbered_list_item": {
            "rich_text": [{"text": {"content": "Position as \"Democratizing brain health through smartphone AI diagnostics\""}}]
          }
        },
        {
          "type": "numbered_list_item",
          "numbered_list_item": {
            "rich_text": [{"text": {"content": "Target sports medicine practitioners first"}}]
          }
        },
        {
          "type": "numbered_list_item",
          "numbered_list_item": {
            "rich_text": [{"text": {"content": "Emphasize 8-second test vs. lengthy clinical procedures"}}]
          }
        },
        {
          "type": "numbered_list_item",
          "numbered_list_item": {
            "rich_text": [{"text": {"content": "Leverage founder credibility (neurosurgeon Dr. Lynn McGrath)"}}]
          }
        },
        {
          "type": "callout",
          "callout": {
            "icon": {"emoji": "🎯"},
            "rich_text": [{"text": {"content": "White Space Opportunity: Consumer-accessible neurological screening via smartphone represents an untapped market with no direct competition at consumer price points."}}]
          }
        }
      ]
    }' > /dev/null
    
  echo "✅ Market Intelligence Report populated"
fi

# Now find and populate Brand Strategy Document
echo ""
echo "Finding Brand Strategy Document page..."
BS_SEARCH=$(curl -s -X POST "https://api.notion.com/v1/search" \
  -H "Authorization: Bearer $NOTION_TOKEN" \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  -d '{"query": "Brand Strategy Document", "filter": {"property": "object", "value": "page"}}')

BS_PAGE_ID=$(echo "$BS_SEARCH" | grep -o '"id":"[^"]*' | grep -v "25b35e2a-ddf7-81f4" | sed 's/"id":"//' | head -1)

if [ -z "$BS_PAGE_ID" ]; then
  # Create it in the 02 Brand Strategy folder
  BS_FOLDER_ID="25b35e2a-ddf7-8173-a4e6-c24fe53c2dae"
  echo "Creating Brand Strategy Document page..."
  BS_RESULT=$(curl -s -X POST "https://api.notion.com/v1/pages" \
    -H "Authorization: Bearer $NOTION_TOKEN" \
    -H "Content-Type: application/json" \
    -H "Notion-Version: 2022-06-28" \
    -d "{
      \"parent\": {\"page_id\": \"$BS_FOLDER_ID\"},
      \"properties\": {
        \"title\": {
          \"title\": [{
            \"text\": {\"content\": \"Brand Strategy Document\"}
          }]
        }
      }
    }")
  BS_PAGE_ID=$(echo "$BS_RESULT" | grep -o '"id":"[^"]*' | sed 's/"id":"//' | head -1)
fi

echo "Brand Strategy Document Page ID: $BS_PAGE_ID"

# Add Brand Strategy content
if [ -n "$BS_PAGE_ID" ]; then
  echo "Adding Brand Strategy content..."
  
  curl -s -X PATCH "https://api.notion.com/v1/blocks/$BS_PAGE_ID/children" \
    -H "Authorization: Bearer $NOTION_TOKEN" \
    -H "Content-Type: application/json" \
    -H "Notion-Version: 2022-06-28" \
    -d '{
      "children": [
        {
          "type": "heading_1",
          "heading_1": {
            "rich_text": [{"text": {"content": "Apertur Brand Strategy Document"}}]
          }
        },
        {
          "type": "paragraph",
          "paragraph": {
            "rich_text": [{"text": {"content": "Strategic Framework for Brand Launch | August 26, 2025"}}]
          }
        },
        {
          "type": "divider",
          "divider": {}
        },
        {
          "type": "heading_2",
          "heading_2": {
            "rich_text": [{"text": {"content": "🎯 Brand Positioning"}}]
          }
        },
        {
          "type": "quote",
          "quote": {
            "rich_text": [{"text": {"content": "Apertur is the pioneer of smartphone-based neurological diagnostics, transforming any phone into a medical device that delivers neurosurgeon-grade brain health assessment in 8 seconds."}}]
          }
        },
        {
          "type": "heading_2",
          "heading_2": {
            "rich_text": [{"text": {"content": "💎 Core Value Proposition"}}]
          }
        },
        {
          "type": "callout",
          "callout": {
            "icon": {"emoji": "📱"},
            "rich_text": [{"text": {"content": "Your smartphone is now a medical device. Apertur delivers neurosurgeon-grade brain health diagnostics in 8 seconds, making advanced neurological screening accessible anywhere."}}]
          }
        },
        {
          "type": "heading_2",
          "heading_2": {
            "rich_text": [{"text": {"content": "🏛️ Five Brand Pillars"}}]
          }
        },
        {
          "type": "numbered_list_item",
          "numbered_list_item": {
            "rich_text": [{"text": {"content": "Pioneering - Leading neurological diagnostic transformation"}}]
          }
        },
        {
          "type": "numbered_list_item",
          "numbered_list_item": {
            "rich_text": [{"text": {"content": "Trustworthy - Medical credibility with clinical validation"}}]
          }
        },
        {
          "type": "numbered_list_item",
          "numbered_list_item": {
            "rich_text": [{"text": {"content": "Accessible - Democratizing advanced healthcare technology"}}]
          }
        },
        {
          "type": "numbered_list_item",
          "numbered_list_item": {
            "rich_text": [{"text": {"content": "Precise - AI-powered accuracy for critical decisions"}}]
          }
        },
        {
          "type": "numbered_list_item",
          "numbered_list_item": {
            "rich_text": [{"text": {"content": "Empowering - Advanced diagnostics in everyones hands"}}]
          }
        },
        {
          "type": "heading_2",
          "heading_2": {
            "rich_text": [{"text": {"content": "👥 Target Audience Strategy"}}]
          }
        },
        {
          "type": "toggle",
          "toggle": {
            "rich_text": [{"text": {"content": "Primary: Healthcare Providers"}}],
            "children": [
              {
                "type": "paragraph",
                "paragraph": {
                  "rich_text": [{"text": {"content": "Neurologists, emergency physicians, sports medicine doctors seeking portable diagnostic tools"}}]
                }
              }
            ]
          }
        },
        {
          "type": "toggle",
          "toggle": {
            "rich_text": [{"text": {"content": "Secondary: Sports Organizations"}}],
            "children": [
              {
                "type": "paragraph",
                "paragraph": {
                  "rich_text": [{"text": {"content": "Professional teams, colleges, youth sports prioritizing athlete safety"}}]
                }
              }
            ]
          }
        },
        {
          "type": "toggle",
          "toggle": {
            "rich_text": [{"text": {"content": "Tertiary: Health-Conscious Consumers"}}],
            "children": [
              {
                "type": "paragraph",
                "paragraph": {
                  "rich_text": [{"text": {"content": "Individuals wanting proactive brain health monitoring"}}]
                }
              }
            ]
          }
        },
        {
          "type": "heading_2",
          "heading_2": {
            "rich_text": [{"text": {"content": "📢 Key Messaging Framework"}}]
          }
        },
        {
          "type": "table",
          "table": {
            "table_width": 2,
            "has_column_header": true,
            "has_row_header": false,
            "children": [
              {
                "type": "table_row",
                "table_row": {
                  "cells": [
                    [{"text": {"content": "Message Theme"}}],
                    [{"text": {"content": "Key Message"}}]
                  ]
                }
              },
              {
                "type": "table_row",
                "table_row": {
                  "cells": [
                    [{"text": {"content": "Speed"}}],
                    [{"text": {"content": "8-second brain health assessment"}}]
                  ]
                }
              },
              {
                "type": "table_row",
                "table_row": {
                  "cells": [
                    [{"text": {"content": "Accessibility"}}],
                    [{"text": {"content": "Medical-grade diagnostics on any smartphone"}}]
                  ]
                }
              },
              {
                "type": "table_row",
                "table_row": {
                  "cells": [
                    [{"text": {"content": "Innovation"}}],
                    [{"text": {"content": "AI-powered neurological screening revolution"}}]
                  ]
                }
              },
              {
                "type": "table_row",
                "table_row": {
                  "cells": [
                    [{"text": {"content": "Trust"}}],
                    [{"text": {"content": "Founded by neurosurgeon Dr. Lynn McGrath"}}]
                  ]
                }
              }
            ]
          }
        },
        {
          "type": "heading_2",
          "heading_2": {
            "rich_text": [{"text": {"content": "🚀 Implementation Roadmap"}}]
          }
        },
        {
          "type": "to_do",
          "to_do": {
            "rich_text": [{"text": {"content": "Phase 1 (Weeks 1-2): Foundation - Visual identity and messaging validation"}}],
            "checked": false
          }
        },
        {
          "type": "to_do",
          "to_do": {
            "rich_text": [{"text": {"content": "Phase 2 (Weeks 3-4): Creative Development - Asset creation and brand guidelines"}}],
            "checked": false
          }
        },
        {
          "type": "to_do",
          "to_do": {
            "rich_text": [{"text": {"content": "Phase 3 (Weeks 5-6): Market Launch - Channel deployment and performance monitoring"}}],
            "checked": false
          }
        },
        {
          "type": "callout",
          "callout": {
            "icon": {"emoji": "✅"},
            "rich_text": [{"text": {"content": "Success Metrics: 25% aided awareness among healthcare providers in 6 months, 85% trust score among medical professionals, 15% trial-to-adoption rate"}}]
          }
        }
      ]
    }' > /dev/null
    
  echo "✅ Brand Strategy Document populated"
fi

echo ""
echo "✅ All documents populated successfully!"
echo ""
echo "View your documents:"
echo "📊 Market Intelligence Report: https://www.notion.so/$MR_PAGE_ID"
echo "🎯 Brand Strategy Document: https://www.notion.so/$BS_PAGE_ID"