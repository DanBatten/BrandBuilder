"""
BrandLaunch CEO API Server
Provides localhost API endpoints for agents to interact with Notion and Firecrawl
"""
import os
import json
import asyncio
from typing import Optional, Dict, Any, List
from datetime import datetime

import requests
import httpx
from fastapi import FastAPI, HTTPException, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from dotenv import load_dotenv
from notion_client import Client

# Load environment variables
load_dotenv()

app = FastAPI(
    title="BrandLaunch CEO API Server",
    description="Local API server for autonomous brand development agents",
    version="1.0.0"
)

# Enable CORS for localhost
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize API clients
NOTION_TOKEN = os.getenv("NOTION_TOKEN")
FIRECRAWL_API_KEY = os.getenv("FIRECRAWL_API_KEY")

if not NOTION_TOKEN:
    print("⚠️  Warning: NOTION_TOKEN not set")
if not FIRECRAWL_API_KEY:
    print("⚠️  Warning: FIRECRAWL_API_KEY not set")

notion = Client(auth=NOTION_TOKEN) if NOTION_TOKEN else None

# Pydantic models for API requests
class NotionCreatePageRequest(BaseModel):
    parent_id: Optional[str] = None  # Empty string or None for root page
    title: str
    content: Optional[str] = None

class NotionAddContentRequest(BaseModel):
    page_id: str
    content_type: str  # "paragraph", "heading1", "heading2", etc.
    title: Optional[str] = None
    content: str

class FirecrawlScrapeRequest(BaseModel):
    url: str
    formats: List[str] = ["markdown"]

class FirecrawlCrawlRequest(BaseModel):
    url: str
    max_depth: Optional[int] = 2
    limit: Optional[int] = 10

# Health check endpoint
@app.get("/")
async def health_check():
    return {
        "status": "healthy",
        "service": "BrandLaunch CEO API Server",
        "timestamp": datetime.now().isoformat(),
        "notion_configured": NOTION_TOKEN is not None,
        "firecrawl_configured": FIRECRAWL_API_KEY is not None
    }

# Notion API endpoints
@app.post("/notion/create-page")
async def create_notion_page(request: NotionCreatePageRequest):
    """Create a new Notion page"""
    if not notion:
        raise HTTPException(status_code=500, detail="Notion API not configured")
    
    try:
        # Determine parent
        if request.parent_id and request.parent_id.strip():
            parent = {"page_id": request.parent_id}
        else:
            # Create as root page in workspace
            parent = {"type": "page_id", "page_id": ""}  # This might need workspace adjustment
        
        # Create page properties
        properties = {
            "title": {
                "title": [
                    {
                        "text": {
                            "content": request.title
                        }
                    }
                ]
            }
        }
        
        # Create initial page structure
        page_data = {
            "parent": parent,
            "properties": properties
        }
        
        # Add initial content if provided
        if request.content:
            children = [
                {
                    "object": "block",
                    "type": "paragraph",
                    "paragraph": {
                        "rich_text": [
                            {
                                "type": "text",
                                "text": {
                                    "content": request.content[:2000]  # Notion has limits
                                }
                            }
                        ]
                    }
                }
            ]
            page_data["children"] = children
        
        # Create page via Notion API
        page = notion.pages.create(**page_data)
        
        return {
            "success": True,
            "page_id": page["id"],
            "url": page["url"],
            "title": request.title
        }
        
    except Exception as e:
        print(f"Notion create page error: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to create Notion page: {str(e)}")

