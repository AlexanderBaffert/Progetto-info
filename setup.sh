#!/bin/bash

echo "Setting up virtual environment for Progetto-info-3..."

# Check if Python 3 is available
if ! command -v python3 &> /dev/null
then
    echo "Python 3 is not installed. Please install it first."
    exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    if [ $? -ne 0 ]; then
        echo "Failed to create virtual environment. Make sure python3-venv is installed:"
        echo "sudo apt install python3-full python3-venv"
        exit 1
    fi
else
    echo "Virtual environment already exists."
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Install requirements
echo "Installing dependencies..."
pip install -r requirements.txt

echo ""
echo "Setup complete! You can now run the application with:"
echo "source venv/bin/activate"
echo "python server.py"
echo ""
echo "Access the application at http://127.0.0.1:5000/"
