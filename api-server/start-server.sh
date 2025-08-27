#!/bin/bash
# Start the BrandLaunch CEO API Server

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "❌ .env file not found!"
    echo "Please copy .env.example to .env and add your API keys:"
    echo "  cp .env.example .env"
    echo "  # Then edit .env with your actual tokens"
    exit 1
fi

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "🔧 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install dependencies
echo "📦 Installing dependencies..."
pip install -r requirements.txt

# Start the server
echo "🚀 Starting BrandLaunch CEO API Server on http://localhost:8000"
echo "📚 API docs available at: http://localhost:8000/docs"
echo "🛑 Press Ctrl+C to stop"
python main.py