#!/bin/bash
# Firecrawl API Bridge for Claude Code Agents
# Provides conversational web scraping functionality for brandlaunch CEO system

FIRECRAWL_API_KEY="${FIRECRAWL_API_KEY:-$FIRECRAWL_API_KEY}"
BASE_URL="https://api.firecrawl.dev/v1"

case "$1" in
    "scrape")
        if [ -z "$2" ]; then
            echo "Usage: mcp-firecrawl.sh scrape <url> [formats]"
            echo "Formats: markdown, html, rawHtml, links, screenshot (comma-separated)"
            exit 1
        fi
        URL="$2"
        FORMATS="${3:-markdown}"
        
        # Convert comma-separated formats to JSON array
        IFS=',' read -ra FORMAT_ARRAY <<< "$FORMATS"
        JSON_FORMATS="["
        for i in "${!FORMAT_ARRAY[@]}"; do
            if [ $i -gt 0 ]; then
                JSON_FORMATS+=","
            fi
            JSON_FORMATS+="\"${FORMAT_ARRAY[$i]}\""
        done
        JSON_FORMATS+="]"
        
        JSON_PAYLOAD=$(cat <<EOF
{
  "url": "$URL",
  "formats": $JSON_FORMATS
}
EOF
)
        
        curl -s -X POST "$BASE_URL/scrape" \
          -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
          -H "Content-Type: application/json" \
          -d "$JSON_PAYLOAD"
        ;;
        
    "crawl")
        if [ -z "$2" ]; then
            echo "Usage: mcp-firecrawl.sh crawl <url> [max_depth] [limit]"
            exit 1
        fi
        URL="$2"
        MAX_DEPTH="${3:-2}"
        LIMIT="${4:-10}"
        
        JSON_PAYLOAD=$(cat <<EOF
{
  "url": "$URL",
  "crawlerOptions": {
    "maxDepth": $MAX_DEPTH,
    "limit": $LIMIT,
    "allowBackwardCrawling": false,
    "allowExternalContentLinks": false
  },
  "formats": ["markdown"]
}
EOF
)
        
        curl -s -X POST "$BASE_URL/crawl" \
          -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
          -H "Content-Type: application/json" \
          -d "$JSON_PAYLOAD"
        ;;
        
    "crawl-status")
        if [ -z "$2" ]; then
            echo "Usage: mcp-firecrawl.sh crawl-status <job_id>"
            exit 1
        fi
        JOB_ID="$2"
        
        curl -s -X GET "$BASE_URL/crawl/$JOB_ID" \
          -H "Authorization: Bearer $FIRECRAWL_API_KEY"
        ;;
        
    "map")
        if [ -z "$2" ]; then
            echo "Usage: mcp-firecrawl.sh map <url> [limit]"
            exit 1
        fi
        URL="$2"
        LIMIT="${3:-50}"
        
        JSON_PAYLOAD=$(cat <<EOF
{
  "url": "$URL",
  "options": {
    "limit": $LIMIT
  }
}
EOF
)
        
        curl -s -X POST "$BASE_URL/map" \
          -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
          -H "Content-Type: application/json" \
          -d "$JSON_PAYLOAD"
        ;;
        
    "search")
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo "Usage: mcp-firecrawl.sh search <query> <url> [limit]"
            exit 1
        fi
        QUERY="$2"
        URL="$3"
        LIMIT="${4:-10}"
        
        JSON_PAYLOAD=$(cat <<EOF
{
  "query": "$QUERY",
  "url": "$URL",
  "limit": $LIMIT
}
EOF
)
        
        curl -s -X POST "$BASE_URL/search" \
          -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
          -H "Content-Type: application/json" \
          -d "$JSON_PAYLOAD"
        ;;
        
    *)
        echo "Available commands:"
        echo "  scrape <url> [formats] - Scrape a single URL"
        echo "  crawl <url> [max_depth] [limit] - Crawl an entire website"
        echo "  crawl-status <job_id> - Check crawl job status"
        echo "  map <url> [limit] - Map website structure"
        echo "  search <query> <url> [limit] - Search within crawled content"
        echo ""
        echo "Examples:"
        echo "  ./mcp-firecrawl.sh scrape \"https://example.com\" \"markdown,links\""
        echo "  ./mcp-firecrawl.sh crawl \"https://example.com\" 2 5"
        echo "  ./mcp-firecrawl.sh map \"https://example.com\" 100"
        exit 1
        ;;
esac