@app.post("/notion/add-content")
async def add_notion_content(request: NotionAddContentRequest):
    """Add content blocks to an existing Notion page"""
    if not notion:
        raise HTTPException(status_code=500, detail="Notion API not configured")
    
    try:
        # Create content block based on type
        if request.content_type == "heading1":
            block = {
                "object": "block",
                "type": "heading_1",
                "heading_1": {
                    "rich_text": [
                        {
                            "type": "text",
                            "text": {
                                "content": request.title or request.content[:100]
                            }
                        }
                    ]
                }
            }
        elif request.content_type == "heading2":
            block = {
                "object": "block",
                "type": "heading_2",
                "heading_2": {
                    "rich_text": [
                        {
                            "type": "text",
                            "text": {
                                "content": request.title or request.content[:100]
                            }
                        }
                    ]
                }
            }
        elif request.content_type == "paragraph":
            # Split long content into multiple paragraphs (Notion has 2000 char limit)
            content_chunks = [request.content[i:i+1900] for i in range(0, len(request.content), 1900)]
            blocks = []
            
            for chunk in content_chunks:
                blocks.append({
                    "object": "block",
                    "type": "paragraph",
                    "paragraph": {
                        "rich_text": [
                            {
                                "type": "text",
                                "text": {
                                    "content": chunk
                                }
                            }
                        ]
                    }
                })
            
            # Add all blocks
            for block in blocks:
                notion.blocks.children.append(request.page_id, children=[block])
            
            return {
                "success": True,
                "blocks_added": len(blocks),
                "content_length": len(request.content)
            }
        else:
            block = {
                "object": "block",
                "type": "paragraph",
                "paragraph": {
                    "rich_text": [
                        {
                            "type": "text",
                            "text": {
                                "content": request.content[:1900]
                            }
                        }
                    ]
                }
            }
        
        # Add single block
        notion.blocks.children.append(request.page_id, children=[block])
        
        return {
            "success": True,
            "block_type": request.content_type,
            "content_length": len(request.content)
        }
        
    except Exception as e:
        print(f"Notion add content error: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to add content to Notion: {str(e)}")

@app.get("/notion/search")
async def search_notion(query: str):
    """Search Notion pages"""
    if not notion:
        raise HTTPException(status_code=500, detail="Notion API not configured")
    
    try:
        results = notion.search(query=query)
        
        pages = []
        for result in results.get("results", []):
            if result["object"] == "page":
                title = ""
                if "properties" in result and "title" in result["properties"]:
                    title_prop = result["properties"]["title"]
                    if "title" in title_prop and title_prop["title"]:
                        title = title_prop["title"][0]["text"]["content"]
                
                pages.append({
                    "id": result["id"],
                    "title": title,
                    "url": result["url"]
                })
        
        return {
            "success": True,
            "results": pages,
            "count": len(pages)
        }
        
    except Exception as e:
        print(f"Notion search error: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to search Notion: {str(e)}")

# Firecrawl API endpoints
@app.post("/firecrawl/scrape")
async def scrape_url(request: FirecrawlScrapeRequest):
    """Scrape a single URL using Firecrawl"""
    if not FIRECRAWL_API_KEY:
        raise HTTPException(status_code=500, detail="Firecrawl API not configured")
    
    try:
        url = "https://api.firecrawl.dev/v1/scrape"
        headers = {
            "Authorization": f"Bearer {FIRECRAWL_API_KEY}",
            "Content-Type": "application/json"
        }
        data = {
            "url": request.url,
            "formats": request.formats
        }
        
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.post(url, headers=headers, json=data)
            response.raise_for_status()
            result = response.json()
        
        return {
            "success": True,
            "url": request.url,
            "data": result.get("data", {}),
            "formats": request.formats
        }
        
    except Exception as e:
        print(f"Firecrawl scrape error: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to scrape URL: {str(e)}")

@app.post("/firecrawl/crawl")
async def crawl_website(request: FirecrawlCrawlRequest):
    """Crawl a website using Firecrawl"""
    if not FIRECRAWL_API_KEY:
        raise HTTPException(status_code=500, detail="Firecrawl API not configured")
    
    try:
        url = "https://api.firecrawl.dev/v1/crawl"
        headers = {
            "Authorization": f"Bearer {FIRECRAWL_API_KEY}",
            "Content-Type": "application/json"
        }
        data = {
            "url": request.url,
            "crawlerOptions": {
                "maxDepth": request.max_depth,
                "limit": request.limit
            }
        }
        
        async with httpx.AsyncClient(timeout=60.0) as client:
            response = await client.post(url, headers=headers, json=data)
            response.raise_for_status()
            result = response.json()
        
        return {
            "success": True,
            "url": request.url,
            "job_id": result.get("id"),
            "status": result.get("status")
        }
        
    except Exception as e:
        print(f"Firecrawl crawl error: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to crawl website: {str(e)}")

# Utility endpoints for agents
@app.post("/agents/log")
async def agent_log(data: Dict[str, Any]):
    """Log agent activity for debugging"""
    timestamp = datetime.now().isoformat()
    print(f"[{timestamp}] Agent Log: {json.dumps(data, indent=2)}")
    return {"logged": True, "timestamp": timestamp}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000, log_level="info")