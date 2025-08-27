# BrandLaunch CEO API Server Setup Guide

## 🎯 **What This Solves**

The BrandLaunch CEO system needed a way for agents to autonomously interact with external services (Notion, Firecrawl) from the Claude Code terminal. Since MCP only works in Claude Desktop, we built a local API server that agents can call using WebFetch.

## 🏗️ **Architecture Overview**

```
┌─────────────────────────────────────────────────┐
│          Claude Code Terminal                    │
│  ┌─────────────────────────────────────────┐    │
│  │   Agents (market-intelligence, etc.)    │    │
│  │   Use WebFetch to call localhost:8000   │    │
│  └──────────────┬──────────────────────────┘    │
└─────────────────┼────────────────────────────────┘
                  │
                  ▼ HTTP calls via WebFetch
┌──────────────────────────────────────────────────┐
│        FastAPI Server (localhost:8000)          │
│  - Notion API integration                        │
│  - Firecrawl API integration                     │
│  - Handles authentication & API calls           │
└────────────┬─────────────────────┬───────────────┘
             │                     │
             ▼                     ▼
      ┌──────────┐         ┌──────────────┐
      │  Notion  │         │  Firecrawl   │
      │   API    │         │     API      │
      └──────────┘         └──────────────┘
```

## 🚀 **Quick Start**

### 1. **Set Up API Keys**

Copy the environment template:
```bash
cd api-server
cp .env.example .env
```

Edit `.env` with your actual API keys:
```bash
# Notion Integration Token
# Get from: https://www.notion.so/my-integrations
NOTION_TOKEN=ntn_your_notion_token_here

# Firecrawl API Key  
# Get from: https://www.firecrawl.dev/
FIRECRAWL_API_KEY=fc-your_firecrawl_key_here
```

### 2. **Start the API Server**

The server has an automated start script:
```bash
cd api-server
./start-server.sh
```

This will:
- Create a Python virtual environment
- Install dependencies (FastAPI, Notion client, etc.)
- Start the server on http://localhost:8000

### 3. **Verify Server is Running**

Check the health endpoint:
```bash
curl http://localhost:8000/
```

You should see:
```json
{
  "status": "healthy",
  "service": "BrandLaunch CEO API Server",
  "notion_configured": true,
  "firecrawl_configured": true
}
```

View interactive API docs at: http://localhost:8000/docs

### 4. **Test Notion Integration**

Create a test page:
```bash
curl -X POST http://localhost:8000/notion/create-page \
  -H "Content-Type: application/json" \
  -d '{"title": "Test Page", "content": "This is a test"}'
```

### 5. **Test Firecrawl Integration**

Scrape a website:
```bash
curl -X POST http://localhost:8000/firecrawl/scrape \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com", "formats": ["markdown"]}'
```

## 📋 **API Endpoints**

### **Notion Endpoints**

#### Create Page
```
POST /notion/create-page
Content-Type: application/json

{
  "parent_id": "optional-parent-page-id",
  "title": "Page Title",
  "content": "Optional initial content"
}
```

#### Add Content to Page
```
POST /notion/add-content
Content-Type: application/json

{
  "page_id": "page-id-here",
  "content_type": "paragraph",
  "content": "Content to add"
}
```

#### Search Pages
```
GET /notion/search?query=search-term
```

### **Firecrawl Endpoints**

#### Scrape Single URL
```
POST /firecrawl/scrape
Content-Type: application/json

{
  "url": "https://website.com",
  "formats": ["markdown"]
}
```

#### Crawl Website
```
POST /firecrawl/crawl
Content-Type: application/json

{
  "url": "https://website.com",
  "max_depth": 2,
  "limit": 10
}
```

## 🤖 **How Agents Use the API**

The agents have been updated to use WebFetch to call the localhost API:

### **Market Intelligence Agent**
- Uses `POST /firecrawl/scrape` to analyze competitor websites
- Uses `POST /notion/create-page` and `/notion/add-content` to publish research
- Creates local MD files first, then syncs to Notion

### **Brand Strategy Agent**  
- Uses Notion endpoints to publish strategy documents
- Creates comprehensive local strategy files
- Publishes both main document and creative handoff summary

### **Agent Execution Flow**
1. **Local File Creation** (guaranteed to work)
2. **API Server Integration** (enhanced collaboration via Notion)
3. **Error Graceful Handling** (continues if API fails)

## 🔧 **Development & Debugging**

### **Server Logs**
The server runs with detailed logging. Watch for:
- API call successes/failures
- Authentication issues
- Notion/Firecrawl API responses

### **Testing Individual Endpoints**
Use the interactive docs at http://localhost:8000/docs to test endpoints manually.

### **Common Issues**

**"Notion API not configured"**
- Check that `NOTION_TOKEN` is set in `.env`
- Verify token has access to your workspace

**"Firecrawl API not configured"**
- Check that `FIRECRAWL_API_KEY` is set in `.env`
- Verify your Firecrawl account has API access

**"Connection refused"**
- Make sure API server is running on port 8000
- Check no other services are using port 8000

### **Manual Server Start**
If the start script doesn't work:
```bash
cd api-server
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python main.py
```

## 🎯 **Benefits of This Architecture**

### ✅ **Full Automation**
- Agents can create Notion pages autonomously
- No manual sync steps required
- Web scraping integrated into research workflow

### ✅ **Terminal Workflow**
- Agents run in Claude Code terminal with full file access
- No need to switch to Claude Desktop
- Complete local project structure maintained

### ✅ **Error Resilience**
- Local files always created (guaranteed output)
- Notion integration enhances but doesn't block workflow
- Graceful degradation if API server is down

### ✅ **Security**
- API keys stored only in server environment
- Never exposed to agents or logs
- Local server, no external authentication needed

### ✅ **Development Experience**
- Interactive API documentation
- Easy testing and debugging
- Standard REST API interface

## 🚀 **Next Steps**

1. **Start the API server** using the setup instructions above
2. **Test the endpoints** to ensure everything works
3. **Run a brand project** through the brandlaunch-ceo system
4. **Monitor logs** to see API integration in action

The agents are now configured to use this API server automatically when you run brand development projects through the terminal!